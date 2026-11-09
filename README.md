# 🔬 LENSA — Layar Edukasi Nalar Sains Anak

**LENSA** adalah aplikasi pembelajaran interaktif berbasis web/mobile untuk siswa **Kelas 5 SD** dengan materi utama **6 Sifat Cahaya** (Kurikulum Merdeka) dan evaluasi bertingkat berbasis **Taksonomi Bloom (C1–C5)**.

![Overview UI/UX LENSA](redesign/overview.png)

## ✨ Fitur Utama
- **Materi 6 Sifat Cahaya + Ilustrasi Visual Interaktif**:
  1. Cahaya Merambat Lurus
  2. Cahaya Menembus Benda Bening
  3. Cahaya Dapat Dipantulkan
  4. Cahaya Dapat Dibiaskan
  5. Cahaya Dapat Diuraikan (Dispersi/Pelangi)
  6. Cahaya Membentuk Bayangan
- **Kuis & Evaluasi Berjenjang (Taksonomi Bloom C1–C5)**: 25 soal pilihan ganda dengan pembahasan langsung, efek suara edukatif (Web Audio API), dan selebrasi konfeti.
- **Rekap & Progres Siswa**: Halaman hasil belajar dengan bintang apresiasi dan lencana penguasaan C1–C5.
- **Dashboard Guru**: Rekapitulasi nilai siswa secara otomatis (`localStorage`) dan fitur **Unduh CSV**.

## 📁 Struktur Proyek
```text
lensa/
├── index.html                        # Landing page informasi aplikasi LENSA
├── app.html                          # Aplikasi utama LENSA (Siswa & Guru)
├── assets/                           # Aset SVG (logo & ilustrasi hero)
├── redesign/                         # Dokumentasi & aset UI/UX Redesign (Tahap 1–7)
│   ├── lensa-redesign.figcraft       # File desain & prototype FigCraft (.figcraft)
│   ├── prototype.html                # Prototype interaktif & perbandingan Before/After
│   ├── app-before.html               # Cadangan versi sebelum redesign
│   ├── overview.png                  # Preview 8 layar utama Hi-Fi
│   ├── REDESIGN-TAHAP-1-5.md         # Dokumentasi Audit, Design Direction, Wireframe, Hi-Fi, Prototype
│   └── REDESIGN-TAHAP-6-7-FINAL.md   # Dokumentasi Implementasi & Final Review
├── server.js                         # Server lokal opsional (Node.js)
└── server.ps1                        # Server lokal opsional (PowerShell)
```

## 🚀 Cara Menjalankan
1. **Langsung di Browser**: Buka `index.html` atau `app.html` menggunakan browser modern (Chrome, Edge, Firefox, Safari).
2. **Menggunakan GitHub Pages**: Aktifkan *GitHub Pages* pada branch `main` (root `/`) agar aplikasi dapat diakses secara online.

