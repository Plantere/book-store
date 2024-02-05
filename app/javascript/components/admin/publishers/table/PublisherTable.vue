<script setup lang="ts">
import RowTable from './RowTable.vue';

interface IPublisher {
  id: number,
  name: string
  total_books?: number
  description: string
}

interface Props {
  publisherList: IPublisher[]
}

const props = defineProps<Props>()

const emit = defineEmits(["update-publisher"])

</script>
<template>
  <table class="text-sm text-center text-gray-500 table-auto overflow-x-scroll w-full">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50">
      <tr>
        <th class="px-6 py-3">Id</th>
        <th class="px-6 py-3">Name</th>
        <th class="px-6 py-3">Total Books</th>
        <th class="px-6 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <RowTable 
        v-for="publisher in props.publisherList" 
        :key="publisher.id" 
        :publisher="publisher"
        @update-publisher="emit('update-publisher', publisher)"
      />
    </tbody>
  </table>
</template>