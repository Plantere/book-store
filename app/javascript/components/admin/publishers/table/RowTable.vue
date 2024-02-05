<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';

interface IPublisher {
  id: number,
  name: string
  total_books?: number
  description: string
}

interface Props {
  publisher: IPublisher
}

const props = defineProps<Props>()
const emit = defineEmits(["update-publisher"]) 

</script>
<template>
  <tr class="bg-white border-b">
    <td class="px-6 py-4">{{ props.publisher.id}}</td>
    <td class="px-6 py-4">{{ props.publisher.name }}</td>
    <td class="px-6 py-4">{{ props.publisher.total_books }}</td>
    <td class="relative flex justify-center my-8">
      <button class="relative group">
        <Icon name="down" class="w-5"></Icon>
        <div class="group-hover:block group-focus:block absolute hidden left-0 z-10 bg-white divide-y divide-gray-100 rounded-lg shadow w-36">
          <ul class="py-2 text-sm text-gray-700">
            <li>
              <a class="block p-2 hover:bg-gray-100" @click="emit('update-publisher')">Edit</a>
            </li>
          </ul>
        </div>
      </button>
    </td>
  </tr>
</template>