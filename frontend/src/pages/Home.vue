<template>
  <div class="p-5 md:p-8 max-w-7xl mx-auto space-y-8 bg-gray-50/50 min-h-full">
    <!-- Hero / Welcome Banner -->
    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-indigo-900 via-indigo-800 to-blue-900 text-white p-6 md:p-8 shadow-lg">
      <div class="absolute -right-10 -bottom-10 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute right-20 top-0 w-48 h-48 bg-blue-400/10 rounded-full blur-2xl pointer-events-none"></div>
      
      <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div class="space-y-2">
          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 backdrop-blur-sm text-xs font-medium text-indigo-200 border border-white/10">
            <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            Portal Mahasiswa Aktif
          </div>
          <h1 class="text-2xl md:text-3xl font-bold tracking-tight text-white">
            {{ timeGreeting }}, {{ displayName }}! 👋
          </h1>
          <p class="text-sm md:text-base text-indigo-200/90 max-w-xl">
            Selamat datang di portal akademik Anda. Pantau perkembangan studi, jadwal kuliah harian, absensi, dan administrasi perkuliahan di satu tempat.
          </p>
          <div class="flex flex-wrap items-center gap-3 pt-2 text-xs md:text-sm text-indigo-100">
            <span class="inline-flex items-center gap-1.5 bg-black/20 px-3 py-1 rounded-lg">
              <span class="font-semibold text-indigo-300">ID Siswa:</span> {{ studentId || 'N/A' }}
            </span>
            <span class="inline-flex items-center gap-1.5 bg-black/20 px-3 py-1 rounded-lg">
              <span class="font-semibold text-indigo-300">Program:</span> {{ activeProgramName || 'Program Reguler' }}
            </span>
            <span v-if="academicYear" class="inline-flex items-center gap-1.5 bg-black/20 px-3 py-1 rounded-lg">
              <span class="font-semibold text-indigo-300">Tahun:</span> {{ academicYear }}
            </span>
          </div>
        </div>

        <div class="flex flex-col sm:flex-row md:flex-col gap-2 shrink-0 w-full sm:w-auto">
          <button 
            @click="navigateTo('/schedule')"
            class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-white text-indigo-900 font-semibold text-sm hover:bg-indigo-50 active:scale-95 transition-all shadow-md"
          >
            <Calendar class="w-4 h-4 text-indigo-600" />
            Jadwal Kuliah
          </button>
          <button 
            @click="navigateTo('/attendance')"
            class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-white/15 text-white font-medium text-sm hover:bg-white/20 active:scale-95 transition-all border border-white/10 backdrop-blur-sm"
          >
            <UserCheck class="w-4 h-4 text-indigo-200" />
            Presensi & Izin
          </button>
        </div>
      </div>
    </div>

    <!-- Academic KPI Bento Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <!-- Card 1: Today Classes -->
      <div 
        @click="navigateTo('/schedule')"
        class="group bg-white p-5 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md hover:border-indigo-200 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div class="flex items-center justify-between mb-3">
          <span class="text-xs font-semibold uppercase tracking-wider text-gray-500">Jadwal Kuliah</span>
          <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all">
            <CalendarCheck class="w-5 h-5" />
          </div>
        </div>
        <div>
          <div class="text-2xl font-bold text-gray-900 mb-1">
            {{ todayEvents.length }} Kelas
          </div>
          <p class="text-xs text-gray-500">
            {{ todayEvents.length > 0 ? 'Ada kelas terjadwal hari ini' : 'Tidak ada kelas hari ini' }}
          </p>
        </div>
        <div class="mt-4 pt-3 border-t border-gray-50 flex items-center justify-between text-xs font-medium text-blue-600">
          <span>Lihat Kalender</span>
          <ArrowRight class="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

      <!-- Card 2: Attendance -->
      <div 
        @click="navigateTo('/attendance')"
        class="group bg-white p-5 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md hover:border-indigo-200 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div class="flex items-center justify-between mb-3">
          <span class="text-xs font-semibold uppercase tracking-wider text-gray-500">Presensi</span>
          <div class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center group-hover:bg-emerald-600 group-hover:text-white transition-all">
            <UserCheck class="w-5 h-5" />
          </div>
        </div>
        <div>
          <div class="text-2xl font-bold text-gray-900 mb-1">
            100%
          </div>
          <p class="text-xs text-emerald-600 font-medium flex items-center gap-1">
            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
            Status Kehadiran Baik
          </p>
        </div>
        <div class="mt-4 pt-3 border-t border-gray-50 flex items-center justify-between text-xs font-medium text-emerald-600">
          <span>Rekap Absensi</span>
          <ArrowRight class="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

      <!-- Card 3: Academic Grades -->
      <div 
        @click="navigateTo('/grades')"
        class="group bg-white p-5 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md hover:border-indigo-200 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div class="flex items-center justify-between mb-3">
          <span class="text-xs font-semibold uppercase tracking-wider text-gray-500">Hasil Studi</span>
          <div class="w-10 h-10 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center group-hover:bg-purple-600 group-hover:text-white transition-all">
            <GraduationCap class="w-5 h-5" />
          </div>
        </div>
        <div>
          <div class="text-2xl font-bold text-gray-900 mb-1">
            Transkrip
          </div>
          <p class="text-xs text-gray-500">
            Penilaian & Indeks Prestasi
          </p>
        </div>
        <div class="mt-4 pt-3 border-t border-gray-50 flex items-center justify-between text-xs font-medium text-purple-600">
          <span>Buka Nilai (KHS)</span>
          <ArrowRight class="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

      <!-- Card 4: Tuition & Fees -->
      <div 
        @click="navigateTo('/fees')"
        class="group bg-white p-5 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md hover:border-indigo-200 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div class="flex items-center justify-between mb-3">
          <span class="text-xs font-semibold uppercase tracking-wider text-gray-500">Keuangan</span>
          <div class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center group-hover:bg-amber-600 group-hover:text-white transition-all">
            <Banknote class="w-5 h-5" />
          </div>
        </div>
        <div>
          <div class="text-2xl font-bold text-gray-900 mb-1">
            SPP & Tagihan
          </div>
          <p class="text-xs text-gray-500">
            Cek riwayat & status invoice
          </p>
        </div>
        <div class="mt-4 pt-3 border-t border-gray-50 flex items-center justify-between text-xs font-medium text-amber-600">
          <span>Lihat Tagihan</span>
          <ArrowRight class="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>
    </div>

    <!-- Main Content: Today's Schedule & Academic Notices -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Left Column: Upcoming Classes (2 cols) -->
      <div class="lg:col-span-2 bg-white rounded-2xl border border-gray-100 p-6 shadow-sm flex flex-col">
        <div class="flex items-center justify-between mb-5">
          <div class="flex items-center gap-2.5">
            <div class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center">
              <Clock class="w-4 h-4" />
            </div>
            <div>
              <h2 class="text-base font-semibold text-gray-900">Jadwal Sesi Kuliah Terdekat</h2>
              <p class="text-xs text-gray-500">Daftar kelas yang terjadwal untuk Anda</p>
            </div>
          </div>
          <button 
            @click="navigateTo('/schedule')"
            class="text-xs font-medium text-indigo-600 hover:text-indigo-800 flex items-center gap-1"
          >
            Lihat Semua
            <ArrowRight class="w-3 h-3" />
          </button>
        </div>

        <!-- Class List or Empty State -->
        <div v-if="upcomingEvents.length > 0" class="space-y-3 flex-1">
          <div 
            v-for="item in upcomingEvents" 
            :key="item.name"
            class="p-4 rounded-xl border border-gray-100 hover:border-indigo-100 bg-gray-50/60 hover:bg-indigo-50/20 transition-all flex flex-col sm:flex-row sm:items-center justify-between gap-3"
          >
            <div class="space-y-1">
              <div class="inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[11px] font-semibold bg-indigo-100 text-indigo-800">
                {{ item.course || item.title || 'Mata Kuliah' }}
              </div>
              <h4 class="text-sm font-semibold text-gray-900">{{ item.title }}</h4>
              <div class="flex items-center gap-4 text-xs text-gray-500">
                <span v-if="item.with" class="flex items-center gap-1">
                  <User class="w-3.5 h-3.5" /> {{ item.with }}
                </span>
                <span v-if="item.room" class="flex items-center gap-1">
                  <MapPin class="w-3.5 h-3.5" /> Ruang: {{ item.room }}
                </span>
              </div>
            </div>
            <div class="sm:text-right shrink-0">
              <div class="text-xs font-semibold text-indigo-900 bg-white px-3 py-1.5 rounded-lg border border-gray-200/80 shadow-xs inline-block">
                {{ item.date }} • {{ item.from_time }} - {{ item.to_time }}
              </div>
            </div>
          </div>
        </div>

        <div v-else class="flex-1 flex flex-col items-center justify-center py-10 text-center">
          <div class="w-14 h-14 rounded-2xl bg-gray-50 border border-gray-100 flex items-center justify-center text-gray-400 mb-3">
            <Calendar class="w-7 h-7" />
          </div>
          <p class="text-sm font-semibold text-gray-700">Belum Ada Sesi Kuliah Terdekat</p>
          <p class="text-xs text-gray-500 max-w-xs mt-1">
            Jadwal kuliah akan tampil di sini begitu semester perkuliahan dimulai atau jadwal diinput oleh dosen.
          </p>
          <button 
            @click="navigateTo('/schedule')"
            class="mt-4 px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-xs font-medium text-gray-800 transition"
          >
            Buka Kalender Lengkap
          </button>
        </div>
      </div>

      <!-- Right Column: Academic Bulletin / Notices (1 col) -->
      <div class="bg-white rounded-2xl border border-gray-100 p-6 shadow-sm flex flex-col">
        <div class="flex items-center gap-2.5 mb-5">
          <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center">
            <Bell class="w-4 h-4" />
          </div>
          <div>
            <h2 class="text-base font-semibold text-gray-900">Pengumuman Kampus</h2>
            <p class="text-xs text-gray-500">Informasi & agenda penting</p>
          </div>
        </div>

        <div class="space-y-3.5 flex-1">
          <!-- Notice 1 -->
          <div class="p-3.5 rounded-xl border border-blue-100/80 bg-blue-50/40 space-y-1">
            <div class="flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-blue-100 text-blue-800">
                Penting
              </span>
              <span class="text-[11px] text-gray-400">Baru</span>
            </div>
            <h4 class="text-xs font-bold text-gray-900">Registrasi Kartu Rencana Studi (KRS)</h4>
            <p class="text-xs text-gray-600 leading-relaxed">
              Pastikan verifikasi mata kuliah untuk semester aktif telah disetujui oleh Dosen Pembimbing Akademik.
            </p>
          </div>

          <!-- Notice 2 -->
          <div class="p-3.5 rounded-xl border border-emerald-100/80 bg-emerald-50/40 space-y-1">
            <div class="flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-emerald-100 text-emerald-800">
                Akademik
              </span>
              <span class="text-[11px] text-gray-400">Info</span>
            </div>
            <h4 class="text-xs font-bold text-gray-900">Kebijakan Presensi & Izin</h4>
            <p class="text-xs text-gray-600 leading-relaxed">
              Batas minimum kehadiran untuk mengikuti Ujian Akhir Semester adalah 75%. Ajukan izin lewat menu Presensi jika berhalangan.
            </p>
          </div>

          <!-- Notice 3 -->
          <div class="p-3.5 rounded-xl border border-purple-100/80 bg-purple-50/40 space-y-1">
            <div class="flex items-center justify-between">
              <span class="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-purple-100 text-purple-800">
                Layanan
              </span>
              <span class="text-[11px] text-gray-400">Bantuan</span>
            </div>
            <h4 class="text-xs font-bold text-gray-900">Pusat Layanan Mahasiswa</h4>
            <p class="text-xs text-gray-600 leading-relaxed">
              Butuh konsultasi atau perbaikan data identitas? Hubungi helpdesk akademik via email atau kantor bagian tata usaha.
            </p>
          </div>
        </div>

        <div class="mt-4 pt-3 border-t border-gray-100 text-center">
          <p class="text-[11px] text-gray-400">
            Frappe Education Portal • Versi 16
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { studentStore } from '@/stores/student'
import { usersStore } from '@/stores/user'
import { createResource } from 'frappe-ui'
import {
  Calendar,
  CalendarCheck,
  GraduationCap,
  Banknote,
  UserCheck,
  Clock,
  ArrowRight,
  Bell,
  User,
  MapPin,
} from 'lucide-vue-next'

