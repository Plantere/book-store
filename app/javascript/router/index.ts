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
        onlyGuest: true,
      },
    },
    {
      path: '/profile',
      name: 'profile',
      component: () => import('../pages/Profile.vue'),
      meta: {
        onlyAuthenticateUser: true,
      },
    },
    {
      path: '/cart',
      name: 'cart',
      component: () => import('../pages/Cart.vue'),
      meta: {
        onlyGuest: false,
      },
    },
    {
      path: '/book/:book_id',
      name: 'show-book',
      component: () => import('../pages/ShowBook.vue'),
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../pages/Register.vue'),
      meta: {
        onlyGuest: true,
      },
    },
    {
      path: '/admin',
      name: 'admin-page',
      component: () => import('../pages/Admin.vue'),
      meta: {
        onlyAdmin: true,
      },
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  await checkAuthentication();

  const user = useUserStore();

  if (to.meta.onlyGuest && user.utils.isAuth) {
    next({ name: 'home' });
    return
  }

  if(to.meta.onlyAuthenticateUser && !user.utils.isAuth){
    next({ name: 'login' });
    return
  }

  if(to.meta.onlyAdmin && user.user.type_user !== 2){
    next({ name: 'home' });
    return
  }

  next();
})

export default router
