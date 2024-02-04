<script setup lang="ts">
import Filter from "@/components/admin/orders/Filter.vue"
import OrdersTable from "@/components/admin/orders/table/OrdersTable.vue"
import { ref, onBeforeMount } from 'vue';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_orders_get_all_path } from '@/utils/routes';
import Pagination from '@/components/shares/Pagination.vue';
import DetailsModal from './DetailsModal.vue';
import type { IOrder } from '@/interfaces/order'
import type { IPagination} from '@/interfaces/pagination'

interface FormSearch {
  status?: string,
  date?: string,
  search?: string,
}

const formSearch = ref<FormSearch>({
  status: undefined,
  search: undefined,
  date: undefined,
})

const ordersList = ref<IOrder[]>()
const paginationConfig = ref<IPagination>({
  totalItems: 0,
  currentPage: 1,
  perPage: 15,
})

const detailsModal = ref<InstanceType<typeof DetailsModal> | null>(null)

const getOrders = async (search = formSearch.value, page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_admin_orders_get_all_path({page, ...search}), {method: "GET"})
  formSearch.value = search

  if(!response.ok) {
    ordersList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 15,
    }
  }

  const data = await response.json();

  ordersList.value = data.data
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
  
  paginationConfig.value = {
    totalItems: data.pagination.count,
    currentPage: data.pagination.page,
    perPage: 15
  }
}

const emitOpenDetail = (orderDetail: IOrder) => {
  if(!detailsModal) return

  detailsModal.value?.handleModal(true, orderDetail)
}

onBeforeMount(() => {
  getOrders()
})

</script>
<template>
  <div>
    <Filter @search-order="getOrders"/>
    <hr class="block w-full my-5">
    <div class="px-5 pb-4" v-if="ordersList">
      <OrdersTable :ordersList="ordersList" @open-detail="emitOpenDetail($event)"/>
      <div class="flex justify-center p-5" v-if="paginationConfig.totalItems > paginationConfig.perPage">
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getOrders(formSearch, $event)" />
      </div>
    </div>
  </div>
  <DetailsModal ref="detailsModal" />
</template>