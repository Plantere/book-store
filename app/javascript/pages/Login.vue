<script setup lang="ts">
import { ref } from 'vue'
import { api_v1_auth_login_path } from "../utils/routes";
import { loginUser } from "../helpers/auth-helper";
import { makeRequest } from "../utils/request";
import { useRouter, RouterLink } from 'vue-router'
import { useNotificationStore } from '../stores/notification'

const email = ref("")
const password = ref("")

const isSubmiting = ref(false)
const router = useRouter()

const notifications = useNotificationStore();

const submit = async () => {
  if(isSubmiting.value){
    return
  }
  	
  isSubmiting.value = true

  const response = await makeRequest(api_v1_auth_login_path(), {
    method: "POST",
    data: {
      email: email.value,
      password: password.value
    }
  })

  if(!response.ok){
    notifications.createNotification((await response.json()).error, "error")
    isSubmiting.value = false
    return
  }

  loginUser((await response.json()).token)
  notifications.createNotification("User successfully logged in", "success")
  router.push({name: "home"})
}
</script>

<template>
  <div class="flex h-screen flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h1 class="text-center text-6xl font-bold">BookStore</h1>
      <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">Sign in to your account</h2>
    </div>
    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form class="space-y-6" @submit.prevent="submit">
        <div>
          <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Email</label>
          <div class="mt-2">
            <input id="email" name="email" type="email" v-model="email" autocomplete="email" required class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
          </div>
        </div>

        <div>
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm font-medium leading-6 text-gray-900">Password</label>
            <div class="text-sm">
              <RouterLink :to="{name: 'home'}" class="font-semibold text-violet-600 hover:text-violet-500" >Forgot?</RouterLink>
            </div>
          </div>
          <div class="mt-2">
            <input id="password" name="password" v-model="password" type="password" autocomplete="current-password" required class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
          </div>
        </div>

        <div>
          <button type="submit" :class="{'bg-violet-300 hover:bg-violet-400': isSubmiting}" class="flex w-full justify-center rounded-md bg-violet-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600" :disabled="isSubmiting">Sign in</button>
        </div>
      </form>

      <p class="mt-10 text-center text-sm text-gray-500">
        Don't have a account?
        <RouterLink :to="{name: 'register'}" class="font-semibold leading-6 text-violet-600 hover:text-violet-500">Register here</RouterLink>
      </p>
    </div>
  </div>
</template>

<style>
</style>
