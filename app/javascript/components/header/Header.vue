<script setup>
import { useRouter } from 'vue-router';
import { useUserStore } from '../../stores/user'
import Search from './Search.vue';

const user = useUserStore()
const router = useRouter()

const logoutUser = () => {
  user.logoutUser()
  router.push({name: 'login'})
}
</script>

<template>
  <nav class="bg-white px-4 lg:px-6 py-3">
    <div class="flex flex-wrap justify-between items-center mx-auto max-w-screen-xl">
      <div>
        <RouterLink :to="{name: 'home'}">
          <h1 class="text-3xl font-bold">BookStore.</h1>
        </RouterLink>
      </div>
      <div class="w-6/12">
        <Search />
      </div>
      <div v-if="!user.utils.isAuth">
        <RouterLink :to="{name: 'login'}" class="font-semibold leading-6 text-violet-600 hover:text-violet-500">Login</RouterLink>
        <RouterLink :to="{name: 'register'}" class="ml-5 rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Register</RouterLink>
      </div>
      <div v-else>
        <button @click="logoutUser()" class="font-semibold leading-6 text-violet-600 hover:text-violet-500">Logout</button>
        <RouterLink :to="{name: 'profile'}" class="ml-5 rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Profile</RouterLink>
      </div>
    </div>
  </nav>
</template>