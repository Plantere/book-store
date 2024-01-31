<script setup lang="ts">
import { ref, computed } from 'vue';
import { useNotificationStore } from '../../stores/notification';
import {  api_v1_user_change_password_path } from '../../utils/routes';
import { makeRequest } from '../../utils/request';

const notifications = useNotificationStore()
const isOpen = ref(false)

const password = ref("")
const password_confirmation = ref("")

const canUpdatePassword = computed(() => {
  return password.value === password_confirmation.value && password.value !== ""
})

const closeModal = () => {
  isOpen.value = false
}

const openModal = () => {
  isOpen.value = true
}

const changePassword = async () => {
  if(!canUpdatePassword) return

  const response = await makeRequest(api_v1_user_change_password_path(), {method: "PUT", data: {
    password: password.value
  }})

  if(!response.ok){
    notifications.createNotification("User cannot change password", "error")
    closeModal()
    return
  }

  notifications.createNotification("Password changed successufly", "success")
  closeModal()
}

defineExpose({
  openModal
})
</script>

<template>
  <div v-if="isOpen">
    <div class="relative z-10">
      <div>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
      </div>

      <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
          <div>
            <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
              <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                  <div class="mt-3 sm:mt-0">
                  <span class="text-base font-semibold leading-6 text-gray-900">Security</span>
                  <div class="mt-2">
                    <div>
                      <label for="password" class="text-sm font-medium leading-6 text-gray-900">Password</label>
                      <input id="password" name="password" type="password" v-model="password" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                    </div>
                    <div>
                      <label for="password_confirmation" class="text-sm font-medium leading-6 text-gray-900">Confirm Password</label>
                      <input id="password_confirmation" name="password_confirmation" type="password" v-model="password_confirmation" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                    </div>
                  </div>
                  </div>
                </div>
              </div>
              <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                <button class="inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-red-500 sm:ml-3 sm:w-auto" @click="closeModal()">Cancel</button>
                <button :class="{'disabled:opacity-50': !canUpdatePassword}" class="inline-flex w-full justify-center rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-violet-500 sm:ml-3 sm:w-auto" :disabled="!canUpdatePassword" @click="changePassword()">Change Password</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>