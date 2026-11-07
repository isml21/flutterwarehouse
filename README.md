
```markdown
# MyWarehouse — Warehouse Inventory & QR Tracking System
### Proyek Ujian Tengah Semester (UTS) Mata Kuliah Mobile Testing
**Fakultas Ilmu Komputer • Universitas Duta Bangsa Surakarta**  
**Program Studi:** S1 Teknik Informatika | **Kelas:** TI23B  
**Dosen Pengampu:** Triyono M.Kom  
**Tahun Akademik:** Ganjil 2026/2027  

---

## 📌 Identitas Proyek & Anggota Tim

| No | Nama Mahasiswa | NIM | Kelas | Peran / Kontribusi |
|:---:|---|:---:|:---:|---|
| 1 | **Ismail Fikrun Amin** | *(Isi NIM Anda)* | TI23B | **Lead QA & Full-Stack Flutter Developer**<br>• Arsitektur aplikasi & state management Riverpod<br>• Implementasi fitur Hapus Box, Glassmorphism UI, dan Supabase Backend |
| 2 | *(Nama Anggota 2)* | *(NIM)* | TI23B | **Automate Testing Engineer**<br>• Penulisan skrip otomasi pengujian Maestro YAML (Flow 01 s/d 06)<br>• Eksekusi pengujian regresi dan verifikasi assertion |
| 3 | *(Nama Anggota 3)* | *(NIM)* | TI23B | **UAT Coordinator & Documentation**<br>• Penyusunan dokumen User Acceptance Testing (10 Skenario UAT)<br>• Dokumentasi laporan temuan bug dan video penjelasan pengujian |

---

## 🔗 Tautan Pengumpulan Proyek (Output Wajib)

- 📹 **Tautan Video Penjelasan Pengujian (Durasi 5–10 Menit):**  
  👉 **`[ISI TAUTAN YOUTUBE / GOOGLE DRIVE ANDA DI SINI]`**  
  *(Mencakup perkenalan anggota/NIM/peran, demonstrasi fitur aplikasi, penjelasan skenario UAT, dan live demo eksekusi otomasi Maestro).*
- 🐙 **Tautan Repository Git (GitHub / GitLab):**  
  👉 **`https://github.com/isml21/flutterwarehouse.git`**
- 📄 **Dokumen Laporan UAT (Markdown / PDF):**  
  👉 [`LAPORAN_UAT.md`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/LAPORAN_UAT.md) dan spreadsheet [`UAT.UDB Warehouse.xlsx`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/UAT.UDB%20Warehouse.xlsx)
- 📁 **Berkas Otomasi Pengujian Maestro:**  
  👉 Direktori [`maestro/`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro)

---

## 📖 1. Gambaran Umum Aplikasi

### 1.1 Tujuan Aplikasi
**MyWarehouse** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memodernisasi tata kelola pergudangan inventaris kardus dan wadah industri (*box management system*). Sistem ini mengintegrasikan basis data *cloud* PostgreSQL Supabase secara realtime dengan teknologi pemindaian QR Code kamera untuk memangkas waktu pencatatan stok fisik, mencegah *human error*, serta mengeliminasi risiko stok minus (*over-withdrawal*).

### 1.2 Target Pengguna
1. **Petugas Gudang (*Warehouse Staff*)**: Bertanggung jawab melakukan transaksi harian penerimaan barang (*Stock IN*) dan pengeluaran barang (*Stock OUT*).
2. **Operator Scanner**: Petugas lapangan yang memverifikasi kode kardus fisik di rak gudang menggunakan kamera pemindai QR Code.
3. **Supervisor Inventaris (*Inventory Manager*)**: Bertanggung jawab memantau ketersediaan stok kritis/habis, mendaftarkan katalog box baru, dan menghapus item usang.

### 1.3 Fitur Utama Aplikasi
1. **Autentikasi Petugas Gudang**: Login aman berbasis Supabase Auth dengan validasi form ketat dan tombol praktis *"Isi Akun Demo Cepat"*.
2. **Katalog & Registrasi Box**: Pemantauan inventaris, indikator KPI (Total Jenis, Total Unit, Kritis, Habis), pencarian *real-time*, filter status stok, auto-generate kode box acak, perhitungan volume liter otomatis, dan pembuatan QR Code identitas fisik.
3. **Transaksi Stok Realtime (IN/OUT)**: Penambahan kuantitas barang masuk dan pengurangan barang keluar dengan validasi batas aman (*minus stock prevention*).
4. **Scanner QR Code Fisik**: Deteksi barcode instan menggunakan kamera perangkat, aktivasi lampu senter (*torch*), serta fitur fallback *Input Manual*.
5. **Fitur Hapus Box (Delete Item)**: Penghapusan box dengan dialog konfirmasi keamanan *glassmorphic* dan mekanisme *cascade delete* di database.
6. **Desain Modern Glassmorphism**: Tampilan visual mutakhir berbasis efek kaca akrilik (*frosted glass*) dengan *ambient luminous background* dan logo baru MyWarehouse.

### 1.4 Alur Pengguna (*User Flow*)

```

[Buka Aplikasi]
│
▼
[Layar Login] ──(Validasi Form / Kredensial Valid)──► [Katalog Box Gudang]
│
┌────────────────────────────────────────────────────┼──────────────────────────────────────────────────┐
▼                                                    ▼                                                  ▼
[Tambah Box Baru]                                    [Pilih Kartu Box]                                  [Scan QR Box]
• Kode acak unik                                     • Lihat Spesifikasi Dimensi                        • Sorot kamera ke QR
• Live volume preview                                • Quick Stock In/Out                               • Fallback manual
• Auto-generate QR Code                              • Hapus Item Box                                   • Buka Detail Box
│                                                    │                                                  │
└─────────────────────────────────┬──────────────────┴──────────────────────────────────────────────────┘
▼
[Sinkronisasi Database Supabase]
│
▼
[Pembaruan Realtime Katalog & KPI]

```

