<script setup lang="ts">
import Filter from "@/components/admin/users/Filter.vue"
import UsersTable from "@/components/admin/users/table/UsersTable.vue"
import type { IPagination } from "@/interfaces/pagination";
import { makeRequest } from "@/utils/request";
import { api_v1_admin_users_get_all_path } from '@/utils/routes';
import { onBeforeMount, ref } from "vue";
import EditUserModal from "./EditUserModal.vue";
import Pagination from "@/components/shares/Pagination.vue";

interface FormSearch {
  status?: number,
  type?: number,
  search?: string,
}

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

const formSearch = ref<FormSearch>({
  type: undefined,
  search: undefined,
  status: undefined,
})

const usersList = ref<IUser[]>()
const editUserModal = ref<InstanceType<typeof EditUserModal> | null>(null)
const paginationConfig = ref<IPagination>({
  totalItems: 0,
  currentPage: 1,
  perPage: 15,
})

const getUsers = async (search = formSearch.value, page = paginationConfig.value.currentPage) => {
  const response = await makeRequest(api_v1_admin_users_get_all_path({page, ...search}), {method: "GET"})
  formSearch.value = search

  if(!response.ok) {
    usersList.value = []
    paginationConfig.value = {
      totalItems: 0,
      currentPage: 1,
      perPage: 15,
    }
  }

  const data = await response.json();

  usersList.value = data.data
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
  
  paginationConfig.value = {
    totalItems: data.pagination.count,
    currentPage: data.pagination.page,
    perPage: 15
  }
}

const openEditUserModal = (user: IUser) => {
  if(!editUserModal) return

  editUserModal.value?.handleModal(true, user)
}

onBeforeMount(() => {
  getUsers()
})

</script>
<template>
  <div>
    <Filter @search-user="getUsers"/>
    <hr class="block w-full my-5">
    <div class="px-5 pb-4" v-if="usersList">
      <UsersTable :usersList="usersList" @edit-user="openEditUserModal"/>
      <div class="flex justify-center p-5" v-if="paginationConfig.totalItems > paginationConfig.perPage">
        <Pagination :total-items="paginationConfig.totalItems" :per-page="paginationConfig.perPage" :current-page="paginationConfig.currentPage" @change-page="getUsers(formSearch, $event)" />
      </div>
    </div>
  </div>
  <EditUserModal ref="editUserModal" @update-user="getUsers"/>
</template>