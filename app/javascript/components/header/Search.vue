<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router';

const search = ref("")
const router = useRouter()

const redirectSearch = () => {
  return router.push({name: 'books', query: {search: search.value}})
}
</script>

<template>
  <div class="relative">
    <button @click="redirectSearch()" class="absolute right-0 rounded-md bg-violet-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Search</button>
    <input type="text" v-model="search" placeholder="Search Books, Authors, or Publishers" class="block w-full rounded-xl border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
  </div>
</template>