<script setup lang="ts">
import { formatMoney } from '@/helpers/exchange-helper';
import Icon from '@/components/shares/Icon.vue';
import { ref } from 'vue';
import { getImage } from '@/services/supabase-service';

interface IImage {
  path: string,
  is_default: boolean,
}

interface Genre {
  id: string,
  name: string
}
interface Author {
  id: string,
  name: string
}
interface Publisher {
  id: string,
  name: string
}
interface Book {
  id: number,
  genre: Genre,
  title: string,
  stock_quantity: number,
  price: number | string,
  status: number,
  images?: IImage[],
  author: Author,
  publisher: Publisher,
}

interface Props {
  book: Book
}

const props = defineProps<Props>()
const emit = defineEmits(["update"])

const defaultImage = () => {
  if(!props.book.images?.length) return "https://placehold.co/990x1500"

  const pathImage = props.book.images.find(image => image.is_default === true)?.path ?? props.book.images[0].path

  return getImage(pathImage)
}

</script>
<template>
  <tr class="bg-white border-b">
    <td class="px-6 py-4">
      <div class="flex space-x-1 justify-center items-center">
        <img width="38" :src="defaultImage()" alt="">
        <div class="w-56">
          <p class="truncate font-bold text-black">{{ props.book.title }}</p>
          <p class="truncate">{{ props.book.author.name }}</p>
        </div>
      </div>
    </td>
    <td class="px-6 py-4">{{ props.book.genre.name }}</td>
    <td class="px-6 py-4">{{ formatMoney(props.book.price) }}</td>
    <td class="px-6 py-4">{{ props.book.stock_quantity }}</td>
    <td class="text-center">
      <div :class="{'bg-red-300': props.book.status !== 1}" class="bg-green-300 p-1 mx-3 rounded-xl">
        <span :class="{'text-red-700': props.book.status !== 1}" class="text-green-700">{{ props.book.status === 1 ? "Active" : "Inactive" }}</span>
      </div>
    </td>
    <td class="relative flex justify-center my-8">
      <button class="relative group">
        <Icon name="down" class="w-5"></Icon>
        <div class="group-hover:block group-focus:block absolute hidden left-0 z-10 bg-white divide-y divide-gray-100 rounded-lg shadow w-36">
          <ul class="py-2 text-sm text-gray-700">
            <li>
              <a class="block p-2 hover:bg-gray-100" @click="emit('update', props.book.id)">Edit</a>
            </li>
          </ul>
        </div>
      </button>
    </td>
  </tr>
</template>