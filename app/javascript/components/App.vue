<script setup lang="ts">
import { RouterView } from 'vue-router'
import Toastfication from '@/components/notifications/Toastfication.vue';

</script>

<template>
  <div class="min-h-screen w-full bg-violet-50">
    <Toastfication/>
    <RouterView />
  </div>
</template>