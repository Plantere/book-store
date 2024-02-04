<script setup lang="ts">
import RowTable from './RowTable.vue';

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


interface Props {
  usersList: IUser[]
}

const props = defineProps<Props>()
const emit = defineEmits(["edit-user"])

</script>
<template>
  <table class="text-sm text-center text-gray-500 table-auto overflow-x-scroll w-full">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50">
      <tr>
        <th class="px-6 py-3">Id</th>
        <th class="px-6 py-3">Name</th>
        <th class="px-6 py-3">Type</th>
        <th class="px-6 py-3">Status</th>
        <th class="px-6 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <RowTable 
        v-for="user in props.usersList" 
        :key="user.id" 
        :user="user"
        @edit-user="emit('edit-user', user)"
      />
    </tbody>
  </table>
</template>