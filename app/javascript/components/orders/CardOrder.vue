<script setup lang="ts">
import { computed, ref } from 'vue';
import Icon from '@/components/shares/Icon.vue';
import type { IOrderItem } from '@/interfaces/order';
import { formatMoney } from '@/helpers/exchange-helper';
import { formatDate } from '@/helpers/date-helper';
import { useRouter } from 'vue-router';
import { getImage } from '@/services/supabase-service';

const props = defineProps<IOrderItem>()
const router = useRouter()

const collapse = ref(false)
const showMore = ref(false)

const statusOrder = computed(() => {
  if(props.order.status === 1){
    return {name: "Processing", icon: "loading", class: "bg-yellow-200", classIcon: "w-5 h-5 text-white animate-spin fill-blue-600"}
  }else if(props.order.status === 2){
    return {name: "Delivered", icon: "truck", class: "bg-green-100", classIcon: ""}
  }else if(props.order.status === 3){
    return {name: "Approved", icon: "check", class: "bg-green-100", classIcon: ""}
  }else if(props.order.status === 4){
    return {name: "Denied", icon: "xmark", class: "bg-red-200", classIcon: ""}
  }

  return false
})

const redirectBookPage = (bookId: number) => {
  router.push({name: "show-book", params: {book_id: bookId}})
}

</script>

<template>
  <div v-if="statusOrder">
    <div class="mb-4 flex flex-col">
      <div class="flex justify-between">
        <div class="flex">
          <span class="text-2xl font-semibold">Order. {{props.order.id}}</span>
          <div :class="statusOrder.class" class="flex ml-2 items-center space-x-2 px-3 rounded-xl">
            <Icon :class="statusOrder.classIcon" :name="statusOrder.icon" class="w-5 flex items-center"></Icon>
            <span class="font-semibold">{{statusOrder.name}}</span>
          </div>
        </div>

        <div class="flex" @click="collapse = !collapse">
          <Icon v-if="!collapse" class="h-5 w-5" name="down" />
          <Icon v-if="collapse" class="h-5 w-5" name="up" />
        </div>
      </div>

      <div class="text-sm mt-1 flex flex-col" v-if="collapse">
        <span><b>Purchase Date:</b> {{formatDate(props.order.created_at)}}</span>
        <span><b>Purchase Total:</b> {{formatMoney(props.order.price)}} </span>
        <span><b>Address:</b> {{props.order.address.street}}, {{props.order.address.number}}, {{props.order.address.district}} ({{props.order.address.name}}) </span>
        <span><b>Observation:</b> {{props.order.description}} </span>
      </div>
    </div>

    <hr class="mb-3 w-1/2 mx-auto">

    <div v-for="(bookDetail, index) in props.order.details" :key="bookDetail?.id" class="flex flex-col">
      <div class="flex space-x-4 mt-4" v-if="index < 3">
        <img class="rounded-lg border  h-32 w-[100px] cursor-pointer" :src="getImage(bookDetail?.image)" alt="" @click="redirectBookPage(bookDetail?.id)">
        <div class="flex flex-col justify-center w-screen">
          <span class="text-xl font-medium text-gray-700 cursor-pointer" @click="redirectBookPage(bookDetail?.id)">{{bookDetail?.name}}</span>
          <div class="flex justify-between mt-2">
            <span class="text-xl font-medium text-gray-800">{{bookDetail?.quantity}} x {{formatMoney(bookDetail?.price)}}</span>
            <button class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6 disabled:opacity-50" disabled>Evalute the Product</button>
          </div>
        </div>
      </div>
      <div class="flex space-x-4 mt-4" v-else-if="showMore">
        <img class="rounded-lg border h-32 w-[100px]" :src="getImage(bookDetail?.image)">
        <div class="flex flex-col justify-center w-screen">
          <span class="text-xl font-medium text-gray-700">{{bookDetail?.name}}</span>
          <div class="flex justify-between mt-2">
            <span class="text-xl font-medium text-gray-800">{{bookDetail?.quantity}} x {{formatMoney(bookDetail?.price)}}</span>
            <button class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6 disabled:opacity-50" disabled>Evalute the Product</button>
          </div>
        </div>
      </div>
    </div>

    <div class="flex flex-col justify-center items-center" v-if="props.order.details.length > 3">
      <span class="text-4xl font-semibold text-violet-500" v-if="!showMore">...</span>
      <div class="mt-4">
        <button class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6" @click="showMore = !showMore">{{ showMore ? "Hide" : "Show more"}}</button>
      </div>
    </div>
  </div>
</template>