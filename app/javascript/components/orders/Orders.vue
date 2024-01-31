<script setup lang="ts">
import { ref } from 'vue';
import Icon from '../../components/shares/Icon.vue';
import Pagination from '../../components/shares/Pagination.vue';
import CardOrder from './CardOrder.vue';
import { makeRequest } from '../../utils/request';
import { api_v1_orders_get_path } from '../../utils/routes';

const orders = ref([]);
let paginationConfig = ref({
  totalItems: 0,
  currentPage: 1,
  perPage: 5
});

const getOrders = async (page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_orders_get_path({page}), {method: "GET"})

  if(!response.ok){
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 5
    }
    return
  }

  const data = await response.json()
  
  orders.value = data.data

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

getOrders()

</script>

<template>
  <div>
    <div class="flex px-5">
      <Icon name="cart" class="flex items-center w-6 mr-3 mt-6" />
      <h1 class="text-2xl py-5 font-bold">Orders</h1>
    </div>
    <hr>

    <div class="p-5">
      <div v-for="(order, index) in orders" :key="order?.id" >
        <CardOrder :order="order"/>
        <hr class="my-5" v-if="index != orders.length-1">
      </div>
    </div>

    <div class="flex justify-center m-10" v-if="orders.length > 0">
      <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getOrders" />
    </div>

    <div class="flex justify-center m-10" v-else>
      <span class="font-semibold text-xl ">No orders found!</span>
    </div>
  </div>
</template>