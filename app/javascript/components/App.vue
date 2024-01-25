<script setup>
import { RouterView } from 'vue-router'
import Toastfication from './notifications/Toastfication.vue';
</script>

<template>
  <div class="min-h-screen w-full bg-white">
    <Toastfication></Toastfication>
    <RouterView />
  </div>
</template>