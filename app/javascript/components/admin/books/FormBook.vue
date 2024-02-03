<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';
import { useNotificationStore } from '@/stores/notification';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_books_create_path, api_v1_admin_books_update_path, api_v1_admin_authors_get_all_path, api_v1_admin_genres_get_all_path, api_v1_admin_publishers_get_all_path } from '@/utils/routes';
import { reactive, ref } from 'vue';

const statusModal = ref(false)
const emit = defineEmits(["update"])
const notification = useNotificationStore()

const initialData = {
  id: null,
  title: null, 
  description: null,
  stock_quantity: null,
  price: null,
  status: null,
  author: {
    id: null,
    name: null,
  },
  publisher: {
    id: null,
    name: null,
  },
  genre: {
    id: null,
    name: null,
  },
}

const book = reactive({...initialData})

const openModal = (bookData = initialData) => {
  statusModal.value = true
  Object.assign(book, bookData)
}

const genres = ref([])
const authors = ref([])
const publishers = ref([])

const getGenres = async () => {
  const response = await makeRequest(api_v1_admin_genres_get_all_path(), {method: "GET"})
  if(!response.ok) return

  const data = await response.json()

  genres.value = data.data
}
const getAuthors = async () => {
  const response = await makeRequest(api_v1_admin_authors_get_all_path(), {method: "GET"})
  if(!response.ok) return

  const data = await response.json()

  authors.value = data.data
}
const getPublishers = async () => {
  const response = await makeRequest(api_v1_admin_publishers_get_all_path(), {method: "GET"})
  if(!response.ok) return

  const data = await response.json()

  publishers.value = data.data
}

getPublishers()
getGenres()
getAuthors()

const closeModal = () => {
  statusModal.value = false
}

const submit = async () => {
  const bookData = {
    name: book.title,
    publisher_id: book.publisher?.id,
    author_id: book.author?.id,
    description: book.description,
    price: book.price,
    stock_quantity: book.stock_quantity,
    genre_id: book.genre?.id,
  }
  
  let response;
  if(book.id){
    response = await makeRequest(api_v1_admin_books_update_path({id: book.id}), {method: "PUT", data: bookData})
  }else{
    response = await makeRequest(api_v1_admin_books_create_path(), {method: "POST", data: bookData})
  }

  if(!response.ok) {
    notification.createNotification(`Book cannot be ${book.id ? "updated" : "created"}`)
    return
  }

  notification.createNotification(`Book ${book.id ? "updated" : "created"} successufly`)
  emit("update")
  closeModal()
}

defineExpose({
  openModal,
})
</script>

<template>
  <div v-if="statusModal">
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
                    <span class="text-2xl font-semibold leading-6 text-gray-900">Book</span>
                    <hr class="my-5">
                    <div class="mt-2 flex flex-col w-96">
                      <div class="relative flex mb-5 justify-center">
                        <span class="text-xl font-bold absolute inset-y-2/4 right-4">
                          <Icon class="w-2 text-purple-600 hover:text-purple-400 cursor-pointer" name="next"></Icon>
                        </span>
                        <img  class="w-[200px]" src="https://placehold.co/990x1500"/>
                        <span class="text-xl font-bold absolute inset-y-2/4 left-4">
                          <Icon class="w-2 text-purple-600 hover:text-purple-400 cursor-pointer" name="previous"></Icon>
                        </span>
                      </div>
                      <div class="flex space-x-2">
                        <div class="w-full">
                          <label for="name" class="text-sm font-medium leading-6 text-gray-900">Name</label>
                          <input id="name" name="name" type="text" v-model="book.title" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                        </div>
                      </div>

                      <div class="flex space-x-2">
                        <div class="w-3/12">
                          <label for="stock_quantity" class="text-sm font-medium leading-6 text-gray-900">Quantity</label>
                          <input id="stock_quantity" name="stock_quantity" type="number" v-model="book.stock_quantity" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                        </div>
                        <div class="w-3/12">
                          <label for="price" class="text-sm font-medium leading-6 text-gray-900">Price</label>
                          <input id="price" name="price" type="text" v-model="book.price" required class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6" />
                        </div>
                        <div class="w-6/12">
                          <label for="genre" class="text-sm font-medium leading-6 text-gray-900">Genre</label>
                          <select name="genre" v-model="book.genre.id" id="genre" class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                            <option :value="null" class="text-gray-200" selected>Genres</option>
                            <option v-for="genre in genres" :value="genre.id">{{ genre.name }}</option>
                          </select>
                        </div>
                      </div>

                      <div class="flex space-x-2">
                        <div class="w-6/12">
                          <label for="publisher" class="text-sm font-medium leading-6 text-gray-900">Publisher</label>
                          <select name="publisher" v-model="book.publisher.id" id="publisher" class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                            <option :value="null" class="text-gray-200" selected>Publisher</option>
                            <option v-for="publisher in publishers" :value="publisher.id">{{ publisher.name }}</option>
                          </select>
                        </div>
                        <div class="w-6/12">
                          <label for="author" class="text-sm font-medium leading-6 text-gray-900">Author</label>
                          <select name="author" v-model="book.author.id" id="author" class="mt-2 mb-2 w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                            <option :value="null" class="text-gray-200" selected>Author</option>
                            <option v-for="author in authors" :value="author.id">{{ author.full_name }}</option>
                          </select>
                        </div>
                      </div>
                      
                      <div class="flex space-x-2">
                        <div class="w-full">
                          <label for="description" class="block mb-2 text-sm font-medium text-gray-900">Description</label>
                          <textarea id="description" rows="4" v-model="book.description" class="block p-2.5 w-full text-sm text-gray-900 rounded-lg border border-gray-300 focus:ring-violet-600 focus:border-violet-600"></textarea>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                <button class="inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-red-500 sm:ml-3 sm:w-auto" @click="closeModal()">Cancel</button>
                <button class="inline-flex w-full justify-center rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-violet-500 sm:ml-3 sm:w-auto" @click="submit()">
                  {{ book.id ? 'Update' : 'Create' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>