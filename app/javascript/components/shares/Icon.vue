<script setup>
  import { defineAsyncComponent } from 'vue';

  const props = defineProps({
    name: {
      type: String,
      required: true,
    }
  });

  const icon = defineAsyncComponent(() =>
    import(`../../assets/svgs/${props.name}.svg`)
  );
</script>

<template>
  <div>
    <span class="sr-only">{{ props.name }}</span>
    <component :is="icon" />
  </div>
</template>