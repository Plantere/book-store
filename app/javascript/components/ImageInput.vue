<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';
import { watch, computed, ref, onMounted } from 'vue';
import { getImage, storeImage } from '@/services/supabase-service';
interface Image {
  token_image: string | undefined,
  path: string | undefined,
  is_default: boolean,
}

const images =  ref<Image[]>(
  [
    {
      token_image: undefined,
      path: undefined,
      is_default: false,
    }
  ]
)

const currentImage = ref<Image>(images.value[0])

const storageImage = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  const files = target.files as FileList;

  Array.from(files).forEach( async (element) => {
    const tokenImage = await storeImage(props.path, element)
    images.value.push({
      token_image: tokenImage,
      path: getImage(`public/${tokenImage}.png`),
      is_default: images.value.length < 2,
    })
  });
}

const previousImage = () => {
  const index = images.value.findIndex((image: Image) => image.token_image === currentImage.value.token_image)
  const image = images.value[index]
  const firstImage = images.value[0]

  if(image?.token_image === firstImage.token_image) {
    return currentImage.value = images.value[images.value.length-1]
  }

  currentImage.value = images.value[index-1]
}

const getDefaultImage = () => {
  currentImage.value = images.value.find((image: Image) => image.is_default === true)
}

const nextImage = () => {
  const index = images.value.findIndex((image: Image) => image.token_image === currentImage.value.token_image)
  const image = images.value[index]
  const lastImage = images.value[images.value.length-1]

  if(image?.token_image === lastImage.token_image) {
    return currentImage.value = images.value[0]
  }

  currentImage.value = images.value[index+1]
}

const removeImage = () => {
  images.value = images.value.filter((image: Image) => image.token_image !== currentImage.value.token_image)
  previousImage()
}

const setImageDefault = () => {
  if(getCurrentImage.value.is_default) return

  const actualImage = images.value.find((image: Image) => image.token_image === currentImage.value.token_image)
  const defaultImage = images.value.find((image: Image) => image.is_default === true)

  if(actualImage === undefined) return

  if(defaultImage !== undefined){
    defaultImage.is_default = false
  }

  actualImage.is_default = true
  currentImage.value = actualImage
}

const changeImage = (image: Image) => {
  currentImage.value = image
}

interface Props {
  modelValue?: Image[];
  width?: number,
  height?: number,
  path?: string,
}

const props = withDefaults(defineProps<Props>(), {
  width: 220,
  height: 300,
  path: 'public',
})

const getAvailableImage = computed( () => {
  return images.value.filter((image: Image) => image.path !== undefined)
})

const getCurrentImage = computed( () => {
  return currentImage.value
})

const emit = defineEmits(['update:modelValue'])

watch(images.value, () => {
  emit('update:modelValue', getAvailableImage.value.map( image => {
    return { path: image.path, token_image: image.token_image, is_default: image.is_default }
  }))
}, {deep: true})

onMounted(() => {
  images.value.push(...props.modelValue)
  getDefaultImage()
})




</script>
<template>
  <div class="relative flex flex-row justify-center w-[330px]" >
    <span class="text-xl font-bold absolute inset-y-2/4 right-4" @click="nextImage()">
      <Icon class="w-2 text-purple-600 hover:text-purple-400 cursor-pointer" name="next"></Icon>
    </span>
    <div class="w-[220px] h-[300px]">
      <div class="relative" v-if="getCurrentImage.token_image != null">
        <div @click="setImageDefault()">
          <Icon name="star" :class="{'fill-yellow-300 cursor-auto': getCurrentImage.is_default}" class="absolute right-2 top-2 w-6 h-6 text-yellow-300 cursor-pointer"></Icon>
        </div>
        <div @click="removeImage()">
          <Icon name="xmark" class="absolute right-2 top-10 w-6 h-6 text-red-600 cursor-pointer"></Icon>
        </div>
        <img :src="getCurrentImage.path" class="w-[220px] h-[300px]"/>
      </div>
      <label v-else for="dropzone-file" class="flex flex-col items-center justify-center border-2 w-[220px] h-[300px] border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50">
        <div class="flex flex-col items-center  text-center justify-center pt-5 pb-6">
          <Icon name="dropzone" class="w-8 h-8 mb-4 text-gray-500" />
          <p class="mb-2 text-xs text-gray-500"><span class="font-semibold">Click to upload a image</span></p>
          <p class="text-xs text-gray-500">PNG, JPG or WEBP</p>
        </div>
        <input @change="storageImage" multiple id="dropzone-file" type="file" class="hidden" accept="image/png, image/webp, image/jpeg"/>
      </label>
      <div class="flex flex-row space-x-2 justify-center p-3">
        <img v-for="image in modelValue" :key="image.token_image" :class="{'border-violet-600': image.token_image === getCurrentImage.token_image}"  class="w-[38px] h-[50px] border border-violet-100 shadow-xl" :src="image.path" alt="" @click="changeImage(image)">
      </div>
    </div>
    <span class="text-xl font-bold absolute inset-y-2/4 left-4" @click="previousImage()">
      <Icon class="w-2 text-purple-600 hover:text-purple-400 cursor-pointer" name="previous"></Icon>
    </span>
  </div>
</template>