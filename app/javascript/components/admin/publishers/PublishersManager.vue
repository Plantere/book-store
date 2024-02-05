<script setup lang="ts">
import { onBeforeMount, ref } from 'vue';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_publishers_get_path } from '@/utils/routes';
import Pagination from '@/components/shares/Pagination.vue';
import Filter from '@/components/admin/publishers/Filter.vue'
import type { IPagination } from '@/interfaces/pagination';
import FormPublisher from './FormPublisher.vue';
import PublisherTable from './table/PublisherTable.vue';


interface IPublisher {
  id: number,
  name: string
  total_books?: number
  description: string
}

interface FormSearch {
  search?: number,
}

const formSearch = ref<FormSearch>({
  search: undefined,
})

const publisherList = ref<IPublisher[]>([])
const formPublisher = ref<InstanceType<typeof FormPublisher> | null>(null)
const paginationConfig = ref<IPagination>({
  totalItems: 0,
  currentPage: 1,
  perPage: 15,
})

const getPublishers = async (search = formSearch.value, page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_admin_publishers_get_path({page, ...search}), {method: "GET"})

  if(JSON.stringify(formSearch.value) !== JSON.stringify(search)){
    formSearch.value = search
  }

  if(!response.ok){
    publisherList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 15,
    }
  }

  const data = await response.json();

  publisherList.value = data.data
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

onBeforeMount(async () => {
  await getPublishers()
})

const openFormPublisher = (publisher?: IPublisher) => {
  formPublisher.value?.handleModal(true, publisher)
}

</script>

<template>
  <div>
    <Filter @search-publisher="getPublishers" @create="openFormPublisher"/>
    <hr class="block w-full my-5">
    <div class="px-5 pb-4 overflow-x">
      <PublisherTable
        :publisher-list="publisherList" 
        @update-publisher="openFormPublisher" 
      />
      <div class="flex justify-center p-5" v-if="paginationConfig.totalItems > paginationConfig.perPage">
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getPublishers(formSearch, $event)" />
      </div>
    </div>
  </div>
  <FormPublisher ref="formPublisher" @update-publisher="getPublishers" />
</template>