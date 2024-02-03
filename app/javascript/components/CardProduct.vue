<script setup lang="ts">
import { useCartStore } from '@/stores/cart';
import Icon from '@/components/shares/Icon.vue';
import { formatMoney } from '@/helpers/exchange-helper';
import { useRouter } from 'vue-router';

const router = useRouter()
const cart = useCartStore();

const redirectBookPage = () => {
  router.push({name: "show-book", params: {book_id: props.id}})
}

interface Book {
  stock_quantity: number,
  image?: string,
  price: number | string,
  title: string,
  id: number,
}

const props = withDefaults(defineProps<Book>(), {
  image: "https://placehold.co/990x1500",
})

</script>

<template>
  <div class="relative m-10 flex w-full max-w-xs flex-col overflow-hidden rounded-2xl shadow-xl">
  <img class="object-cover cursor-pointer" :src="props.image" alt="product image" @click="redirectBookPage()"/>
  <div class="mt-4 px-5">
    <h5 class="text-lg font-bold tracking-tight cursor-pointer" @click="redirectBookPage()">{{props.title}}</h5>
    <div class="mt-2 mb-5 flex items-center justify-between">
      <p>
        <span class="text-3xl font-bold">{{ formatMoney(props.price) }}</span>
      </p>
      <button @click="cart.addBook(props.id)" :disabled="cart.isAvailable(props.id, props.stock_quantity)" :class="{'bg-violet-400 text-white': cart.isAvailable(props.id, props.stock_quantity), 'bg-violet-600 text-white hover:bg-violet-500': !cart.isAvailable(props.id, props.stock_quantity)}" class="flex items-center justify-center rounded-md  px-5 py-2.5 text-center text-sm font-medium  focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">
        <Icon name="cart" class="flex items-center w-4 mr-3"/>
        {{cart.isAvailable(props.id, props.stock_quantity) ? 'Out of Stock' : 'Add to cart'}}
      </button>
    </div>
  </div>
</div>
</template>