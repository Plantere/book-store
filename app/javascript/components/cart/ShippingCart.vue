<script setup lang="ts">
import { ref, computed, reactive} from 'vue';
import { formatMoney } from '@/helpers/exchange-helper';
import { makeRequest } from '@/utils/request';
import { api_v1_addresses_get_path } from '@/utils/routes';
import Icon from '@/components/shares/Icon.vue';
import Pagination from '@/components/shares/Pagination.vue';
import FormAddress from '@/components/address/FormAddress.vue';

import type { Address } from '@/interfaces/address'
import type { ItemsCart } from '@/interfaces/cart'

const props = defineProps<ItemsCart>()
const emit = defineEmits(["nextTab", "previousTab"])

const shippingInformations = reactive({
  address_id: 0,
  shipping_id: 1
})

const addressesList = ref<Address[]>([])
const paginationConfig = ref({
  totalItems: 0,
  currentPage: 1,
  perPage: 5,
})

const showMore = ref(false)

const formAddressModal = ref<InstanceType<typeof FormAddress> | null>(null)
const openFormAddress = (address = undefined) => {
  formAddressModal.value?.openModal(address)
}

const nextTab = () => {
  emit("nextTab")
}

const previousTab = () => {
  emit("previousTab")
}

const isPaymentAvailable = computed(() => {
  return shippingInformations.address_id !== 0 && shippingInformations.shipping_id !== 0
})

const getTotalCart = computed(() => {
  return props.cart.reduce((acc, item) => {
    return acc + (item.cart_quantity * item.price)
  }, 0)
})

const getAddresses = async (page = 1) => {
  const response = await makeRequest(api_v1_addresses_get_path({page}), {method: "GET"})

  if(!response.ok){
    addressesList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 5,
    }
  }

  const data = await response.json();

  addressesList.value = data.data

  const address = addressesList.value.find(address => address.is_default === true)

  if(!address) {
    shippingInformations.address_id = 0
    return
  }

  shippingInformations.address_id = address.id

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
  
  paginationConfig.value = {
    totalItems: data.pagination.count,
    currentPage: data.pagination.page,
    perPage: 5
  }
}

getAddresses()

</script>

