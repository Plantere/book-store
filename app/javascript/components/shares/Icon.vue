<script setup>
  import { defineAsyncComponent } from 'vue';

  const props = defineProps({
    name: {
      type: String,
      required: true,
    },
    class: {
      required: false,
    }
  });

  const icon = defineAsyncComponent(() =>
    import(`../../assets/svgs/${props.name}.svg`)
  );
</script>

<template>
  <div>
    <span class="sr-only">{{ props.name }}</span>
    <component :is="icon" :class="props.class" />
  </div>
</template>