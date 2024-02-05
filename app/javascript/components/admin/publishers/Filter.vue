<script setup lang="ts">
import { ref, watch } from 'vue';

const emit = defineEmits(["search-publisher", 'create'])

interface FormSearch {
  search?: string,
}

const formSearch = ref<FormSearch>({
  search: undefined,
})

watch(formSearch, (newValue) => {
  for (const key in newValue) {
    if(newValue[key] === "") {
      formSearch.value[key] = undefined;
    }
  }


  emit("search-publisher", formSearch.value, 1)
}, { deep: true });

</script>
<template>
  <div>
    <div class="flex flex-col px-5 py-3">
      <div>
        <span class="text-xl font-semibold text-gray-900">Filters</span>
      </div>
    </div>
    <div class="flex flex-row justify-between px-5">
      <input type="text" placeholder="Search Publishers" v-model="formSearch.search" class="w-full mr-5 rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
      <button @click="emit('create')" class="rounded-md bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600 disabled:opacity-50">Create</button>
    </div>
  </div>
</template>