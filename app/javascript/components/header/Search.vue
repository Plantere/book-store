<script setup>
import { ref } from 'vue'
import { api_v1_books_search_path } from '../../utils/routes';
import { makeRequest } from "../../utils/request";
import { useNotificationStore } from '../../stores/notification'

const searchParameter = ref("")
const isSubmiting = ref(false)
const notifications = useNotificationStore()

const search = async () => {
  if(isSubmiting.value){
    return
  }

  const response = await makeRequest(api_v1_books_search_path(), {
    method: "POST",
    data: { search: searchParameter.value }
  })

  if(!response.ok){
    notifications.createNotification("Error searching data.", "error")
    isSubmiting.value = false
    return
  }

  notifications.createNotification("Search conducted successfully", "success")
  isSubmiting.value = true;
}
</script>

<template>
  <div class="relative">
    <button @click="search" class="absolute right-0 rounded-md bg-violet-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Search</button>
    <input type="text" v-model="searchParameter" placeholder="Search Books, Authors, or Publishers" class="block w-full rounded-xl border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
  </div>
</template>