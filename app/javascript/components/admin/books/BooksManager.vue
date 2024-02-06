<script setup lang="ts">
import { onBeforeMount, ref } from 'vue';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_books_get_path } from '@/utils/routes';
import Pagination from '@/components/shares/Pagination.vue';
import Filter from '@/components/admin/books/Filter.vue'
import BookTable from '@/components/admin/books/table/BookTable.vue'
import FormBook from '@/components/admin/books/FormBook.vue'
import type { IPagination } from '@/interfaces/pagination';

interface IDefault {
  id: number,
  name: string
}

interface IImage {
  path: string,
  token_image: string,
  is_default: boolean,
}

interface IBook {
  id: number,
  genre: IDefault,
  title: string,
  description: string,
  stock_quantity: number,
  price: number | string,
  status: number,
  images?: IImage[],
  author: IDefault,
  publisher: IDefault,
}

interface FormSearch {
  genre?: number,
  stock?: number,
  status?: number,
  search?: string,
}

const formSearch = ref<FormSearch>({
  genre: undefined,
  stock: undefined,
  status: undefined,
  search: undefined,
})

const booksList = ref<IBook[]>([])
const formBook = ref<InstanceType<typeof FormBook> | null>(null)
const paginationConfig = ref<IPagination>({
  totalItems: 0,
  currentPage: 1,
  perPage: 15,
})

const getBooks = async (search = formSearch.value, page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_admin_books_get_path({page, ...search}), {method: "GET"})

  if(JSON.stringify(formSearch.value) !== JSON.stringify(search)){
    formSearch.value = search
  }

  if(!response.ok){
    booksList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 15,
    }
  }

  const data = await response.json();

  booksList.value = data.data
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
  await getBooks()
})

const openFormBook = (book?: IBook) => {
  formBook.value?.handleModal(true, book)
}

</script>

<template>
  <div>
    <Filter @search-books="getBooks" @create="openFormBook"/>
    <hr class="block w-full my-5">
    <div class="px-5 pb-4 overflow-x">
      <BookTable
        :books-list="booksList" 
        @update="openFormBook" 
      />
      <div class="flex justify-center p-5" v-if="paginationConfig.totalItems > paginationConfig.perPage">
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getBooks(formSearch, $event)" />
      </div>
    </div>
  </div>
  <FormBook ref="formBook" @update-book="getBooks" />
</template>