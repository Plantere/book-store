<script setup lang="ts">
import { ref, watch } from 'vue';

const emit = defineEmits(["search-user"])

interface FormSearch {
  status?: number,
  type?: number,
  search?: string,
}

const formSearch = ref<FormSearch>({
  type: undefined,
  search: undefined,
  status: undefined,
})

const statusUserEnums = [
  {value: 1, name: "Active"},
  {value: 2, name: "Inactive"},
  {value: 3, name: "Banned"},
]

const typeUserEnums = [
  {value: 2, name: "Admin"},
  {value: 1, name: "Customer"},
]

watch(formSearch, () => {
  emit("search-user", formSearch.value)
}, { deep: true })

</script>
<template>
  <div class="flex flex-col px-5 py-3">
    <div>
      <span class="text-xl font-semibold text-gray-900">Users</span>
    </div>
    <div class="grid grid-cols-2 space-x-2 pt-2">
      <select v-model="formSearch.status" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
        <option :value="undefined" class="text-gray-300" selected>Status</option>
        <option :value="status.value" v-for="status in statusUserEnums">{{ status.name }}</option>
      </select>
      <select v-model="formSearch.type" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
        <option :value="undefined" class="text-gray-300" selected>Type</option>
        <option :value="date.value" v-for="date in typeUserEnums">{{ date.name }}</option>
      </select>
    </div>

    <hr class="w-full block my-5">
    <div class="flex flex-col">
      <input type="text" v-model="formSearch.search" placeholder="Search Users" class="rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
    </div>
  </div>
</template>