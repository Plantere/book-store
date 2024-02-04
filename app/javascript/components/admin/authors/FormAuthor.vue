<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';
import { useNotificationStore } from '@/stores/notification';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_authors_update_path, api_v1_admin_authors_create_path } from '@/utils/routes';
import { ref, toRaw } from 'vue';

interface IAuthor {
  id?: number,
  full_name?: string
  total_books?: number
  biography?: string
  birth_date?: string
}

const initialAuthor: IAuthor = {
  id: undefined,
  full_name: undefined, 
  biography: undefined,
  birth_date: undefined,
}

const notification = useNotificationStore()

const emit = defineEmits(["update-author"])
const statusModal = ref(false)
const authorData = ref<IAuthor | null>()

const handleModal = (value: boolean, author: IAuthor= initialAuthor) => {
  statusModal.value = value
  authorData.value = structuredClone(toRaw(author)) 
}

const submitAuthor = async () => {
  if(!authorData.value) return;
  
  let response;
  if(authorData.value.id) {
    response = await makeRequest(api_v1_admin_authors_update_path({id: authorData.value.id}), {method: "PUT", data: authorData.value})
  } else {
    response = await makeRequest(api_v1_admin_authors_create_path(), {method: "POST", data: authorData.value})
  }

  if(!response.ok) {
    notification.createNotification(`Author cannot be ${authorData.value.id ? "updated" : "created"}`, 'success')
    return
  }

  notification.createNotification(`Author ${authorData.value.id ? "updated" : "created"} successufly`, 'success')
  emit("update-author")
  handleModal(false)
}

defineExpose({
  handleModal,
})

</script>
<template>
  <div v-if="statusModal && authorData">
    <div class="relative z-10">
      <div>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
      </div>

      <div class="fixed inset-0 z-10 w-screen overflow-x-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0 ">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl  my-8 w-full max-w-screen-lg">
            <div class="relative p-4">
              <span class="text-xl font-semibold">Author</span>
              <div class="absolute top-0 right-0 p-5 cursor-pointer" @click="handleModal(false)">
                <Icon name="xmark" class="w-6"></Icon>
              </div>
            </div>

            <hr class="w-full mb-4">
            
            <div class="flex flex-row">              
              <div class="flex flex-col px-4 w-4/6">
                <label for="full_name" class="text-sm font-medium leading-6 text-gray-900">Full name</label>
                <input id="full_name" v-model="authorData.full_name" name="full_name" type="text" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
              <div class="flex flex-col px-4 w-2/6">
                <label for="birth_date" class="text-sm font-medium leading-6 text-gray-900">Birth Date</label>
                <input id="birth_date" v-model="authorData.birth_date" name="birth_date" type="text" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
            </div>

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-full">
                <label for="biography" class="text-sm font-medium leading-6 text-gray-900">Biography</label>
                <textarea id="biography" v-model="authorData.biography" name="biography" type="text" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6"></textarea>
              </div>
            </div>

            <div class="flex flex-row m-5 justify-end">
              <button @click="submitAuthor()" class="rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">{{ authorData.id ? "Update" : "Create" }}</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>