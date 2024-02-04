<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';

interface IAuthor {
  id: number,
  full_name: string
  total_books?: number
  biography: string
  birth_date: string
}

interface Props {
  author: IAuthor
}

const props = defineProps<Props>()
const emit = defineEmits(["update-author"]) 

</script>
<template>
  <tr class="bg-white border-b">
    <td class="px-6 py-4">{{ props.author.id}}</td>
    <td class="px-6 py-4">{{ props.author.full_name }}</td>
    <td class="px-6 py-4">{{ props.author.total_books }}</td>
    <td class="relative flex justify-center my-8">
      <button class="relative group">
        <Icon name="down" class="w-5"></Icon>
        <div class="group-hover:block group-focus:block absolute hidden left-0 z-10 bg-white divide-y divide-gray-100 rounded-lg shadow w-36">
          <ul class="py-2 text-sm text-gray-700">
            <li>
              <a class="block p-2 hover:bg-gray-100" @click="emit('update-author')">Edit</a>
            </li>
          </ul>
        </div>
      </button>
    </td>
  </tr>
</template>