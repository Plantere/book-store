<script setup>
import CardNotification from './CardNotification.vue';
import { useNotificationStore } from '../../stores/notification'

const notifications = useNotificationStore();
</script>

<template>
  <div class="flex flex-col fixed right-0 w-full max-w-xs mr-5 z-50">
    <TransitionGroup name="fade">
      <CardNotification v-for="notification in notifications.notificationList" :key="notification.id" :message="notification.message" :type="notification.type" @close="notifications.closeNotification(notification.id)"/>
    </TransitionGroup>
  </div>
</template>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>