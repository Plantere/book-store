<script setup lang="ts">
import { formatMoney } from '@/helpers/exchange-helper';
import { formatDate } from '@/helpers/date-helper';
import Icon from '@/components/shares/Icon.vue';
import type { IOrder } from '@/interfaces/order'
import { computed } from 'vue';

interface Props {
  order: IOrder
}

const emit = defineEmits(["open-detail"])

const statusOrdersEnums = [
  {value: 1, name: "Processing", class: "bg-yellow-300", fontClass: "text-yellow-700"},
  {value: 2, name: "Confirmed", class: "bg-violet-300", fontClass: "text-violet-700"},
  {value: 3, name: "Delivered", class: "bg-green-300", fontClass: "text-green-700"},
  {value: 4, name: "Denied", class: "bg-red-300", fontClass: "text-red-700"},
  {value: 5, name: "Others", class: "bg-gray-300", fontClass: "text-gray-700"},
]

const currentStatus = computed(() => {
  return statusOrdersEnums.find(status => status.value === props.order.status) ?? statusOrdersEnums[statusOrdersEnums.length-1]
})

const props = defineProps<Props>()

</script>
<template>
  <tr class="bg-white border-b">
    <td class="px-6 py-4"># {{ props.order.id }}</td>
    <td class="px-6 py-4">{{ formatDate(props.order.created_at) }}</td>
    <td class="flex flex-col px-6 py-4">
      <div>
        {{ props.order.user?.first_name }} {{ props.order.user?.last_name }}
      </div>
      <div>
        <span>
          {{ props.order.user?.email }}
        </span>
      </div>
    </td>
    <td class="px-6 py-4">
      <div :class="currentStatus.class" class="p-1 mx-3 rounded-xl">
        <span :class="currentStatus.fontClass">
          {{ currentStatus.name }}
        </span>
      </div>
    </td>
    <td class="px-6 py-4">{{ formatMoney(props.order.price) }}</td>
    <td class="relative flex justify-center my-8">
      <button class="relative group">
        <Icon name="down" class="w-5"></Icon>
        <div class="group-hover:block group-focus:block absolute hidden left-0 z-10 bg-white divide-y divide-gray-100 rounded-lg shadow w-36">
          <ul class="py-2 text-sm text-gray-700">
            <li>
              <a class="block p-2 hover:bg-gray-100" @click="emit('open-detail')">See details</a>
            </li>
          </ul>
        </div>
      </button>
    </td>
  </tr>
</template>