<script setup lang="ts">
import { ref } from 'vue';
import Header from '@/components/header/Header.vue';
import Icon from '@/components/shares/Icon.vue';
import BooksManager from '@/components/admin/books/BooksManager.vue';
import UsersManager from '@/components/admin/users/UsersManager.vue';
import OrdersManager from '@/components/admin/orders/OrdersManager.vue';

interface Tab {
  name: string,
  icon: string,
  tag: string,
}

const tabsLink: Tab[] = [
  {"name": "Orders", "icon": "cart", "tag": "admin-orders"},
  {"name": "Users", "icon": "profile", "tag": "admin-users"},
  {"name": "Books", "icon": "book", "tag": "admin-books"},
]

const currentTab = ref(tabsLink[0])

</script>

<template>
  <div>
    <Header />
    <div class="flex space-x-2 py-10 max-w-screen-2xl px-10 md:mx-auto" >
      <div class="flex flex-col bg-white w-2/6 rounded-md">
        <ul>
          <li :class="{'bg-violet-100': currentTab.tag === tab.tag}" class="flex text-xl font-bold p-5 hover:bg-violet-100 rounded-md" v-for="tab in tabsLink" :key="tab.tag" @click="currentTab = tab">
            <Icon :name="tab.icon" class="flex items-center w-6 mr-3 mt-1" />
            {{tab.name}}
          </li>
        </ul>
      </div>
      <div class="relative w-4/6 bg-white rounded-md">
        <OrdersManager v-if="currentTab.tag === 'admin-orders'"/>
        <UsersManager v-if="currentTab.tag === 'admin-users'"/>
        <BooksManager v-if="currentTab.tag === 'admin-books'"/>
      </div>
    </div>
  </div>
</template>
