<script setup lang="ts">
import ImageInput from '@/components/ImageInput.vue';
import Icon from '@/components/shares/Icon.vue';
import { getImage } from '@/services/supabase-service';
import { useNotificationStore } from '@/stores/notification';
import { makeRequest } from '@/utils/request';
import { api_v1_admin_books_update_path, api_v1_admin_books_create_path, api_v1_admin_genres_get_all_path, api_v1_admin_authors_get_all_path, api_v1_admin_publishers_get_all_path } from '@/utils/routes';
import { onBeforeMount, ref, toRaw } from 'vue';

interface IImage {
  path: string,
  token_image: string,
  is_default: boolean,
}

interface IDefault {
  id?: number,
  name?: string
}

interface IAuthor {
  id: number,
  full_name: string
}

interface IBook {
  id?: number,
  title?: string,
  description?: string,
  stock_quantity?: number,
  price?: number | string,
  status?: number,
  images?: IImage[],
  author: IDefault,
  publisher: IDefault,
  genre: IDefault,
}

const initialData: IBook = {
  id: undefined,
  title: undefined, 
  description: undefined,
  stock_quantity: undefined,
  price: undefined,
  status: undefined,
  author: {
    id: undefined,
    name: undefined,
  },
  publisher: {
    id: undefined,
    name: undefined,
  },
  genre: {
    id: undefined,
    name: undefined,
  },
}

const notification = useNotificationStore()

const emit = defineEmits(["update-book"])
const statusModal = ref(false)
const bookData = ref<IBook | null>()

const genres = ref<IDefault[]>()
const authors = ref<IDefault[]>()
const publishers = ref<IDefault[]>()
const images = ref([])

const handleModal = (value: boolean, book: IBook= initialData) => {
  statusModal.value = value
  bookData.value = structuredClone(toRaw(book)) 
  if(!bookData.value.images) return

  bookData.value.images = bookData.value.images.map(image => {
    return {
      path: getImage(image.path),
      token_image: image.token_image,
      is_default: image.is_default,
    }
  })
}

const statusEnums = [
  {value: 1, name: "Active"},
  {value: 2, name: "Inactive"}
]

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

  authors.value = data.data.map((item: IAuthor) => {
    return {id: item.id, name: item.full_name}
  })
}
const getPublishers = async () => {
  const response = await makeRequest(api_v1_admin_publishers_get_all_path(), {method: "GET"})
  if(!response.ok) return

  const data = await response.json()
  publishers.value = data.data
}

const submitBook = async () => {
  if(!bookData.value) return;
  
  const book = {
    name: bookData.value.title,
    status: bookData.value.status,
    publisher_id: bookData.value.publisher?.id,
    author_id: bookData.value.author?.id,
    description: bookData.value.description,
    price: bookData.value.price,
    stock_quantity: bookData.value.stock_quantity,
    genre_id: bookData.value.genre?.id,
    images: bookData.value.images?.map(image => {
      return {url: `public/${image.token_image}.png`, token_image: image.token_image, is_default: image.is_default}
    })
  }
  
  let response;
  if(bookData.value.id) {
    response = await makeRequest(api_v1_admin_books_update_path({id: bookData.value.id}), {method: "PUT", data: book})
  } else {
    response = await makeRequest(api_v1_admin_books_create_path(), {method: "POST", data: book})
  }

  if(!response.ok) {
    notification.createNotification(`Book cannot be ${bookData.value.id ? "updated" : "created"}`, 'success')
    return
  }

  notification.createNotification(`Book ${bookData.value.id ? "updated" : "created"} successufly`, 'success')
  emit("update-book")
  handleModal(false)
}

onBeforeMount( () => {
  getPublishers()
  getGenres()
  getAuthors()
})

defineExpose({
  handleModal,
})

</script>
<template>
  <div v-if="statusModal && bookData">
    <div class="relative z-10">
      <div>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
      </div>

      <div class="fixed inset-0 z-10 w-screen overflow-x-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0 ">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl  my-8 w-full max-w-screen-lg">
            <div class="relative p-4">
              <span class="text-xl font-semibold">Book</span>
              <div class="absolute top-0 right-0 p-5 cursor-pointer" @click="handleModal(false)">
                <Icon name="xmark" class="w-6"></Icon>
              </div>
            </div>

            <hr class="w-full mb-4">
            <div class="flex w-full mb-20 justify-center">
              <ImageInput v-model="bookData.images" />
            </div>
            <div class="flex flex-row">              
              <div class="flex flex-col px-4 w-4/6">
                <label for="title" class="text-sm font-medium leading-6 text-gray-900">Title</label>
                <input id="title" v-model="bookData.title" name="title" type="text" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
              <div class="flex flex-col px-4 w-2/6">
                <label for="genre" class="text-sm font-medium leading-6 text-gray-900">Genre</label>
                <select name="genre" id="genre" v-model="bookData.genre.id" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                  <option :value="undefined" selected disabled class="text-center text-gray-200"> Genre </option>
                  <option :value="data.id" v-for="data in genres">{{ data.name }}</option>
                </select>
              </div>
            </div>

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-2/6">
                <label for="quantity" class="text-sm font-medium leading-6 text-gray-900">Quantity</label>
                <input id="quantity" v-model="bookData.stock_quantity" name="quantity" type="number" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
              <div class="flex flex-col px-4 w-2/6">
                <label for="price" class="text-sm font-medium leading-6 text-gray-900">Price</label>
                <input id="price" v-model="bookData.price" name="price" type="text" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
              </div>
              <div class="flex flex-col px-4 w-2/6">
                <label for="status" class="text-sm font-medium leading-6 text-gray-900">Status</label>
                <select name="status" id="status" v-model="bookData.status" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                  <option :value="undefined" selected disabled class="text-center text-gray-200"> Status </option>
                  <option :value="data.value" v-for="data in statusEnums">{{ data.name }}</option>
                </select>
              </div>
            </div>

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-3/6">
                <label for="title" class="text-sm font-medium leading-6 text-gray-900">Publisher</label>
                <select name="publisher" id="publisher" v-model="bookData.publisher.id" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                  <option :value="undefined" selected disabled class="text-center text-gray-200"> Publisher </option>
                  <option :value="data.id" v-for="data in publishers">{{ data.name }}</option>
                </select>
              </div>
              <div class="flex flex-col px-4 w-3/6">
                <label for="title" class="text-sm font-medium leading-6 text-gray-900">Author </label>
                <select name="author" id="author" v-model="bookData.author.id" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6">
                  <option :value="undefined" selected disabled class="text-center text-gray-200"> Author </option>
                  <option :value="data.id" v-for="data in authors">{{ data.name }}</option>
                </select>
              </div>
            </div>

            <div class="flex flex-row">
              <div class="flex flex-col px-4 w-full">
                <label for="description" class="text-sm font-medium leading-6 text-gray-900">Description</label>
                <textarea id="description" v-model="bookData.description" name="title" type="text" class="mt-2 mb-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-violet-600 sm:text-sm sm:leading-6"></textarea>
              </div>
            </div>

            <div class="flex flex-row m-5 justify-end">
              <button @click="submitBook()" class="rounded-md bg-violet-600 px-3 py-2 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-violet-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-600">{{ bookData.id ? "Update" : "Create" }}</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>