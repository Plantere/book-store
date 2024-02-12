<script setup lang="ts">
import { computed, onBeforeMount, ref } from 'vue';
import Header from '../components/header/Header.vue';
import Icon from '@/components/shares/Icon.vue';
import { useRouter } from 'vue-router';
import { makeRequest } from '@/utils/request';
import { api_v1_books_index_path } from '@/utils/routes';
import { useCartStore } from '@/stores/cart';
import { getImage } from '@/services/supabase-service';

interface Author {
  name: string,
}

interface IImage {
  path: string,
  token_image: string,
  is_default: boolean,
}

interface Publisher {
  name: string,
}

interface Book {
  id: number,
  name: string,
  stock_quantity: number,
  image: IImage[],
  publisher: Publisher,
  author: Author,
  genre: string
  description: string
}

const router = useRouter()
const book = ref<Book>()
const quantity = ref(1)
const cart = useCartStore()

const getBook = async () => { 
  const response = await makeRequest(api_v1_books_index_path({id: router.currentRoute.value.params.book_id.toString()}), {
    method: "GET",
  })

  if(!response.ok) {
    return router.push({name: "home"})
  }

  book.value = await response.json()
}

const checkStockQuantity = () => {
  if(!book.value) return

  if(cartQuantity.value >= book.value.stock_quantity){
    return quantity.value = 0
  }

  if(quantity.value < 1){
    const minimumQuantity = 1;
    return quantity.value = minimumQuantity
  }

  if(book.value.stock_quantity < quantity.value){
    return quantity.value = stockAvailable.value
  }
}

const isDisabled = computed(() => {
  if(!book.value) return false;
  return cartQuantity.value >= book.value.stock_quantity || quantity.value > stockAvailable.value
})

const stockAvailable = computed<number>(() => {
  if(!book.value) return 0
  return book.value.stock_quantity - cartQuantity.value
})

const cartQuantity = computed<number>(() => {
  return cart.cartList.find(item => item.book_id === book.value?.id)?.quantity ?? 0
})

const addBookInCart = () => {
  if(isDisabled.value || !book.value) return
  return cart.addBook(book.value.id, quantity.value)
}

onBeforeMount( async () => {
  await getBook();
})

const currentIndex = ref(0)

const nextImage = () => {
  if(!book.value || book.value.image.length <= 0) return

  if(currentIndex.value === book.value.image.length-1) return currentIndex.value = 0

  currentIndex.value += 1
}

const previousImage = () => {
  if(!book.value || book.value.image.length <= 0) return

  if(currentIndex.value === 0) return currentIndex.value = book.value.image.length-1

  currentIndex.value -= 1
}

</script>

<template>
  <div>
    <Header />
    <div class="flex space-x-2 py-10 max-w-screen-2xl px-10 md:mx-auto" v-if="book">
      <div class="flex flex-col bg-white w-2/6 h-2/6 rounded-md">
        <div class="relative">
          <span class="text-xl font-bold absolute inset-y-2/4 right-4" @click="nextImage()">
            <Icon class="w-2 text-purple-600 hover:text-purple-400" name="next"></Icon>
          </span>
          <img class="rounded-md h-[720px] w-[480px]" src="https://placehold.co/990x1500" v-if="book.image.length <= 0">
          <img class="rounded-md h-[720px] w-[480px]" :src="getImage(book.image[currentIndex].path)" v-else>
          <span class="text-xl font-bold absolute inset-y-2/4 left-4" @click="previousImage()">
            <Icon class="w-2 text-purple-600 hover:text-purple-400" name="previous"></Icon>
          </span>
          <div class="absolute top-0 right-0 bg-purple-600 p-1 m-2 rounded-xl">
            <span class="font-mono text-md text-white">{{ book.genre }}</span>
          </div>
        </div>
      </div>

      <div class="w-3/6 bg-white rounded-md">
        <div class="p-5 flex flex-row justify-between">
          <div class="flex flex-col">
            <span class="text-2xl font-semibold leading-6">{{book.name}} ({{book.publisher.name}})</span>
            <span class="text-sm font-mono">By: {{book.author.name}}</span>
          </div>
        </div>
        <hr>
        <div class="p-5 flex flex-col">
          <span class="text-2md font-mono">{{ book.description }}</span>
        </div>
      </div>
      <div class=" relative flex flex-col items-center justify-center w-1/6 bg-white">
        <div class="absolute top-0 right-0">
          <span class="text-md font-semibold p-2 bg-violet-400 rounded-xl text-white">Stock Available: {{ stockAvailable }}</span>
        </div>
        <div class="flex flex-col items-center justify-center">
          <label for="quantity" class="text-sm font-medium leading-6 text-gray-900">Quantity</label>
          <input @change="checkStockQuantity()" type="number" v-model="quantity" :max="book.stock_quantity" :min="1" class="w-28 rounded-md border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-1 focus:ring-inset focus:ring-violet-600">
        </div>

        <div class="flex flex-row space-x-1 justify-center mt-4">
          <button class="rounded-md bg-violet-600 px-2 py-2 text-sm font-semibold text-white shadow-sm hover:bg-violet-500 disabled:opacity-50" :disabled="isDisabled" @click="addBookInCart()">Add Cart</button>
        </div>
      </div>
    </div>

  </div>
</template>
