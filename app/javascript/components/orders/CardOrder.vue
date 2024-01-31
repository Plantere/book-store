<script setup lang="ts">
import { ref } from 'vue';
import Icon from '../../components/shares/Icon.vue';


const props = defineProps({
  order: Object
})

const collapse = ref(false)
const showMore = ref(false)

const statusOrder = {
  1: {name: "Processing", icon: "loading", class: "bg-yellow-200", classIcon: "w-5 h-5 text-white animate-spin fill-blue-600"},
  2: {name: "Delivered", icon: "truck", class: "bg-green-100", classIcon: ""},
  3: {name: "Denied", icon: "xmark", class: "bg-red-200", classIcon: ""},
}

const formatDate = (date) => {
  let utcDate = new Date(date);
  let dateFormatter = new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });

  let timeFormatter = new Intl.DateTimeFormat('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
  });

  return dateFormatter.format(utcDate) + ' at ' + timeFormatter.format(utcDate).replace(" ", "").replace('AM', 'am').replace('PM', 'pm');
}

const formatMoney = (money) => {
  return parseFloat(money).toLocaleString('en-US', {
    style: 'currency',
    currency: 'USD',
  });

}

</script>

<template>
  <div>
    <div class="mb-4 flex flex-col">
      <div class="flex justify-between">
        <div class="flex">
          <span class="text-2xl font-semibold">Order. {{order?.id}}</span>
          <div :class="statusOrder[order?.status].class" class="flex ml-2 items-center space-x-2 px-3 rounded-xl">
            <Icon :class="statusOrder[order?.status].classIcon" :name="statusOrder[order?.status].icon" class="w-5 flex items-center"></Icon>
            <span class="font-semibold">{{statusOrder[order?.status].name}}</span>
          </div>
        </div>

        <div class="flex">
          <Icon v-if="!collapse" class="h-5 w-5" name="down" @click="collapse = !collapse"/>
          <Icon v-if="collapse" class="h-5 w-5" name="up" @click="collapse = !collapse"/>
        </div>
      </div>

      <div class="text-sm mt-1 flex flex-col" v-if="collapse">
        <span><b>Purchase Date:</b> {{formatDate(order?.created_at)}}</span>
        <span><b>Purchase Total:</b> {{formatMoney(order?.price)}} </span>
        <span><b>Address:</b> {{order?.address.street}}, {{order?.address.number}}, {{order?.address.district}} ({{order?.address.name}}) </span>
        <span><b>Observation:</b> {{order?.description}} </span>
      </div>
    </div>

    <hr class="mb-3 w-1/2 mx-auto">

    <div v-for="(bookDetail, index) in order?.details" :key="bookDetail?.id" class="flex flex-col">
      <div class="flex space-x-4 mt-4" v-if="index < 3">
        <img class="rounded-lg border  h-32" :src="bookDetail?.image" alt="">
        <div class="flex flex-col justify-center w-screen">
          <span class="text-xl font-bold text-gray-700">{{bookDetail?.name}}</span>
          <div class="flex justify-between mt-2">
            <span class="text-xl font-bold text-gray-800">{{bookDetail?.quantity}} x {{formatMoney(bookDetail?.price)}}</span>
            <button class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6 disabled:opacity-50" disabled>Evalute the Product</button>
          </div>
        </div>
      </div>
      <div class="flex space-x-4 mt-4" v-else-if="showMore">
        <img class="rounded-lg border h-32" :src="bookDetail?.image">
        <div class="flex flex-col justify-center w-screen">
          <span class="text-xl font-bold text-gray-700">{{bookDetail?.name}}</span>
          <div class="flex justify-between mt-2">
            <span class="text-xl font-bold text-gray-800">{{bookDetail?.quantity}} x {{formatMoney(bookDetail?.price)}}</span>
            <button class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6 disabled:opacity-50" disabled>Evalute the Product</button>
          </div>
        </div>
      </div>
    </div>

    <div class="flex flex-col justify-center items-center" v-if="order?.details.length > 3">
      <span class="text-4xl font-semibold text-violet-500" v-if="!showMore">...</span>
      <div class="mt-4">
        <button class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6" @click="showMore = !showMore">{{ showMore ? "Hide" : "Show more"}}</button>
      </div>
    </div>
  </div>
</template>