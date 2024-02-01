import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'

import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'

import svgLoader from 'vite-svg-loader';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue(),
    svgLoader()
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./app/javascript', import.meta.url))
    }
  }
})
