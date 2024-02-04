<script setup lang="ts">
import RowTable from './RowTable.vue';

const props = defineProps({
  booksList: [ Object ]
})

const emit = defineEmits(["update"])

</script>
<template>
  <table class="text-sm text-center text-gray-500 table-auto overflow-x-scroll w-full">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50">
      <tr>
        <th class="px-6 py-3">Book</th>
        <th class="px-6 py-3">Genre</th>
        <th class="px-6 py-3">Price</th>
        <th class="px-6 py-3">Stock</th>
        <th class="px-6 py-3">Status</th>
        <th class="px-6 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <RowTable 
        v-for="book in props.booksList" 
        :key="book.id" 
        :book="book"
        @update="emit('update', book)"
      />
    </tbody>
  </table>
</template>