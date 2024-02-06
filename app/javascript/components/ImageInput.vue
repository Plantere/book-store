<script setup lang="ts">
import Icon from '@/components/shares/Icon.vue';
import { watch, computed, ref } from 'vue';
import { storeImage } from '@/services/supabase-service';
import { Console } from 'console';
import { randomUUID } from 'crypto';

const currentImage = ref<number>(0)
const hashImages = ref<string[]>([])


interface Image {
  hash: string | undefined,
  url: string | undefined,
}

const images =  ref<Image[]>(
  [
    {
      hash: undefined,
      url: undefined,
    }
  ]
)


const storageImage = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  const files = target.files as FileList;

  Array.from(files).forEach( async (element) => {
    images.value.push({
      hash: await storeImage(props.path, element),
      url: URL.createObjectURL(element),
    })
  });
}

const previousImage = () => {
  if(images.value.length <= 1) return

  if(currentImage.value === 0) return currentImage.value = images.value.length-1
  
  currentImage.value -= 1

}

const nextImage = () => {
  if(images.value.length <= 1) return
  if(currentImage.value === images.value.length-1) return currentImage.value = 0

  currentImage.value += 1
}

const removeImage = (imageIndex: number) => {
  // previousImage()
  // images.value = images.value.filter((item, index) => index !== imageIndex)
  // hashImages.value = hashImages.value.filter((item, index) => index !== imageIndex)
  // console.log(images.value)
  // console.log(hashImages.value)
}

const setImageDefault = (imageIndex: number) => {
}

const changeImage = (hashImage: string | undefined) => {
  if(hashImage === undefined) return 
  currentImage.value = images.value.findIndex((image: Image) => image.hash !== hashImage)
}

interface Props {
  modelValue?: string[];
  width?: number,
  height?: number,
  path: string,
}

const props = withDefaults(defineProps<Props>(), {
  width: 220,
  height: 300,
})

const getAvailableImage = computed( () => {
  return images.value.filter((image: Image) => image.url !== undefined)
})

const getCurrentImage = computed( () => {
  if(currentImage === undefined) return images.value[0]
  return images.value[currentImage.value]
})

const emit = defineEmits(['update:modelValue'])

watch(hashImages.value, () => {
  emit('update:modelValue', hashImages.value)
}, {deep: true})

</script>
<template>
  <div :class="`relative flex flex-row justify-center w-[${props.width+100}px]`" >
    <span class="text-xl font-bold absolute inset-y-2/4 right-4" @click="nextImage()">
      <Icon class="w-2 text-purple-600 hover:text-purple-400 cursor-pointer" name="next"></Icon>
    </span>
    <div :class="`w-[${props.width}px] h-[${props.height}px]`">
      <div class="relative" v-if="currentImage >= 1">
        <div @click="setImageDefault(currentImage)">
          <Icon name="star" class="absolute right-2 top-2 w-6 h-6 text-yellow-300 cursor-pointer"></Icon>
        </div>
        <div @click="removeImage(currentImage)">
          <Icon name="xmark" class="absolute right-2 top-10 w-6 h-6 text-red-600 cursor-pointer"></Icon>
        </div>
        <img :src="images[currentImage].url" :class="`w-[${props.width}px] h-[${props.height}px]`"/>
      </div>
      <label v-else for="dropzone-file" :class="`flex flex-col items-center justify-center border-2 w-[${props.width}px] h-[${props.height}px] border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50`">
        <div class="flex flex-col items-center  text-center justify-center pt-5 pb-6">
          <Icon name="dropzone" class="w-8 h-8 mb-4 text-gray-500" />
          <p class="mb-2 text-xs text-gray-500"><span class="font-semibold">Click to upload a image</span></p>
          <p class="text-xs text-gray-500">PNG, JPG or WEBP</p>
        </div>
        <input @change="storageImage" multiple id="dropzone-file" type="file" class="hidden" accept="image/png, image/webp, image/jpeg"/>
      </label>

      <div class="flex flex-row space-x-2 justify-center p-3">
        <div v-for="image in getAvailableImage" :key="image.hash">
          <img :class="{'border-violet-100': image.hash !== getCurrentImage.hash}"  class="w-[38px] h-[50px] border border-violet-600 shadow-xl" :src="image.url" alt="" @click="changeImage(image.hash)">
        </div>
      </div>
    </div>
    <span class="text-xl font-bold absolute inset-y-2/4 left-4" @click="previousImage()">
      <Icon class="w-2 text-purple-600 hover:text-purple-400 cursor-pointer" name="previous"></Icon>
    </span>
  </div>
</template>