<template>
  <div class="relative w-full flex bg-white rounded-md">
    <div class="absolute top-5 right-3 flex flex-row-reverse justify-center items-center" @click="previousTab()">
      <span class="p-1 mb-1 text-medium">Back</span>
      <Icon name="previous" class="w-2"></Icon>
    </div>
    <div class="flex flex-col w-5/6 p-5 mt-5">
      <span class="text-md font-semibold leading-6 text-gray-600">Select your preferable address</span>
      <div>
        <div class="grid grid-cols-2">
          <div class="border rounded-lg p-5 m-5 cursor-pointer" v-for="address in addressesList" @click="shippingInformations.address_id = address?.id">
            <div>
              <input type="radio" name="address.id.toString()" v-model="shippingInformations.address_id" :value="address?.id" :id="address.id.toString()" class="w-4 h-4 text-violet-600 bg-gray-100 border-gray-300 focus:ring-violet-500 focus:ring-2">
              <label :for="address?.id.toString()" class="font-semibold p-5">{{address?.name}}</label>
            </div>
            <div class="flex flex-col">
              <span class="text-sm text-gray-600">{{ address.street }} {{ address.number }}</span>
              <span class="text-sm text-gray-600">{{ address.district }}</span>
              <span class="text-sm text-gray-600">{{ address.city }}, {{ address.state }} - {{ address.postal_code }}</span>
              <span class="text-sm text-gray-600">{{ address.country }}</span>
              <span class="text-sm text-gray-600">{{ address.phone_number }}</span>
            </div>
          </div>
        </div>
        <div class="flex flex-row justify-center m-2" v-if="paginationConfig.totalItems > paginationConfig.perPage">
          <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getAddresses" />
        </div>
        <button @click="openFormAddress()" class="rounded-md w-full block bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Add New Address</button>
      </div>

      <hr class="m-5">
      <div>
        <span class="pl-2 text-md font-semibold leading-6 text-gray-600">Choose Delivery Speed</span>
        <div class="grid grid-cols-2">
          <div class="relative rounded-md border m-5 p-10 cursor-pointer" @click="shippingInformations.shipping_id = 1">
            <input type="radio" :value="1" v-model="shippingInformations.shipping_id" class="absolute top-0 left-0 m-5 w-4 h-4 text-violet-600 bg-gray-100 border-gray-300 focus:ring-violet-500 focus:ring-2">
            <span class="absolute right-0 top-0 m-5 text-gray-600 font-semibold">$ 5</span>
            <div class="flex flex-col justify-center items-center">
              <Icon name="profile" class="w-7 h-7 text-gray-600" />
              <span class="text-gray-600 text-center">Standard</span>
              <span class="text-gray-600 text-center">Get your product in 4 days</span>
            </div>
          </div>

        </div>
      </div>


    </div>
    <div class="flex flex-col w-2/6 p-5 mt-5">
      <span class="text-md font-semibold leading-6 text-gray-600">Estimated Delivery Date</span>
      <div class="flex flex-col">
        <div v-for="(cart, index) in props.cart" :key="cart.id">
          <div class="flex mt-5" v-if="index < 3">
            <div class="relative">
              <div class="t-0 absolute right-0 bottom-0">
                <p class="flex h-2 w-2 items-center justify-center rounded-full bg-violet-500 p-3 text-xs text-white">{{ cart.cart_quantity }}</p>
              </div>
              <img width="50" class="border rounded-lg" src="https://m.media-amazon.com/images/I/616U6mSP3lL._SL1000_.jpg" alt="">
            </div>
            <div class="min-w-0 flex flex-col p-2">
              <p class="text-md text-gray-500 truncate">{{ cart.name }}</p>
              <span class="font-semibold text-sm text-gray-600">10th Fev 2024</span>
            </div>
          </div>

          <div class="flex mt-5" v-else-if="showMore">
            <div class="relative">
              <div class="t-0 absolute right-0 bottom-0">
                <p class="flex h-2 w-2 items-center justify-center rounded-full bg-violet-500 p-3 text-xs text-white">{{ cart.cart_quantity }}</p>
              </div>
              <img width="50" class="border rounded-lg" src="https://m.media-amazon.com/images/I/616U6mSP3lL._SL1000_.jpg" alt="">
            </div>
            <div class="min-w-0 flex flex-col p-2">
              <p class="text-md text-gray-500 truncate">{{ cart.name }}</p>
              <span class="font-semibold text-sm text-gray-600">10th Fev 2024</span>
            </div>
          </div>
        </div>

        <div class="flex flex-col justify-center items-center mt-5" v-if="cart.length > 3">
          <button class="rounded-md block w-full bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600" @click="showMore = !showMore">{{ showMore ? "Hide" : "Show more"}}</button>
        </div>

      </div>
      <hr class="m-5">

      <div class="space-y-1">
        <span class="text-md font-semibold leading-6 text-gray-600">Price Detail</span>
        <div class="flex flex-col">
          <div class="flex justify-between">
            <span class="text-md font-normal leading-6 text-black">Order Total</span>
            <span class="text-md font-normal leading-6 text-black">{{formatMoney(getTotalCart)}}</span>
          </div>

          <div class="flex justify-between">
            <span class="text-md font-normal leading-6 text-black">Delivery Charges</span>
            <span class="text-md font-normal leading-6 text-black">{{formatMoney(5.00)}}</span>
          </div>

          <hr class="m-5">

          <div class="flex justify-between">
            <span class="text-md font-semibold leading-6 text-gray-600">Total</span>
            <span class="text-md font-normal leading-6 text-black">{{formatMoney(getTotalCart + 5.00)}}</span>
          </div>
        </div>
      </div>

      <hr class="m-5 border-gray-300">
      <div class="flex justify-center">
        <button @click="nextTab()" :disabled="!isPaymentAvailable" class="rounded-md block w-full bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600 disabled:opacity-50">Payment</button>
      </div>
    </div>
    <FormAddress ref="formAddressModal" @update-address="getAddresses"></FormAddress>
  </div>
</template>