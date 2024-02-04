<script setup lang="ts">
import RowTable from './RowTable.vue';

interface IAuthor {
  id: number,
  full_name: string
  total_books?: number
  biography: string
  birth_date: string
}

interface Props {
  authorList: IAuthor[]
}

const props = defineProps<Props>()

const emit = defineEmits(["update-author"])

</script>
<template>
  <table class="text-sm text-center text-gray-500 table-auto overflow-x-scroll w-full">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50">
      <tr>
        <th class="px-6 py-3">Id</th>
        <th class="px-6 py-3">Full Name</th>
        <th class="px-6 py-3">Total Books</th>
        <th class="px-6 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <RowTable 
        v-for="author in props.authorList" 
        :key="author.id" 
        :author="author"
        @update-author="emit('update-author', author)"
      />
    </tbody>
  </table>
</template>