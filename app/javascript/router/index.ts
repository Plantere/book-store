import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'
import { hasTokenCookie } from "../helpers/auth-helper";

const checkAuthentication = async () => {
  const user = useUserStore();
  if (hasTokenCookie() && !user.utils.isLoaded) {
    await user.getAuthenticateUser();
  } else if (!hasTokenCookie() && user.utils.isAuth) {
    user.$reset();
  }
};


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
      meta: {
        requiresAuth: false,
      },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../pages/Register.vue'),
      meta: {
        requiresAuth: false,
      },
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  await checkAuthentication();

  const user = useUserStore();

  if (to.meta.requiresAuth && user.utils.isAuth) {
    next({ name: 'home' });
  } else {
    next();
  }
})

export default router
