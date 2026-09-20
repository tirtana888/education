<template>
  <header
    class="flex justify-between gap-3 items-center px-4 md:px-6 h-14 border-b border-gray-200/80 bg-white shrink-0"
  >
    <div class="flex gap-2.5 sm:gap-3 items-center min-w-0">
      <!-- Mobile Logo Icon -->
      <div class="md:hidden w-8 h-8 rounded-lg bg-indigo-600 text-white flex items-center justify-center font-bold text-xs shadow-xs shrink-0">
        🎓
      </div>
      
      <h3 class="font-semibold text-base sm:text-lg text-gray-900 truncate">
        {{ currentRoute === 'Dashboard' ? 'Beranda' : currentRoute }}
      </h3>
      <div class="hidden sm:block">
        <ProgramSelector v-if="showProgramSelector" />
      </div>
    </div>

    <div class="flex items-center gap-2 shrink-0">
      <div class="sm:hidden" v-if="showProgramSelector">
        <ProgramSelector />
      </div>

      <div v-if="isStudent" class="flex items-center gap-2">
        <Button
          v-if="currentRoute === 'Attendance'"
          variant="solid"
          label="Izin"
          @click="setIsAttendancePage(true)"
          icon-left="plus"
          size="sm"
        />
      </div>

      <!-- Mobile Profile Avatar Badge -->
      <div class="md:hidden flex items-center pl-1">
        <div class="w-8 h-8 rounded-full bg-indigo-100 text-indigo-700 font-bold text-xs flex items-center justify-center border border-indigo-200">
          {{ userInitials }}
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { leaveStore } from '@/stores/leave'
import { portalStore } from '@/stores/portal'
import { studentStore } from '@/stores/student'
import { usersStore } from '@/stores/user'
import ProgramSelector from '@/components/ProgramSelector.vue'
import Button from 'frappe-ui/src/components/Button.vue'

const router = useRouter()
const currentRoute = computed(() => router.currentRoute.value.name)

const { setIsAttendancePage } = leaveStore()
const { isStudent, isGuardian, activeStudentId } = storeToRefs(portalStore())
const { programs } = storeToRefs(studentStore())
const { user } = usersStore()

const showProgramSelector = computed(() => {
  if (currentRoute.value === 'Students') return false
  if (isGuardian.value && !activeStudentId.value) return false
  return programs.value.length > 0
})

const userInitials = computed(() => {
  const name = user.data?.full_name || 'Budi'
  return name.split(' ').map((p) => p[0]).slice(0, 2).join('').toUpperCase()
})
</script>
