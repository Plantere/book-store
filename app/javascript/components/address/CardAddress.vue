<script setup lang="ts">
import Icon from '../shares/Icon.vue';

const emit = defineEmits(["edit", "delete", "changeDefaultAddress"])

const openEditAddress = () => {
  emit('edit', props.address)
}

const deleteAddress = () => {
  emit('delete', props.address?.id)
}

const changeDefaultAddress = () => {
  if(props.address?.is_default) return

  emit('changeDefaultAddress', props.address?.id)
}

const props = defineProps({
  address: Object
})

</script>

<template>
  <div class="relative flex flex-col shadow-md p-5 rounded-xl w-[320px] h-[250px]">
    <Icon :class="{'fill-yellow-300 cursor-auto': props.address?.is_default}" name="star" class="absolute right-0 top-0 w-6 h-6 text-yellow-300 cursor-pointer" @click="changeDefaultAddress()"></Icon>
    <span class="text-xl font-bold text-gray truncate">{{ props.address?.name }}</span>
    <span class="text-sm font-semibold text-gray">{{props.address?.street}} {{props.address?.number}}</span>
    <span class="text-sm font-semibold text-gray">{{props.address?.district}}</span>
    <span class="text-sm font-semibold text-gray">{{props.address?.city}}, {{props.address?.state}} - {{props.address?.postal_code}}</span>
    <span class="text-sm font-semibold text-gray">{{props.address?.country}}</span>
    <span class="text-sm font-semibold text-gray">{{ props.address?.phone_number }}</span>
    <div class="absolute bottom-4 flex space-x-4 mt-4">
      <button class="font-semibold leading-6 text-violet-600 hover:text-violet-500" @click="openEditAddress()">Edit</button>
      <span> | </span>
      <button class="font-semibold leading-6 text-violet-600 hover:text-violet-500" @click="deleteAddress()">Remove</button>
    </div>
  </div>
</template>