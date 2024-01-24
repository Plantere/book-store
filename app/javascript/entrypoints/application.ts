import '../assets/style.css'


import { createApp } from 'vue'
import { createPinia } from 'pinia'

import router from '../router'
import App from '../components/App.vue'

const app = createApp(App)
app.use(createPinia())
app.use(router)

app.mount('#app')
