<script setup lang="ts">
import { RouterLink } from 'vue-router';

const props = defineProps({
  routerName: { type: String, required: true },
  termSearch: { type: String },
  totalItems: { type: Number, required: true },
  currentPage: { type: Number, default: 1 },
  perPage: { type: Number, default: 25 },
})

const totalPages = Math.ceil(props.totalItems / props.perPage);

const getPreviousPage = () => (props.currentPage > 1 ? props.currentPage - 1 : 0);

const getNextPage = () => (props.currentPage < totalPages ? props.currentPage + 1 : 0);

</script>

<template>
  <ul class="inline-flex -space-x-px text-base h-10">
    <li class="flex items-center justify-center px-3 h-10 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700">
      <RouterLink :to="{name: props.routerName, query: {page: getPreviousPage(), search: props.termSearch}}">Previous</RouterLink>
    </li>
    <li class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700" v-for="page in totalPages" :key="page">
      <RouterLink :to="{name: props.routerName, query: { page: page,  search: props.termSearch}}"> {{ page }}</RouterLink>
    </li>
    <li class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700">
      <RouterLink :to="{name: props.routerName, query: {page: getNextPage(), search: props.termSearch}}">Next</RouterLink>
    </li>
  </ul>
</template>