import { defineStore } from 'pinia'
import { api_v1_get_authenticate_profile_path } from '../utils/routes'
import { makeRequest } from "../utils/request";
import { removeTokenCookie } from '../helpers/auth-helper';
import { useNotificationStore } from './notification'

export const useUserStore = defineStore('user', {
  state: () => {
    return {
      profile: {
        first_name: "",
        last_name: "",
        birth_date: "",
        description: "",
        avatar: "",
      },
      user: {
        username: "",      
        email: "",
      },
      utils:{
        isAuth: false,
        isLoaded: false,
      }
    }
  },
  actions: {
    async getAuthenticateUser(){
      const response = await makeRequest(api_v1_get_authenticate_profile_path(), {method: "get"})

      if(!response.ok){
        this.$reset()
        return false
      }

      this.storeUser((await response.json()).data)
    },
    storeUser(data){
      const { profile, user } = data;

      this.profile = profile
      this.user = user

      this.utils.isAuth = true
      this.utils.isLoaded = true
    },
    logoutUser(){
      removeTokenCookie()
      this.$reset()
      
      const notifications = useNotificationStore()
      notifications.createNotification("User successfully logged out", "success")
    }
  },
})