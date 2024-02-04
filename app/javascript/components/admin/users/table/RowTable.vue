<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';
import { computed } from 'vue';

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
  user: IUser
}

const props = defineProps<Props>()
const emit = defineEmits(["edit-user"])

const statusUsersEnums = [
  {value: 1, name: "Active", class: "bg-green-300", fontClass: "text-green-700"},
  {value: 2, name: "Inactive", class: "bg-yellow-300", fontClass: "text-yellow-700"},
  {value: 3, name: "Banned", class: "bg-red-300", fontClass: "text-red-700"},
]

const currentStatus = computed(() => {
  return statusUsersEnums.find(status => status.value === props.user.status) ?? statusUsersEnums[statusUsersEnums.length-1]
})


</script>
<template>
  <tr class="bg-white border-b">
    <td class="px-6 py-4"># {{ props.user.id }}</td>
    <td class="flex flex-col px-6 py-4">
      <div>
        {{ props.user.profile.first_name }} {{ props.user.profile.last_name }}
      </div>
      <div>
        <span>
          {{ props.user.email }}
        </span>
      </div>
    </td>
    <td class="px-6 py-4">{{ props.user.user_type ? "Admin" : "Customer" }}</td>
    <td class="px-6 py-4">
      <div :class="currentStatus.class" class="p-1 mx-3 rounded-xl">
        <span :class="currentStatus.fontClass">
          {{ currentStatus.name }}
        </span>
      </div>
    </td>
    <td class="relative h-full">
      <button class="relative group">
        <Icon name="down" class="w-5"></Icon>
        <div class="group-hover:block group-focus:block absolute hidden left-0 z-10 bg-white divide-y divide-gray-100 rounded-lg shadow w-36">
          <ul class="py-2 text-sm text-gray-700">
            <li>
              <a class="block p-2 hover:bg-gray-100" @click="emit('edit-user')">Edit</a>
            </li>
          </ul>
        </div>
      </button>
    </td>
  </tr>
</template>