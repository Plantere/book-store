<script setup lang="ts">
import { onBeforeMount, ref } from 'vue';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_authors_get_path } from '@/utils/routes';
import Pagination from '@/components/shares/Pagination.vue';
import Filter from '@/components/admin/authors/Filter.vue'
import type { IPagination } from '@/interfaces/pagination';
import FormAuthor from './FormAuthor.vue';
import AuthorTable from './table/AuthorTable.vue';


interface IAuthor {
  id: number,
  full_name: string
  total_books?: number
  biography: string
  birth_date: string
}

interface FormSearch {
  search?: number,
}

const formSearch = ref<FormSearch>({
  search: undefined,
})

const authorList = ref<IAuthor[]>([])
const formAuthor = ref<InstanceType<typeof FormAuthor> | null>(null)
const paginationConfig = ref<IPagination>({
  totalItems: 0,
  currentPage: 1,
  perPage: 15,
})

const getAuthors = async (search = formSearch.value, page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_admin_authors_get_path({page, ...search}), {method: "GET"})

  if(JSON.stringify(formSearch.value) !== JSON.stringify(search)){
    formSearch.value = search
  }

  if(!response.ok){
    authorList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 15,
    }
  }

  const data = await response.json();

  authorList.value = data.data
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
  await getAuthors()
})

const openFormAuthor = (author?: IAuthor) => {
  formAuthor.value?.handleModal(true, author)
}

</script>

<template>
  <div>
    <Filter @search-author="getAuthors" @create="openFormAuthor"/>
    <hr class="block w-full my-5">
    <div class="px-5 pb-4 overflow-x">
      <AuthorTable
        :author-list="authorList" 
        @update-author="openFormAuthor" 
      />
      <div class="flex justify-center p-5" v-if="paginationConfig.totalItems > paginationConfig.perPage">
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getAuthors(formSearch, $event)" />
      </div>
    </div>
  </div>
  <FormAuthor ref="formAuthor" @update-author="getAuthors" />
</template>