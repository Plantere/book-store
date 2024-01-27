<script setup lang="ts">
import Icon from './shares/Icon.vue';

interface Book {
  image: string,
  price: Number,
  title: string,
  tag: string,
}

const props = defineProps<{
  book: Book
}>()

</script>

<template>
  <div class="relative m-10 flex w-full max-w-xs flex-col overflow-hidden rounded-2xl shadow-xl">
  <a class="relative mx-3 mt-3 flex justify-center h-60 overflow-hidden rounded-xl" href="#">
    <img class="object-cover" :src="props.book.image" alt="product image" />
  </a>
  <div class="mt-4 px-5">
    <a href="#">
      <h5 class="text-lg font-bold tracking-tight">{{props.book.title}}</h5>
    </a>
    <div class="mt-2 mb-5 flex items-center justify-between">
      <p>
        <span class="text-3xl font-bold">${{ props.book.price }}</span>
      </p>
      <a href="#" class="flex items-center justify-center rounded-md bg-violet-600 px-5 py-2.5 text-center text-sm font-medium text-white hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">
      <Icon name="cart"/>
      Add to cart</a>
    </div>
  </div>
</div>
</template>