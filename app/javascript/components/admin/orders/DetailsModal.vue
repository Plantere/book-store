<script setup lang="ts">
import { ref } from 'vue';
import { formatMoney, convertStringToNumber } from '@/helpers/exchange-helper';
import Icon from '../../shares/Icon.vue';
import type { IOrder } from '@/interfaces/order';
import { getImage } from '@/services/supabase-service';

const statusModal = ref(false)
const orderData = ref<IOrder | null>()

const handleModal = (value: boolean, order?: IOrder) => {
  statusModal.value = value
  orderData.value = order 
}

defineExpose({
  handleModal,
})

</script>

<template>
  <div v-if="statusModal && orderData">
    <div class="relative z-10">
      <div>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
      </div>

      <div class="fixed inset-0 z-10 w-screen overflow-x-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0 ">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl  my-8 w-full max-w-screen-lg">
            <div class="relative p-4">
              <span class="text-xl font-semibold">Order #{{ orderData.id }} </span>
              <div class="absolute top-0 right-0 p-5 cursor-pointer" @click="handleModal(false)">
                <Icon name="xmark" class="w-6"></Icon>
              </div>
            </div>

            <hr class="w-full mb-4">
            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-3/6">
                <div>
                  <span class="text-xl font-semibold">
                    Itens
                  </span>
                </div>

                <div class="flex flex-col gap-5 my-5 ml-3">
                  <div class="flex flex-row space-x-2 items-center" v-for="book in orderData.details" :key="book.id">
                    <div>
                      <img class="w-20 rounded-xl" :src="getImage(book.image)" alt="">
                    </div>
                    <div class="flex flex-col">
                      <span class="font-bold text-xl">{{ book.name }}</span>
                      <span class="font-semibold text-md">{{ book.quantity }}x {{ formatMoney(book.price) }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="flex flex-col px-4 w-3/6 justify-center">
                <div>
                  <span class="text-xl font-semibold">
                    Receipt
                  </span>
                </div>

                <div class="flex flex-col">
                  <div class="flex flex-row justify-between">
                    <span>Subtotal</span>
                    <span>{{ formatMoney(orderData.price) }}</span>
                  </div>
                  <div class="flex flex-row justify-between">
                    <span>Shipping Total</span>
                    <span>{{ formatMoney(5.00) }}</span>
                  </div>
                  <div class="flex flex-row justify-between">
                    <span>Total</span>
                    <span>{{ formatMoney(convertStringToNumber(orderData.price) + 5.00) }}</span>
                  </div>
                </div>
                <div class="my-5 p-3 border rounded-2xl">
                  <span class="text-xl font-semibold">Shipping Address</span>
                  <div class="flex flex-col">
                    <span class="text-sm">{{orderData.address.street}} {{orderData.address.number}}, {{orderData.address.district}}</span>
                    <span class="text-sm">{{orderData.address.city}}, {{orderData.address.state}} - {{orderData.address.postal_code}}</span>
                    <span class="text-sm">{{orderData.address.phone_number}}</span>
                  </div>
                </div>

                <div class="mt-5 p-3 border rounded-2xl" v-if="orderData.description">
                  <span class="text-xl font-semibold">Observation</span>
                  <div class="flex flex-col">
                    <span class="text-sm">{{orderData.description}}</span>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>