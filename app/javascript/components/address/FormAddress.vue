<script setup lang="ts">
import { reactive, ref } from 'vue';
import { makeRequest } from '@/utils/request';
import { api_v1_addresses_create_path, api_v1_addresses_update_path } from '@/utils/routes';
import { useNotificationStore } from '@/stores/notification'

const notifications = useNotificationStore();

const isOpen = ref(false)
const emit = defineEmits(["updateAddress"])

const addressInitialData = {
  id: "",
  name: "",
	state: "",
	city: "",
	street: "",
	district: "",
	number: "",
	country: "",
	postal_code: "",
	phone_number: ""
}

const address = reactive({...addressInitialData})

const openModal = (addressData = addressInitialData) => {
  isOpen.value = true

  Object.assign(address, addressData)
}

const closeModal = () => {
  isOpen.value = false
}

const submit = async () => {
  const response = await makeRequest(address.id ? api_v1_addresses_update_path({id: address.id}) : api_v1_addresses_create_path(), 
  {
    method: address.id ? "PUT" : "POST", 
    data: {
      name: address.name,
      state: address.state,
      city: address.city,
      street: address.street,
      district: address.district,
      number: address.number,
      country: address.country,
      postal_code: address.postal_code,
      phone_number: address.phone_number
    }
  })

  if(!response.ok){
    notifications.createNotification(`Address cannot be ${address.id ? "updated" : "created"}`, "error")
    return
  }

  emit("updateAddress")
  notifications.createNotification(`Address ${address.id ? "updated" : "created"} successufly`, "success")
  closeModal()
}

defineExpose({
  openModal,
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
            <form @submit.prevent="submit" class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
              <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                  <div class="mt-3 sm:mt-0">
                  <span class="text-base font-semibold leading-6 text-gray-900">Address</span>
                  <div class="mt-2 flex flex-col">
                    <div class="flex space-x-2">
                      <fieldset class="w-9/12">
                        <label for="name" class="text-sm font-medium leading-6 text-gray-900">Name</label>
                        <input id="name" name="name" type="text" v-model="address.name" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>
                      <fieldset class="w-3/12">
                        <label for="country" class="text-sm font-medium leading-6 text-gray-900">Country</label>
                        <input id="country" name="country" type="text" v-model="address.country" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>
                    </div>

                    <div class="flex space-x-2">
                      <fieldset class="w-9/12">
                        <label for="city" class="text-sm font-medium leading-6 text-gray-900">City</label>
                        <input id="city" name="city" type="text" v-model="address.city" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>
                      <fieldset class="w-3/12">
                        <label for="state" class="text-sm font-medium leading-6 text-gray-900">State</label>
                        <input id="state" name="state" type="text" v-model="address.state" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>
                    </div>
  
                    <div class="flex space-x-2">
                      <fieldset class="w-4/12">
                        <label for="district" class="text-sm font-medium leading-6 text-gray-900">District</label>
                        <input id="district" name="district" type="text" v-model="address.district" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>

                      <fieldset class="w-6/12">
                        <label for="street" class="text-sm font-medium leading-6 text-gray-900">Street</label>
                        <input id="street" name="street" type="text" v-model="address.street" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>

                      <fieldset class="w-2/12">
                        <label for="number" class="text-sm font-medium leading-6 text-gray-900">Number</label>
                        <input id="number" name="number" type="text" v-model="address.number" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                      </fieldset>
                    </div>

                    <fieldset>
                      <label for="postal_code" class="text-sm font-medium leading-6 text-gray-900">Postal Code</label>
                      <input id="postal_code" name="postal_code" type="text" v-model="address.postal_code" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                    </fieldset>

                    <fieldset>
                      <label for="phone_number" class="text-sm font-medium leading-6 text-gray-900">Phone Number</label>
                      <input id="phone_number" name="phone_number" type="text" v-model="address.phone_number" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                    </fieldset>
                  </div>
                  </div>
                </div>
              </div>
              <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                <button class="inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-red-500 sm:ml-3 sm:w-auto" @click="closeModal()">Cancel</button>
                <button class="inline-flex w-full justify-center rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-violet-500 sm:ml-3 sm:w-auto" type="submit">
                  {{ address.id ? 'Update' : 'Create' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>