<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';
import { useNotificationStore } from '@/stores/notification';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_users_update_path } from '@/utils/routes';
import { ref, toRaw } from 'vue';

interface IProfile {
  first_name: string,
  last_name: string,
  birth_date?: string,
  description?: string,
}

interface IUser {
  id: string,
  email: string,
  username: string,
  status: number,
  user_type: number,
  profile: IProfile,
}

const statusUserEnums = [
  {value: 1, name: "Active"},
  {value: 2, name: "Inactive"},
  {value: 3, name: "Banned"},
]

const typeUserEnums = [
  {value: 2, name: "Admin"},
  {value: 1, name: "Customer"},
]

const notification = useNotificationStore()

const emit = defineEmits(["update-user"])
const statusModal = ref(false)
const userData = ref<IUser | null>()

const handleModal = (value: boolean, user?: IUser) => {
  statusModal.value = value
  userData.value = structuredClone(toRaw(user)) 
}

const updateUser = async () => {
  const response = await makeRequest(api_v1_admin_users_update_path({id: userData.value?.id}), {method: "PUT", data: {
    user: {
      status: userData.value?.status,
      user_type: userData.value?.user_type,
      email: userData.value?.email,
      username: userData.value?.username,
    },
    profile: {
      first_name: userData.value?.profile.first_name,
      last_name: userData.value?.profile.last_name,
      description: userData.value?.profile.description
    },
  }})

  if(!response.ok) {
    notification.createNotification(`User cannot be updated`, 'error')
    handleModal(false)
    return
  }

  notification.createNotification(`User updated successufly`, 'success')
  emit("update-user")
  handleModal(false)
}

defineExpose({
  handleModal,
})

</script>
<template>
  <div v-if="statusModal && userData">
    <div class="relative z-10">
      <div>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
      </div>

      <div class="fixed inset-0 z-10 w-screen overflow-x-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0 ">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl  my-8 w-full max-w-screen-lg">
            <div class="relative p-4">
              <span class="text-xl font-semibold">Usuario #{{ userData.id }} </span>
              <div class="absolute top-0 right-0 p-5 cursor-pointer" @click="handleModal(false)">
                <Icon name="xmark" class="w-6"></Icon>
              </div>
            </div>

            <hr class="w-full mb-4">

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-3/6">
                <label for="first_name" class="text-sm font-medium leading-6 text-gray-900">First Name</label>
                <input id="first_name" name="first_name" type="text" v-model="userData.profile.first_name" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
              <div class="flex flex-col px-4 w-3/6">
                <label for="last_name" class="text-sm font-medium leading-6 text-gray-900">Last Name</label>
                <input id="last_name" name="last_name" type="text" v-model="userData.profile.last_name" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
            </div>

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-3/6">
                <label for="email" class="text-sm font-medium leading-6 text-gray-900">E-mail</label>
                <input id="email" name="email" type="email" v-model="userData.email" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
              <div class="flex flex-col px-4 w-3/6">
                <label for="username" class="text-sm font-medium leading-6 text-gray-900">Username</label>
                <input id="username" name="username" type="text" v-model="userData.username" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
            </div>


            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-3/6">
                <label for="type" class="text-sm font-medium leading-6 text-gray-900">Type</label>
                <select name="type" id="type" v-model="userData.user_type" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                  <option :value="null" selected disabled>User Type</option>
                  <option :value="date.value" v-for="date in typeUserEnums">{{ date.name }}</option>
                </select>
              </div>
              <div class="flex flex-col px-4 w-3/6">
                <label for="username" class="text-sm font-medium leading-6 text-gray-900">Status</label>
                <select name="type" id="type" v-model="userData.status" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6"s>
                  <option :value="null" selected disabled>User Status</option>
                  <option :value="date.value" v-for="date in statusUserEnums">{{ date.name }}</option>
                </select>
              </div>
            </div>

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-full">
                <label for="description" class="text-sm font-medium leading-6 text-gray-900">Description</label>
                <textarea id="description" v-model="userData.profile.description" rows="4" class="block p-2.5 w-full text-sm text-gray-900 rounded-lg border border-gray-300 focus:ring-violet-600 focus:border-violet-600"></textarea>
              </div>
            </div>


            <div class="flex flex-row m-5 justify-end">
              <button @click="updateUser()" class="rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">Update</button>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>