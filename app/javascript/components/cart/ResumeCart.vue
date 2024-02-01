<script setup lang="ts">
import { formatMoney } from '@/helpers/exchange-helper';
import type { ItemsCart } from '@/interfaces/cart';

const emit = defineEmits(["nextTab"])

const props = defineProps<ItemsCart>()

const getBagTotal = () => {
  return props.cart.reduce((acc, item) => {
    return acc + (item.cart_quantity * item.price)
  }, 0)
}

const nextTab = () => {
  if(props.cart.length < 1) return
  emit("nextTab")
}

</script>

<template>
  <div class="flex flex-row">
    <div class="flex flex-col w-full">
      <label for="offer" class="text-md font-semibold leading-6 text-gray-600">Offer</label>
      <input id="offer" name="offer" type="text" autocomplete="offer" required class="rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
    </div>
    <div class="flex items-end ml-5">
      <button disabled class="rounded-md bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600 disabled:opacity-50">Apply</button>
    </div>
  </div>
  <hr class="m-5 border-gray-300">
  <div class="space-y-1">
    <span class="text-md font-semibold leading-6 text-gray-600">Price Details</span>
    <div class="flex justify-between">
      <span class="text-md font-normal leading-6 text-black">Bag Total</span>
      <span class="text-md font-normal leading-6 text-black">{{formatMoney(getBagTotal())}}</span>
    </div>
    <div class="flex justify-between">
      <span class="text-md font-normal leading-6 text-black">Coupon Discount</span>
      <span class="font-semibold leading-6 text-violet-600 hover:text-violet-500 cursor-pointer">Apply Coupon</span>
    </div>
    <div class="flex justify-between">
      <span class="text-md font-normal leading-6 text-black">Order Total</span>
      <span class="text-md font-normal leading-6 text-black">{{formatMoney(getBagTotal())}}</span>
    </div>
    <div class="flex justify-between">
      <span class="text-md font-normal leading-6 text-black">Delivery Charges</span>
      <span class="text-md font-normal leading-6 text-black">{{formatMoney(5.00)}}</span>
    </div>
  </div>

  <hr class="m-5 border-gray-300">

  <div class="flex justify-between">
    <span class="text-md font-semibold leading-6 text-gray-600">Total</span>
    <span class="text-md font-normal leading-6 text-black">{{formatMoney(getBagTotal() + 5.00)}}</span>
  </div>

  <hr class="m-5 border-gray-300">
  <div class="flex justify-center m-5">
    <button @click="nextTab()" :disabled="props.cart.length < 1" class="disabled:opacity-50 rounded-md bg-violet-600 px-8 py-2 text-sm font-semibold  text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Shipping</button>
  </div>
</template>