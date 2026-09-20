<template>
  <div>
    <!-- Bottom Navigation Bar (Visible only on mobile screens < md) -->
    <nav class="md:hidden fixed bottom-0 left-0 right-0 z-40 bg-white/95 backdrop-blur-lg border-t border-gray-200/90 px-2 py-1.5 shadow-lg safe-bottom">
      <div class="flex items-center justify-around">
        <button
          v-for="item in navItems"
          :key="item.to"
          @click="navigate(item.to)"
          class="flex flex-col items-center justify-center flex-1 py-1 px-1 rounded-xl transition-all duration-200 active:scale-90"
          :class="isActive(item.to) ? 'text-indigo-600 font-semibold' : 'text-gray-500 hover:text-gray-700'"
        >
          <div class="relative">
            <component 
              :is="item.icon" 
              class="w-5 h-5 transition-transform"
              :class="isActive(item.to) ? 'scale-110 text-indigo-600 stroke-[2.2]' : 'text-gray-500 stroke-[1.8]'" 
            />
            <span 
              v-if="isActive(item.to)" 
              class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-1 h-1 rounded-full bg-indigo-600"
            ></span>
          </div>
          <span class="text-[10px] mt-1 tracking-tight leading-none">{{ item.label }}</span>
        </button>

        <!-- More / Menu Button for Drawer -->
        <button
          @click="drawerOpen = true"
          class="flex flex-col items-center justify-center flex-1 py-1 px-1 rounded-xl transition-all duration-200 text-gray-500 hover:text-gray-700 active:scale-90"
        >
          <Menu class="w-5 h-5 stroke-[1.8]" />
          <span class="text-[10px] mt-1 tracking-tight leading-none">Menu</span>
        </button>
      </div>
    </nav>

    <!-- Mobile Slide-Over Drawer / Backdrop -->
    <transition
      enter-active-class="transition-opacity ease-linear duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity ease-linear duration-200"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div 
        v-if="drawerOpen" 
        class="md:hidden fixed inset-0 z-50 bg-black/50 backdrop-blur-xs"
        @click="drawerOpen = false"
      ></div>
    </transition>

    <!-- Drawer Panel -->
    <transition
      enter-active-class="transition ease-in-out duration-300 transform"
      enter-from-class="translate-x-full"
      enter-to-class="translate-x-0"
      leave-active-class="transition ease-in-out duration-300 transform"
      leave-from-class="translate-x-0"
      leave-to-class="translate-x-full"
    >
      <div 
        v-if="drawerOpen" 
        class="md:hidden fixed inset-y-0 right-0 z-50 w-4/5 max-w-xs bg-white shadow-2xl flex flex-col justify-between p-5 overflow-y-auto"
      >
        <div class="space-y-6">
          <!-- Drawer Header -->
          <div class="flex items-center justify-between pb-4 border-b border-gray-100">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center font-bold text-sm">
                {{ studentInitials }}
              </div>
              <div class="min-w-0">
                <h4 class="text-sm font-bold text-gray-900 truncate">{{ studentName }}</h4>
                <p class="text-xs text-gray-500 truncate">{{ studentId || 'Siswa' }}</p>
              </div>
            </div>
            <button 
              @click="drawerOpen = false"
              class="p-2 rounded-xl text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors"
            >
              <X class="w-5 h-5" />
            </button>
          </div>

          <!-- Navigation Links Inside Drawer -->
          <div class="space-y-1">
            <p class="text-[11px] font-bold uppercase tracking-wider text-gray-400 px-3 pb-1">Menu Utama</p>
            
            <button
              v-for="link in drawerLinks"
              :key="link.to"
              @click="handleDrawerNav(link.to)"
              class="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-colors"
              :class="isActive(link.to) ? 'bg-indigo-50 text-indigo-700 font-semibold' : 'text-gray-700 hover:bg-gray-50'"
            >
              <component :is="link.icon" class="w-4 h-4" />
              <span>{{ link.label }}</span>
            </button>
          </div>

          <!-- Program & Academic Info -->
          <div class="p-3.5 rounded-xl bg-gray-50 border border-gray-100 space-y-1.5 text-xs text-gray-600">
            <div class="font-semibold text-gray-800">Status Akademik</div>
            <div>Program: <span class="font-medium text-gray-900">{{ currentProgram?.program || 'Reguler' }}</span></div>
            <div v-if="currentProgram?.academic_year">Tahun: <span class="font-medium text-gray-900">{{ currentProgram.academic_year }}</span></div>
          </div>
        </div>

        <!-- Logout & Footer -->
        <div class="pt-4 border-t border-gray-100 space-y-3">
          <button
            @click="handleLogout"
            class="w-full flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-red-50 text-red-600 hover:bg-red-100 active:scale-95 font-medium text-sm transition-all"
          >
            <LogOut class="w-4 h-4" />
            <span>Keluar Akun</span>
          </button>
          <p class="text-center text-[11px] text-gray-400">
            Frappe Education Portal
          </p>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { studentStore } from '@/stores/student'
import { usersStore } from '@/stores/user'
import { sessionStore } from '@/stores/session'
import {
  LayoutDashboard,
  CalendarCheck,
  GraduationCap,
  Banknote,
  UserCheck,
  Menu,
  X,
  LogOut,
} from 'lucide-vue-next'

const router = useRouter()
const drawerOpen = ref(false)

const { studentInfo, currentProgram } = storeToRefs(studentStore())
const { user } = usersStore()
const { logout } = sessionStore()

const navItems = [
  { label: 'Beranda', to: '/', icon: LayoutDashboard },
  { label: 'Jadwal', to: '/schedule', icon: CalendarCheck },
  { label: 'Nilai', to: '/grades', icon: GraduationCap },
  { label: 'SPP', to: '/fees', icon: Banknote },
]

const drawerLinks = [
  { label: 'Dashboard', to: '/', icon: LayoutDashboard },
  { label: 'Jadwal Kuliah', to: '/schedule', icon: CalendarCheck },
  { label: 'Presensi & Izin', to: '/attendance', icon: UserCheck },
  { label: 'Hasil Studi / Nilai', to: '/grades', icon: GraduationCap },
  { label: 'Biaya & SPP', to: '/fees', icon: Banknote },
]

function isActive(path) {
  return router.currentRoute.value.path === path
}

function navigate(path) {
  router.push(path)
}

function handleDrawerNav(path) {
  drawerOpen.value = false
  router.push(path)
}

function handleLogout() {
  drawerOpen.value = false
  logout.submit()
}

const studentName = computed(() => {
  return studentInfo.value?.student_name || user.data?.full_name || 'Mahasiswa'
})

const studentId = computed(() => {
  return studentInfo.value?.name || ''
})

const studentInitials = computed(() => {
  const name = studentName.value || 'M'
  return name.split(' ').map((p) => p[0]).slice(0, 2).join('').toUpperCase()
})
</script>

<style scoped>
.safe-bottom {
  padding-bottom: max(0.5rem, env(safe-area-inset-bottom));
}
</style>
