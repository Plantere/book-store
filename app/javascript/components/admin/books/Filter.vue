<script setup lang="ts">
import { makeRequest } from '@/utils/request';
import { onBeforeMount, ref, watch } from 'vue';
import { api_v1_admin_genres_get_all_path } from '@/utils/routes';

const emit = defineEmits(["search-books", 'create'])

interface FormSearch {
  genre?: number,
  stock?: number,
  status?: number,
  search?: string,
}

interface IDefault {
  id: number,
  name: string
}

const formSearch = ref<FormSearch>({
  genre: undefined,
  stock: undefined,
  status: undefined,
  search: undefined,
})

const genres = ref([])

const getGenres = async () => {
  const response = await makeRequest(api_v1_admin_genres_get_all_path(), {method: "GET"})

  if(!response.ok) return

  const data = await response.json();

  genres.value = data.data.map( (item: IDefault) => item.name)
}

watch(formSearch, () => {
  emit("search-books", formSearch.value, 1)
}, { deep: true });

onBeforeMount( () => {
  getGenres()
})
</script>
<template>
  <div>
    <div class="flex flex-col px-5 py-3">
      <div>
        <span class="text-xl font-semibold text-gray-900">Filters</span>
      </div>
      <div class="grid grid-cols-3 space-x-2 pt-2">
        <select placeholder="Genre" v-model="formSearch.genre"
          class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
          <option :value="undefined" class="text-gray-200">Genre</option>
          <option :value="genre" v-for="genre in genres" :key="genre">{{ genre }}</option>
        </select>
        <select placeholder="Stock" v-model="formSearch.stock"
          class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
          <option :value="undefined" class="text-center text-gray-200">Stock</option>
          <option :value="1">In Stock</option>
          <option :value="2">Out of Stock</option>

        </select>
        <select placeholder="Status" v-model="formSearch.status"
          class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
          <option :value="undefined" class="text-center text-gray-200">Status</option>
          <option :value="1">Active</option>
          <option :value="2">Inactive</option>
        </select>
      </div>
    </div>
    <hr class="block w-full my-5">
    <div class="flex flex-row justify-between px-5">
      <input type="text" placeholder="Search Books" v-model="formSearch.search" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
      <button @click="emit('create')" class="rounded-md bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600 disabled:opacity-50">Create</button>
    </div>
  </div>
</template>