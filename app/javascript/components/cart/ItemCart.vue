<script setup lang="ts">
import { formatMoney } from "@/helpers/exchange-helper";
import type { ItemCart } from "@/interfaces/cart";
import Icon from "@/components/shares/Icon.vue";

const props = defineProps<ItemCart>()

const emit = defineEmits(["remove", "setCartQuantity"])

const removeItemCart = (itemId: number): void => {
  emit("remove", itemId)
}

const setCartQuantity = (itemId: number, cartQuantity: number): void => {
  emit("setCartQuantity", itemId, cartQuantity)
}

</script>

<template>
  <div class="relative flex rounded-lg border mt-5 p-3">
    <div class="absolute top-0 right-0 p-2 cursor-pointer" @click="removeItemCart(props.cart.id)">
      <Icon name="xmark" class="h-6 w-6"></Icon>
    </div>
    <div class="flex flex-row justify-between w-full">
      <div class="flex">
        <div>
          <img class="rounded-lg border  h-32" src="https://m.media-amazon.com/images/I/616U6mSP3lL._SL1000_.jpg" alt="">
        </div>
        <div class="flex flex-col pl-3 justify-between">
          <div class="flex flex-col">
            <span class="text-xl">{{ props.cart.name }}</span>
            <span class="text-sm">Sold by: BookStore.</span>
          </div>

          <div>
            <input @change="setCartQuantity(props.cart.id, props.cart.cart_quantity)" type="number" :max="props.cart.stock_quantity" min="1" v-model="props.cart.cart_quantity" class="w-28 rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
          </div>
        </div>
      </div>

      <div class="flex items-center">
        <span class="font-medium text-lg leading-6 text-violet-600 hover:text-violet-500">
          {{ formatMoney(props.cart.price) }}
        </span>
      </div>
    </div>
  </div>
</template>