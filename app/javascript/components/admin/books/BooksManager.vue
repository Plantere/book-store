<script setup lang="ts">
import { onBeforeMount, ref } from 'vue';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_books_get_path } from '@/utils/routes';
import Pagination from '@/components/shares/Pagination.vue';
import Filter from '@/components/admin/books/Filter.vue'
import BookTable from '@/components/admin/books/table/BookTable.vue'
import FormBook from '@/components/admin/books/FormBook.vue'
import type { IPagination } from '@/interfaces/pagination';

interface Author {
  id: number,
  name: string
}

interface Publisher {
  id: number,
  name: string
}

interface Book {
  id: number,
  genre: string,
  title: string,
  stock_quantity: number,
  price: number | string,
  status: number,
  author: Author,
  publisher: Publisher,
}

const searchData = ref({
  genre: null,
  stock: null,
  status: null,
  search: null,
})

const booksList = ref<Book[]>([])
const formBookModal = ref<InstanceType<typeof FormBook> | null>(null)

const paginationConfig = ref<IPagination>({
  totalItems: 0,
  currentPage: 1,
  perPage: 15,
})

const getBooks = async (search = searchData.value, page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_admin_books_get_path({page, ...search}), {method: "GET"})

  if(JSON.stringify(searchData.value) !== JSON.stringify(search)){
    searchData.value = search
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

const openFormBook = (bookId?: number) => {
  if(!bookId){
    return formBookModal.value?.openModal()
  }

  const bookSelected = booksList.value.find(book => book.id === bookId)
  if(!bookSelected) return

  formBookModal.value?.openModal(bookSelected)
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
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getBooks(searchData, $event)" />
      </div>
    </div>
  </div>
  <FormBook ref="formBookModal" @update="getBooks" />
</template>