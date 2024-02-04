<script setup lang="ts">
import RowTable from './RowTable.vue';
import type { IOrder } from '@/interfaces/order'

const emit = defineEmits(['open-detail'])

interface Props {
  ordersList: IOrder[]
}

const props = defineProps<Props>()

</script>
<template>
  <table class="text-sm text-center text-gray-500 table-auto overflow-x-scroll w-full">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50">
      <tr>
        <th class="px-6 py-3">Id</th>
        <th class="px-6 py-3">Date</th>
        <th class="px-6 py-3">Customer</th>
        <th class="px-6 py-3">Status</th>
        <th class="px-6 py-3">Price</th>
        <th class="px-6 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <RowTable 
        @open-detail="emit('open-detail', order)"
        v-for="order in props.ordersList" 
        :key="order.id" 
        :order="order"
      />
    </tbody>
  </table>
</template>