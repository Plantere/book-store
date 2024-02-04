<script setup lang="ts">
import { ref, watch } from 'vue';

const emit = defineEmits(["search-order"])

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

const statusOrdersEnums = [
  {value: 1, name: "Processing"},
  {value: 2, name: "Confirmed"},
  {value: 3, name: "Delivered"},
  {value: 4, name: "Denied"},
  {value: 5, name: "Others"},
]

const filterDateEnums = [
  {value: 1, name: "Today"},
  {value: 2, name: "Last 7 Days"},
  {value: 3, name: "Last 30 Days"},
  {value: 4, name: "Last 6 Months"}
]

watch(formSearch, () => {
  emit("search-order", formSearch.value)
}, { deep: true })

</script>
<template>
  <div class="flex flex-col px-5 py-3">
    <div>
      <span class="text-xl font-semibold text-gray-900">Orders</span>
    </div>
    <div class="grid grid-cols-2 space-x-2 pt-2">
      <select v-model="formSearch.status" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
        <option :value="undefined" class="text-gray-300" selected>Status</option>
        <option :value="status.value" v-for="status in statusOrdersEnums">{{ status.name }}</option>
      </select>
      <select v-model="formSearch.date" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
        <option :value="undefined" class="text-gray-300" selected>Date</option>
        <option :value="date.value" v-for="date in filterDateEnums">{{ date.name }}</option>
      </select>
    </div>

    <hr class="w-full block my-5">
    <div class="flex flex-col">
      <input type="text" v-model="formSearch.search" placeholder="Search Orders" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
    </div>
  </div>
</template>