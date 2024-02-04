<script setup lang="ts">
import { ref } from 'vue';
import Header from '@/components/header/Header.vue';
import { useCartStore } from '@/stores/cart';
import { useNotificationStore } from '@/stores/notification';
import { makeRequest } from '@/utils/request';
import { api_v1_books_get_cart_items_path } from '@/utils/routes';
import { useUserStore } from '@/stores/user';
import { useRouter } from 'vue-router';
import ItemCart from '@/components/cart/ItemCart.vue';
import ResumeCart from '@/components/cart/ResumeCart.vue';
import ShippingCart from '@/components/cart/ShippingCart.vue';
import type { ICart } from '@/interfaces/cart';

const router = useRouter()
const cart = useCartStore()
const notifications = useNotificationStore()
const user = useUserStore()

const cartItems = ref<ICart[]>([]);
const currentTab = ref<number>(0);

const getCartItems = async () => {
  const response = await makeRequest(api_v1_books_get_cart_items_path(), {method: "POST", data: {
    cart: cart.cartList
  }})

  if(!response.ok){
    return;
  }

  const data = await response.json()
  cartItems.value = data.data
}

const removeItemCart = (bookId: number) => {
  cart.removeBook(bookId)
  cartItems.value = cartItems.value.filter(book => book.id != bookId)
}

const setCartQuantity = (bookId: number, cartQuantity: number) => {
  const bookItem = cartItems.value.find(item => item.id === bookId)

  if(!bookItem) return


  if(cartQuantity < 1){
    const minimumQuantity = 1;

    cart.changeQuantity(bookId, minimumQuantity)
    bookItem.cart_quantity = minimumQuantity

    notifications.createNotification(`The quantity must be a positive number.`, "error");

    return 
  }

  if(bookItem.stock_quantity < cartQuantity){
    cart.changeQuantity(bookId, bookItem.stock_quantity)
    bookItem.cart_quantity = bookItem.stock_quantity

    notifications.createNotification(`Only ${bookItem.stock_quantity} books available in stock`, "error")

    return
  }

  cart.changeQuantity(bookId, cartQuantity)
  bookItem.cart_quantity = cartQuantity
}

const nextTab = () => {
  if(!user.utils.isAuth){
    router.push({name: 'login', query: {redirect: 'cart'}})
    return
  }

  currentTab.value += 1
}

const previousTab = () => {
  currentTab.value -= 1
}

getCartItems()

</script>

<template>
  <div>
    <Header />
    <div class="flex space-x-2 py-10 max-w-screen-2xl px-10 md:mx-auto rounded-md" >
      <div class="w-full flex bg-white rounded-md" v-if="currentTab === 0">
        <div class="flex flex-col w-5/6 p-5 mt-5">
          <span class="text-md font-semibold leading-6 text-gray-600">My Cart ({{ cart.getTotalItems }} Items)</span>
          <ItemCart v-for="cartItem in cartItems" :key="cartItem.id" :cart="cartItem" @remove="removeItemCart" @set-cart-quantity="setCartQuantity" />
        </div>

        <div class="w-2/6 px-10 pt-5 mt-5">
          <ResumeCart :cart="cartItems" @next-tab="nextTab"/>
        </div>
      </div>

      <ShippingCart :cart="cartItems" @next-tab="nextTab" @previous-tab="previousTab" v-if="currentTab === 1"/>
    </div>
  </div>
</template>
