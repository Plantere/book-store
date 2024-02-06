<script setup lang="ts">
import Header from '../components/header/Header.vue';
import { ref } from 'vue';
import ImageInput from '@/components/ImageInput.vue';

const hashImages = ref([])

</script>

<template>
  <div>
    <Header />
    <div class="flex flex-col items-center h-screen justify-center">
      <h1 class="text-8xl font-bold">BookStore.</h1>
      <h3 class="text-5xl">Coming Soon...</h3>
      <ImageInput v-model="hashImages" path="avatar/1"/>
    </div>
  </div>

</template>

<style>
</style>
