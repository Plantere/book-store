<script setup lang="ts">
import { defineAsyncComponent } from 'vue';

interface Props {
  name: string,
  class?: any
}

const props = defineProps<Props>();

const icon = defineAsyncComponent(() =>
  import(`../../assets/svgs/${props.name}.svg`)
);
</script>

<template>
  <span class="sr-only">{{ props.name }}</span>
  <component :is="icon" :class="props.class" />
</template>