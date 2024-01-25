<script setup>
import Icon from '../shares/Icon.vue';

const emit = defineEmits(["close"]);
const props = defineProps({
  message: { type: String, required: true },
  type: { type: String, default: 'default', validator: (value) => ['default', 'error', 'warning', 'success'].includes(value) },
});

const colors = {
  error: {
    iconName: 'error',
    ariaLabel: 'Error notification',
    class: 'text-red-500 bg-red-100',
  },
  warning: {
    iconName: 'warning',
    ariaLabel: 'Warning notification',
    class: 'text-orange-500 bg-orange-100',
  },
  success: {
    iconName: 'check',
    ariaLabel: 'Success notification',
    class: 'text-green-500 bg-green-100',
  },
};

const closeNotification = () => {
  emit('close')
}

</script>

<template>
  <div class="flex fade-out items-center p-4 text-gray-500 bg-white rounded-lg shadow mt-5" role="alert" :class="{ 'toast-default': props.type === 'default' }">
    <div v-if="props.type !== 'default'" :class="colors[props.type].class" class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 rounded-lg" :aria-label="colors[props.type].ariaLabel">
      <Icon class="w-5 h-5" :name="colors[props.type].iconName" />
    </div>
    <div class="ms-3 text-sm font-normal">{{ props.message }}</div>
    <button @click="closeNotification" type="button" class="ms-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex items-center justify-center h-8 w-8" data-dismiss-target="#toast-default" aria-label="Close notification">
      <Icon class="w-3 h-3" name="close" />
    </button>
  </div>
</template>