### 1.5 Batasan Pengujian (*Scope & Limitations*)
- **Cakupan Pengujian**:
  - Pengujian fungsionalitas aplikasi pada sistem operasi Android (emulator dan perangkat fisik).
  - Validasi form input (email, password, dimensi numerik, kuantitas stok).
  - Pengujian batas nilai (*boundary testing*) pada transaksi stok keluar dan dimensi box.
  - Pengujian alur User Acceptance Testing (UAT) manual oleh peran pengguna.
  - Otomasi pengujian E2E menggunakan Maestro CLI mencakup 6 skenario flow.
- **Di Luar Cakupan (*Out of Scope*)**:
  - Integrasi sistem pembayaran (*payment gateway* / kasir).
  - Fitur ekspor cetak langsung ke printer thermal Bluetooth.
  - Pelacakan armada truk logistik berbasis GPS antar-gudang.

---

## 🧪 2. Rangkuman Pengujian Automate Testing (Maestro CLI)

Pengujian otomatis dibangun menggunakan **Maestro**, mencakup **6 alur pengujian (*test flows*)** yang melebihi standar minimum yang diminta:

| Alur YAML | Skenario Pengujian | Cakupan & Validasi (*Assertion*) |
|---|---|---|
| [`01_auth_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/01_auth_flow.yaml) | **Autentikasi & Validasi Form** | Uji field kosong, format email salah, password < 6 karakter, fitur akun demo, dan login sukses. |
| [`02_box_registration_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/02_box_registration_flow.yaml) | **Registrasi Box & Hitung Volume** | Validasi dimensi `0` (boundary), auto-code acak, input box baru, hitung volume otomatis (24.00 L), dan dialog QR Code. |
| [`03_catalog_search_filter_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/03_catalog_search_filter_flow.yaml) | **Pencarian & Filter Status** | Pencarian realtime kata kunci kode/nama/rak, filter chip (*In Stock*, *Low Stock*, *Out of Stock*), dan clear query. |
| [`04_stock_transaction_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/04_stock_transaction_flow.yaml) | **Transaksi Stok IN & OUT** | Stock IN (+10 unit), pencegahan over-withdrawal stok minus, dan eksekusi Stock OUT valid. |
| [`05_qr_scanner_manual_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/05_qr_scanner_manual_flow.yaml) | **Scanner QR & Fallback Manual** | Membuka scanner kamera, verifikasi overlay, dan fallback pencarian manual kode/UUID pada emulator. |
| [`06_delete_box_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/06_delete_box_flow.yaml) | **Hapus Item Box (CRUD Delete)** | Membuka dialog konfirmasi kaca, uji tombol pembatalan, konfirmasi hapus permanen, dan verifikasi snackbar. |
| [`run_all.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/run_all.yaml) | **Master Test Suite E2E** | Menjalankan seluruh alur di atas secara sekuensial end-to-end. |

---

## 💻 3. Petunjuk Menjalankan Aplikasi & Pengujian

### 3.1 Prasyarat Lingkungan
- **Flutter SDK:** >= 3.13.4 (Dart >= 3.13.4)
- **Android Studio / Android SDK:** Platform API 34+
- **Node.js / Maestro CLI:** Untuk menjalankan automate testing

### 3.2 Menjalankan Aplikasi Flutter (Debug / Release)
```bash
# 1. Unduh seluruh dependensi Flutter
flutter pub get

# 2. Jalankan pada emulator atau perangkat fisik Android yang terhubung
flutter run

# 3. Atau build berkas APK siap pasang
flutter build apk --debug
# Hasil APK tersimpan di: build/app/outputs/flutter-apk/app-debug.apk

```

### 3.3 Menjalankan Pengujian Otomatis Maestro

Pastikan emulator Android aktif dan terdeteksi di ADB (`adb devices`):

```bash
# Menjalankan seluruh test suite sekaligus (Full End-to-End)
maestro test maestro/run_all.yaml

# Menjalankan 4 skenario inti:
maestro test maestro/01_auth_test.yaml
maestro test maestro/02_katalog_tambah_box_test.yaml
maestro test maestro/03_transaksi_stok_qr_test.yaml
maestro test maestro/04_hapus_box_test.yaml

```

### 3.4 Menjalankan Unit Testing

```bash
flutter test

```

---

## 🌿 4. Struktur Git Repository & Riwayat Pengembangan

Repositori ini dikelola menggunakan konvensi **GitFlow** dengan commit bertahap sejak awal pengembangan:

* **`main`**: Branch produksi dengan rilis versi terverifikasi (**Tag: `v1.1.0**`).
* **`develop`**: Branch integrasi pengembangan aktif.
* **`feat/auth-module`**: Pengembangan modul otentikasi Supabase.
* **`feat/box-catalog`**: Pengembangan modul katalog inventaris dan form registrasi box.
* **`feat/qr-scanner`**: Pengembangan scanner kamera dan modal transaksi stok.
* **`test/mobile-testing-maestro`**: Konfigurasi otomasi Maestro E2E dan laporan UAT.
* **`feat/delete-box-and-glassmorphism-ui`**: Fitur hapus box permanen, redesain visual Glassmorphism, dan logo MyWarehouse baru.

```

```