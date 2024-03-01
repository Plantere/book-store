<script setup lang="ts">
import { reactive, ref } from 'vue'
import { makeRequest } from "../utils/request";
import { useRouter } from 'vue-router'
import { useNotificationStore } from '../stores/notification'
import { api_v1_users_register_path } from '../utils/routes';

const fieldsForm = reactive({
  user: {
    email: "",
    username: "",
    password: "",
  },
  profile: {
    first_name: "",
    last_name: "",
  }
})

const isSubmiting = ref(false)

const router = useRouter()
const notifications = useNotificationStore()

const submit = async () => {
  if(isSubmiting.value){
    return
  }
  
  isSubmiting.value = true
  
  let registerForm = transformForm()
  const response = await makeRequest(api_v1_users_register_path(), {
    method: "POST",
    data: registerForm
  })

  if(!response.ok){
    notifications.createNotification("User already registered", "error")
    isSubmiting.value = false
    return
  }

  notifications.createNotification("User created successufly", "success")
  router.push({name: "login"})
}

const transformForm = () => {
  let registerForm = Object.assign({}, fieldsForm)

  registerForm.user.email = fieldsForm.user.email.toLowerCase()
  registerForm.user.username = fieldsForm.user.username.toLowerCase()

  return registerForm
}
</script>

<template>
  <div class="flex h-screen flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h1 class="text-center text-6xl font-bold">BookStore.</h1>
      <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">Create your Account</h2>
    </div>
    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form class="space-y-6" @submit.prevent="submit">
        <div>
          <div class="flex items-center justify-between">
            <div>
              <label for="first_name" class="block text-sm font-medium leading-6 text-gray-900">First Name</label>
              <input id="first_name" name="first_name" type="text" v-model="fieldsForm.profile.first_name" autocomplete="first_name" required class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
            </div>
            <div class="ml-3">
              <label for="last_name" class="block text-sm font-medium leading-6 text-gray-900">Last Name</label>
              <input id="last_name" name="last_name" type="text" v-model="fieldsForm.profile.last_name" autocomplete="last_name" required class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
            </div>
          </div>

          <label for="username" class="block text-sm font-medium leading-6 text-gray-900">Username</label>
          <input id="username" name="username" type="text" v-model="fieldsForm.user.username" autocomplete="username" required class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />

          <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Email</label>
          <input id="email" name="email" type="email" v-model="fieldsForm.user.email" autocomplete="email" required class="mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />

          <label for="password" class="block text-sm font-medium leading-6 text-gray-900">Password</label>
          <input id="password" name="password" v-model="fieldsForm.user.password" type="password" autocomplete="current-password" required class="mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
        </div>

        <div>
          <button type="submit" :class="{'bg-violet-300 hover:bg-violet-400': isSubmiting}" class="flex w-full justify-center rounded-md bg-violet-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600" :disabled="isSubmiting">Register</button>
        </div>
      </form>
      <p class="mt-10 text-center text-sm text-gray-500">
        Do you have a account?
        <RouterLink :to="{name: 'login'}" class="font-semibold leading-6 text-violet-600 hover:text-violet-500">Login here</RouterLink>
      </p>
    </div>
  </div>
</template>

<style>
</style>
