<script setup lang="ts">
import { ref } from 'vue';
import { api_v1_addresses_delete_path, api_v1_addresses_get_path, api_v1_addresses_update_default_path } from '@/utils/routes';
import { makeRequest } from '@/utils/request';
import { useNotificationStore } from '@/stores/notification'

import Icon from '@/components/shares/Icon.vue';
import Pagination from '@/components/shares/Pagination.vue';
import CardAddress from './CardAddress.vue';
import FormAddress from './FormAddress.vue';
import type { Address } from '@/interfaces/address';

const formAddressModal = ref<InstanceType<typeof FormAddress> | null>(null)

const notifications = useNotificationStore();

const addressesList = ref<Address[]>([])
const paginationConfig = ref({
  totalItems: 0,
  currentPage: 1,
  perPage: 5,
})

const openFormAddress = (address = undefined) => {
  formAddressModal.value?.openModal(address)
}

const getAddresses = async (page = 1) => {
  const response = await makeRequest(api_v1_addresses_get_path({page}), {method: "GET"})

  if(!response.ok){
    addressesList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 5,
    }
  }

  const data = await response.json();

  addressesList.value = data.data
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
  
  paginationConfig.value = {
    totalItems: data.pagination.count,
    currentPage: data.pagination.page,
    perPage: 5
  }
}

const removeAddress = async (addressId: number) => {
  const response = await makeRequest(api_v1_addresses_delete_path({id: addressId}), {method: "DELETE"})

  if(!response.ok){
    notifications.createNotification("Address cannot be deleted", "error")
    return
  }
  
  getAddresses(paginationConfig.value.currentPage)
  notifications.createNotification("Address deleted successufly", "success")
}

const changeDefaultAddress = async (addressId: number) => {
  const response = await makeRequest(api_v1_addresses_update_default_path({id: addressId}), {method: "PUT"})

  if(!response.ok){
    notifications.createNotification("Address cannot bet set as default", "error")
    return
  }
  
  getAddresses(paginationConfig.value.currentPage)
  notifications.createNotification("Address set as default", "success")
}

getAddresses()

</script>

<template>
  <div>
    <div class="flex px-5">
      <Icon name="map" class="flex w-6 mr-3 mt-6"></Icon>
      <h1 class="text-2xl py-5 font-bold">Address</h1>
    </div>
    <hr>
    <div class="flex px-5 justify-center mb-[120px]">
      <div class="grid grid-cols-2 max-[1200px]:grid-cols-1 gap-10 mt-5 items-center justify-center">
        <div class="select-none cursor-pointer flex flex-col justify-content items-center p-5 rounded-xl w-[320px] h-[250px] border-dashed border-2 border-gray-600" @click="openFormAddress()">
          <Icon name="plus" class="w-32 mr-3 mt-6 text-gray-600"></Icon>
          <span class="text-3xl text-gray-600">Add Address</span>
        </div>

        <CardAddress :address="address" v-for="(address) in addressesList" :key="address.id" @edit="openFormAddress" @delete="removeAddress" @change-default-address="changeDefaultAddress"/>
      </div>

      <div class="absolute flex justify-center bottom-10" v-if="paginationConfig.totalItems > paginationConfig.perPage">
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getAddresses" />
      </div>
    </div>
    <FormAddress ref="formAddressModal" @update-address="getAddresses(paginationConfig.currentPage)"/>
  </div>
</template>