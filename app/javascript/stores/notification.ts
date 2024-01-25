import { defineStore } from 'pinia';

interface Notification {
  id: string;
  message: string;
  type: string;
  duration: number;
}

export const useNotificationStore = defineStore('notifications', {
  state: () => ({
    notificationList: [] as Notification[],
  }),
  
  actions: {
    createNotification(message: string, type: string = "default", duration: number = 3000): void {
      const id = crypto.randomUUID();
      this.notificationList.push({
        id,
        message,
        type,
        duration
      });

      setTimeout(() => {
        this.closeNotification(id);
      }, duration);
    },
    closeNotification(targetId: string): void {
      this.notificationList = this.notificationList.filter((notification: Notification) => notification.id !== targetId);
    }
  },
});