const router = useRouter()
const store = studentStore()
const { studentInfo, currentProgram, studentGroups } = storeToRefs(store)
const { user } = usersStore()

const events = ref([])

const scheduleResource = createResource({
  url: 'education.education.api.get_course_schedule_for_student',
  makeParams() {
    return {
      program_name: currentProgram.value?.program,
      student_groups: studentGroups.value || [],
    }
  },
  onSuccess: (response) => {
    if (!Array.isArray(response)) return
    events.value = response.map((item) => ({
      title: item.title,
      with: item.instructor,
      name: item.name,
      room: item.room,
      date: item.schedule_date,
      from_time: item.from_time ? item.from_time.split('.')[0] : '',
      to_time: item.to_time ? item.to_time.split('.')[0] : '',
      color: item.class_schedule_color,
      course: item.course,
    }))
  },
})

watch(
  [currentProgram, studentGroups],
  () => {
    if (currentProgram.value?.program && studentGroups.value?.length) {
      scheduleResource.reload()
    } else {
      events.value = []
    }
  },
  { deep: true, immediate: true }
)

const displayName = computed(() => {
  return studentInfo.value?.student_name || user.data?.full_name || 'Mahasiswa'
})

const studentId = computed(() => {
  return studentInfo.value?.name || ''
})

const activeProgramName = computed(() => {
  return currentProgram.value?.program || 'Reguler'
})

const academicYear = computed(() => {
  return currentProgram.value?.academic_year || ''
})

const timeGreeting = computed(() => {
  const hour = new Date().getHours()
  if (hour >= 4 && hour < 11) return 'Selamat Pagi'
  if (hour >= 11 && hour < 15) return 'Selamat Siang'
  if (hour >= 15 && hour < 18) return 'Selamat Sore'
  return 'Selamat Malam'
})

const todayEvents = computed(() => {
  const todayStr = new Date().toISOString().split('T')[0]
  return events.value.filter((e) => e.date === todayStr)
})

const upcomingEvents = computed(() => {
  return events.value.slice(0, 5)
})

function navigateTo(path) {
  router.push(path)
}
</script>
