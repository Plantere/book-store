<script setup>
import { RouterView } from 'vue-router'
import Toastfication from './notifications/Toastfication.vue';

</script>

<template>
  <div class="min-h-screen w-full bg-violet-50">
    <Toastfication/>
    <RouterView />
  </div>
</template>