<script setup lang="ts">

import Header from '../components/header/Header.vue';
import CardProduct from '../components/CardProduct.vue';
import Pagination from '../components/shares/Pagination.vue';

import { ref, watch } from 'vue'

import { useRouter } from 'vue-router';
import { useNotificationStore } from '../stores/notification'

import { makeRequest } from '../utils/request';
import { api_v1_books_search_path } from '../utils/routes';

interface Book {
  quantity: number,
  image?: string,
  price: Number,
  title: string,
  tag: number,
}

const notifications = useNotificationStore()
const router = useRouter()

let booksList = ref<Book[]>([]);
let paginationConfig = ref({
  totalItems: 0,
  currentPage: 0,
});

const getBooks = async () => {
  const response = await makeRequest(api_v1_books_search_path(), {
    method: "POST",
    data: { search: router.currentRoute.value.query.search, page: router.currentRoute.value.query.page }
  })

  if(!response.ok){
    notifications.createNotification("Error searching data.", "error")
    
    booksList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 0,
    }
  }
  notifications.createNotification("Search conducted successfully", "success")

  const data = await response.json();

  booksList.value = data.data.map(item => ({
    tag: item.id, title: item.name, price: item.price, quantity: item.stock_quantity
  }))

  paginationConfig.value = {
    totalItems: data.pagination.count,
    currentPage: data.pagination.page,
  }
}

watch(() => router.currentRoute.value.query, () => {
  getBooks()
}, { immediate: true });

</script>

<template>
  <div>
    <Header />
    <div class="flex justify-center">
      <div :class="{'bg-white': booksList.length > 0}" class="max-w-screen-xl mx-4 md:mx-auto rounded-lg my-10">
        <div v-if="booksList.length > 0" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
          <CardProduct v-for="book in booksList" :title="book.title" :tag="book.tag" :price="book.price" :quantity="book.quantity" class="mb-8"/>
        </div> 
        <div v-else class="text-center  mt-8 text-2xl font-bold">
          No books found.
        </div>
        <div class="flex justify-center mt-8 mb-10" v-if="booksList.length > 0">
          <Pagination
            router-name="books"
            :term-search="router.currentRoute.value.query.search"
            :total-items="paginationConfig.totalItems" 
            :current-page="paginationConfig.currentPage" 
          />
        </div>
      </div>
    </div>
  </div>

</template>

<style>
</style>
