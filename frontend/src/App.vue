<template>
  <div class="h-screen w-screen overflow-hidden flex bg-white">
    <!-- Desktop Sidebar (Hidden on Mobile) -->
    <aside class="hidden md:flex h-full border-r border-gray-200 bg-gray-50/70 shrink-0">
      <Sidebar />
    </aside>

    <!-- Main Content Area -->
    <main class="flex-1 flex flex-col h-full overflow-hidden min-w-0">
      <Navbar />
      <div class="flex-1 overflow-y-auto overflow-x-hidden pb-20 md:pb-0">
        <router-view />
      </div>
    </main>

    <!-- Mobile Bottom Navigation & Slide-Over Drawer -->
    <MobileNav />
  </div>
  <Toasts />
</template>

<script setup>
import Sidebar from '@/components/Sidebar.vue'
import Navbar from '@/components/Navbar.vue'
import MobileNav from '@/components/MobileNav.vue'
import { RouterView } from 'vue-router'
import { Toasts } from 'frappe-ui'
</script>
