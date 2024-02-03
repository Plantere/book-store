<script setup lang="ts">
import { useRouter } from 'vue-router';
import { useUserStore } from '@/stores/user'
import { useCartStore } from '@/stores/cart'
import Icon from '@/components/shares/Icon.vue';

import Search from '@/components/header/Search.vue';

const user = useUserStore()
const cart = useCartStore()

const router = useRouter()

const logoutUser = () => {
  user.logoutUser()
  router.push({name: 'login'})
}

const redirectCartPage = () => {
  router.push({name: 'cart'})
}

</script>

<template>
  <nav class="bg-white px-4 lg:px-6 py-3">
    <div class="flex flex-wrap justify-between items-center mx-auto max-w-screen-2xl">
      <div class="w-3/12">
        <RouterLink :to="{name: 'home'}">
          <h1 class="text-3xl font-bold">BookStore.</h1>
        </RouterLink>
      </div>
      <div class="w-6/12">
        <Search />
      </div>
      <div class="w-3/12 flex justify-end">
        <div v-if="!user.utils.isAuth" class="flex justify-center">
          <RouterLink :to="{name: 'login'}" class="ml-5 rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Login</RouterLink>
        </div>
        <div v-else class="flex justify-center">
          <button @click="logoutUser()" class="font-semibold leading-6 text-violet-600 hover:text-violet-500">Logout</button>
          <RouterLink :to="{name: 'profile'}" class="ml-5 rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Profile</RouterLink>
        </div>
        <div class="relative mx-5 flex justify-center cursor-pointer" @click="redirectCartPage()">
          <div class="t-0 absolute left-3">
            <p class="flex h-2 w-2 items-center justify-center rounded-full bg-violet-500 p-3 text-xs text-white">{{ cart.getTotalCart }}</p>
          </div>
          <Icon name="cart" class="mt-3 h-6 w-6"></Icon>
        </div>
      </div>
    </div>
  </nav>
</template>