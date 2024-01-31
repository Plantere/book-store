<script setup lang="ts">
import { ref } from 'vue';
import Header from '../components/header/Header.vue';
import Orders from '../components/orders/Orders.vue';
import Profile from '../components/profile/Profile.vue';
import Address from '../components/address/Address.vue';
import Icon from '../components/shares/Icon.vue';

const tabsLink = [
  {"name": "Orders", "icon": "cart", "tag": "orders-profile"},
  {"name": "Profile", "icon": "profile", "tag": "profile"},
  {"name": "Address", "icon": "map", "tag": "address-profile"},
]

const currentTab = ref(tabsLink[0])
const selectTab = (tab) => {
  currentTab.value = tab
}

</script>

<template>
  <div>
    <Header />
      <div class="flex space-x-2 py-10 max-w-screen-xl md:mx-auto" >
        <div class="flex flex-col bg-white w-2/6 rounded-md">
          <ul>
            <li :class="{'bg-violet-100': currentTab.tag === tab.tag}" class="flex text-xl font-bold p-5 hover:bg-violet-100 rounded-md" v-for="tab in tabsLink" :key="tab.tag" @click="selectTab(tab)">
              <Icon :name="tab.icon" class="flex items-center w-5 mr-3 mt-1" />
              {{tab.name}}
            </li>
          </ul>
        </div>

        <div class="relative w-4/6 bg-white rounded-md">
          <Orders v-if="currentTab.tag == 'orders-profile'"/>
          <Profile v-if="currentTab.tag == 'profile'"/>
          <Address v-if="currentTab.tag == 'address-profile'"/>
        </div>
      </div>
  </div>

</template>

<style>
</style>
