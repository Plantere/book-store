<script setup lang="ts">
import { ref, computed, reactive } from 'vue';
import { useUserStore } from '../../stores/user';
import { useNotificationStore } from '../../stores/notification';
import { api_v1_user_update_path } from '../../utils/routes';
import { makeRequest } from '../../utils/request';

import ChangePassword from './ChangePassword.vue'
import Icon from '../../components/shares/Icon.vue';

const user = useUserStore()
const notifications = useNotificationStore()


const profileData = reactive({
  firstName: user.profile.first_name,
  lastName: user.profile.last_name,
  username: user.user.username,
  description: user.profile.description ?? "",
  email: user.user.email,
})

const isUpdating = computed(() => {
  return profileData.firstName === user.profile.first_name &&
         profileData.lastName === user.profile.last_name &&
         profileData.username === user.user.username &&
         profileData.description === (user.profile.description ?? "") &&
         profileData.email === user.user.email
})

const ChangePasswordModal = ref<InstanceType<typeof ChangePassword> | null>(null)

const openChangePassword = () => {
  ChangePasswordModal.value?.openModal()
}

const updateProfile = async () => {
  if(!isUpdating) return

  const response = await makeRequest(api_v1_user_update_path(), {method: "PUT", data: {
    user: {
      username: profileData.username,
      email: profileData.email,
    },
    profile: {
      description: profileData.description,
      fist_name: profileData.firstName,
      last_name: profileData.lastName
    }
  }})

  if(!response.ok){
    notifications.createNotification("Email, or username already been used", "error")
    return
  }

  user.getAuthenticateUser()
  
  notifications.createNotification("User updated successufly", "success")
}

</script>

<template>
  <div>
    <div class="flex px-5">
      <Icon name="profile" class="flex items-center w-6 mr-3 mt-6" />
      <h1 class="text-2xl py-5 font-bold">Profile</h1>
    </div>
    <hr>
    <div class="p-5">
      <div class="flex flex-row space-x-3">
        <div class="flex flex-col w-6/12">
          <label for="first_name" class="text-sm font-medium leading-6 text-gray-900">First Name</label>
          <input id="first_name" name="first_name" v-model="profileData.firstName" type="text" autocomplete="first_name" required
            class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
        </div>
        <div class="flex flex-col w-6/12">
          <label for="last_name" class="text-sm font-medium leading-6 text-gray-900">Last Name</label>
          <input id="last_name" name="last_name" v-model="profileData.lastName" type="text" autocomplete="last_name" required
            class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
        </div>
      </div>

      <div class="flex flex-row space-x-3">
        <div class="flex flex-col w-6/12">
          <label for="username" class="text-sm font-medium leading-6 text-gray-900">Username</label>
          <input id="username" name="username" type="text" v-model="profileData.username" autocomplete="username" required
            class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
        </div>

        <div class="flex flex-col w-6/12">
          <label for="email" class="text-sm font-medium leading-6 text-gray-900">E-mail</label>
          <input id="email" name="email" type="text" v-model="profileData.email" autocomplete="email" required class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
        </div>
      </div>
      <div>
        <label for="description" class="block mb-2 text-sm font-medium text-gray-900">Description</label>
        <textarea id="description" rows="4" v-model="profileData.description" class="block p-2.5 w-full text-sm text-gray-900 rounded-lg border border-gray-300 focus:ring-violet-600 focus:border-violet-600" placeholder="Write about yourself."></textarea>
      </div>
      <div class="flex justify-end space-x-3 mt-10">
        <button @click="openChangePassword()" class="flex justify-center items-center bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6">
          <Icon name="lock" class="mr-3 w-6"></Icon>
          Change Passsword
        </button>
        <button :class="{'disabled:opacity-50': isUpdating}" class="bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6" :disabled="isUpdating" @click="updateProfile()">Apply Changes</button>
      </div>
    </div>

    <ChangePassword ref="ChangePasswordModal"/>
  </div>

</template>