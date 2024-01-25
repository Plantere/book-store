import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'
import { hasTokenCookie } from "../helpers/auth-helper";


const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../pages/Home.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../pages/Login.vue'),
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  const user = useUserStore();

  if(hasTokenCookie() === true && !user.utils.isLoaded){
    await user.getAuthenticateUser()
  }else if(hasTokenCookie() === false && user.utils.isAuthenticated){
    user.$reset()
  }

  if(to.name === "login" && user.utils.isAuthenticated){
    next({name: "home"})
    return
  }
  
  next()
})

export default router
