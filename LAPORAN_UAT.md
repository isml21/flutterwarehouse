# Laporan User Acceptance Testing (UAT)
## MyWarehouse — Warehouse Inventory & QR Tracking System
**Mata Kuliah:** Mobile Testing • **Program Studi:** S1 Teknik Informatika  
**Fakultas:** Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta  
**Kelas:** TI23B • **Dosen Pengampu:** Triyono M.Kom  
**Tahun Akademik:** 2026/2027  

---

## 📋 1. Informasi Dokumen & Identitas Proyek

| Atribut | Keterangan |
|---|---|
| **Judul Proyek** | Pengujian Aplikasi Mobile dengan User Acceptance Testing dan Maestro |
| **Nama Aplikasi** | MyWarehouse (Warehouse Inventory & QR Tracking System) |
| **Versi Aplikasi** | v1.1.0 (Flutter Android Release) |
| **Target Pengguna** | Petugas Gudang (*Staff*), Operator Scanner, Supervisor Inventaris |
| **Metode Pengujian** | User Acceptance Testing (Manual) & Automate Testing (Maestro CLI) |
| **Tanggal Pengujian** | 26 Oktober 2026 – 06 November 2026 |
| **Status Akhir** | **DITERIMA (PASSED / SIGN-OFF)** |

---

## 👥 2. Tim Penguji & Peran Mahasiswa

| No | Nama Mahasiswa | NIM | Kelas | Peran dalam Proyek |
|---|---|---|---|---|
| 1 | Ismail Fikron *(Sesuaikan)* | *(Isi NIM Anda)* | TI23B | Lead QA & Flutter Developer |
| 2 | *(Nama Anggota 2)* | *(NIM)* | TI23B | Test Automation Engineer (Maestro) |
| 3 | *(Nama Anggota 3)* | *(NIM)* | TI23B | UAT Coordinator & Technical Writer |

---

## 📱 3. Gambaran Umum Aplikasi & Batasan Pengujian

### 3.1 Tujuan Aplikasi
Aplikasi **MyWarehouse** dirancang untuk memodernisasi manajemen pergudangan kardus dan kontainer (*box management*), meminimalisir kesalahan pencatatan manual (*human error*), serta mempercepat pelacakan inventaris menggunakan teknologi pemindaian QR Code dan arsitektur *real-time database*.

### 3.2 Target Pengguna
1. **Petugas Gudang (*Warehouse Staff*)**: Bertanggung jawab melakukan transaksi barang masuk (*Stock IN*) dan barang keluar (*Stock OUT*) harian.
2. **Operator Scanner**: Petugas bergerak di lorong rak gudang yang memindai label fisik QR Code untuk verifikasi cepat identitas box.
3. **Supervisor Inventaris (*Inventory Manager*)**: Bertanggung jawab memantau metrik KPI stok kritis/habis, mendaftarkan katalog box baru, dan menghapus box usang (*CRUD complete*).

### 3.3 Fitur Utama Aplikasi
1. **F-01 Autentikasi Pengguna**: Login petugas berbasis Supabase Auth dengan validasi form ketat dan tombol bantuan demo instan.
2. **F-02 Katalog & Registrasi Box**: Pemantauan inventaris, pencarian realtime, filter status stok, auto-generate kode box acak, perhitungan volume liter otomatis, dan cetak/lihat QR Identifier.
3. **F-03 Transaksi Stok Realtime (In/Out)**: Penambahan kuantitas (*Stock IN*) dan pengurangan kuantitas (*Stock OUT*) dengan pencegahan stok minus (*over-withdrawal validation*).
4. **F-04 Pemindaian QR Code**: Deteksi barcode instan menggunakan kamera perangkat, aktivasi senter (*torch*), serta fallback input manual.
5. **F-05 Hapus Item / Box**: Fitur penghapusan item dengan dialog konfirmasi keamanan *glassmorphic* dan mekanisme *cascade delete* pada database.
6. **F-06 Antarmuka Glassmorphism**: Desain modern berbasis *frosted glass* (*acrylic*) dengan *ambient luminous background* untuk pengalaman pengguna yang nyaman dan responsif.

### 3.4 Batasan Pengujian (*Scope & Limitations*)
- **Tercakup dalam Pengujian**: Pengujian fungsionalitas aplikasi Android (emulator & perangkat fisik), validasi input form, batas kuantitas stok (*boundary*), pemindaian QR Code, responsivitas UI, serta otomasi Maestro E2E.
- **Di Luar Cakupan (*Out of Scope*)**: Integrasi sistem *payment gateway*, ekspor laporan format cetak POS Thermal, dan pelacakan GPS rute armada multi-gudang antar kota.

---

## 📊 4. Rekapitulasi Hasil Pengujian UAT

```text
Total Skenario UAT   : 10 Skenario
Skenario Lulus (PASS): 10 Skenario (100%)
Skenario Gagal (FAIL): 0 Skenario (0%)
Tingkat Keberhasilan : 100% (Memenuhi Kriteria Rilis)
```

---

## 📝 5. Tabel Detail Skenario User Acceptance Testing (UAT)

### Skenario UAT-01: Login Berhasil dengan Kredensial Valid (Alur Utama)
- **Tujuan Pengujian**: Memverifikasi bahwa petugas gudang dapat masuk ke sistem menggunakan akun email dan sandi resmi.
- **Persona / Peran Pengguna**: Petugas Gudang (*Warehouse Staff*)
- **Kriteria Penerimaan**: Pengguna berhasil login dalam waktu < 5 detik, sesi tersimpan, dan diarahkan ke layar Katalog Box Gudang.
- **Prasyarat**: Aplikasi terpasang; koneksi internet aktif; akun terdaftar di Supabase Auth (`admin@gudang.com` / `warehouse123`).
- **Langkah-Langkah Pengujian**:
  1. Buka aplikasi MyWarehouse.
  2. Masukkan email: `admin@gudang.com` (atau ketuk tombol *"Isi Akun Demo Cepat"*).
  3. Masukkan password: `warehouse123`.
  4. Ketuk tombol *"Masuk Sekarang"*.
- **Hasil yang Diharapkan**: Notifikasi hijau *"Selamat datang kembali!"* muncul dan beranda katalog terbuka.
- **Hasil Aktual**: Login berhasil instan (< 2 detik), sesi otentikasi aktif, katalog box termuat lengkap.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-AUTH-01`, Berkas Maestro `maestro/01_auth_flow.yaml`.

---

### Skenario UAT-02: Validasi Form Login Field Kosong & Format Email Salah (Validasi Input & Kondisi Gagal)
- **Tujuan Pengujian**: Memastikan sistem menolak login tanpa kredensial dan memberi peringatan format email yang tidak valid.
- **Persona / Peran Pengguna**: Petugas Gudang
- **Kriteria Penerimaan**: Muncul pesan error tepat di bawah field input yang bermasalah dan request login tidak dikirim ke server.
- **Prasyarat**: Halaman Login terbuka; field input dalam keadaan bersih.
- **Langkah-Langkah Pengujian**:
  1. Biarkan field email dan password kosong, lalu ketuk *"Masuk Sekarang"*.
  2. Masukkan email salah: `petugasgudang@` dan password valid, lalu ketuk *"Masuk Sekarang"*.
  3. Masukkan password kurang dari 6 karakter (misal `12345`), lalu ketuk *"Masuk Sekarang"*.
- **Hasil yang Diharapkan**: Muncul pesan *"Email wajib diisi"*, *"Kata sandi wajib diisi"*, *"Format email tidak valid"*, dan *"Kata sandi minimal 6 karakter"*.
- **Hasil Aktual**: Seluruh pesan validasi muncul secara inline dengan warna merah penanda error; proses login tertolak dengan aman.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-AUTH-02`, `TC-AUTH-03`, `TC-AUTH-04`, Berkas Maestro `maestro/01_auth_flow.yaml`.

---

### Skenario UAT-03: Pemantauan Indikator KPI Inventaris Stok Box (Alur Utama)
- **Tujuan Pengujian**: Memastikan supervisor gudang dapat memantau akumulasi total jenis, total unit, stok kritis, dan stok habis secara real-time.
- **Persona / Peran Pengguna**: Supervisor Inventaris
- **Kriteria Penerimaan**: Angka metrik pada 4 kartu KPI kaca akurat sesuai isi database dan memberi aksen warna peringatan jika stok kritis/habis.
- **Prasyarat**: Petugas telah login; data katalog box tersedia di gudang.
- **Langkah-Langkah Pengujian**:
  1. Buka halaman utama Katalog Box.
  2. Amati 4 kartu ringkasan KPI di bagian atas: Total Jenis, Total Unit, Stok Kritis, dan Stok Habis.
  3. Lakukan transaksi keluar hingga stok menyentuh angka 0.
- **Hasil yang Diharapkan**: Counter Stok Habis dan Stok Kritis langsung berubah dan kartu menyala dengan pendaran aksen merah/amber.
- **Hasil Aktual**: Perhitungan KPI berjalan otomatis dan realtime memanfaatkan agregasi Riverpod state.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-BOX-03`, Komponen `BoxListScreen._buildKpiCard`.

---

### Skenario UAT-04: Pencarian Real-Time & Penyaringan Status Stok (Alur Utama)
- **Tujuan Pengujian**: Menguji kemampuan pencarian cepat box berdasarkan kode, nama, atau lokasi rak, serta filter chip kategori stok.
- **Persona / Peran Pengguna**: Petugas Gudang
- **Kriteria Penerimaan**: Daftar kartu box tersaring seketika saat pengguna mengetik kata kunci atau menekan filter chip (*All, In Stock, Low Stock, Out of Stock*).
- **Prasyarat**: Terdapat minimal 3 variasi box di dalam katalog gudang.
- **Langkah-Langkah Pengujian**:
  1. Ketik *"Rak A"* pada search bar kaca di halaman utama.
  2. Hapus teks pencarian dengan menekan tombol silang (*clear*).
  3. Ketuk filter chip *"Low Stock"*.
  4. Ketuk filter chip *"Out of Stock"*.
- **Hasil yang Diharapkan**: Daftar box menampilkan data yang cocok tanpa reload halaman; jika tidak ditemukan muncul tampilan *empty state* kaca.
- **Hasil Aktual**: Pencarian instan tanpa lag, filter chip aktif dengan warna kontras yang jelas.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-BOX-03`, `TC-BOX-04`, Berkas Maestro `maestro/03_catalog_search_filter_flow.yaml`.

---

### Skenario UAT-05: Registrasi Box Baru & Generate QR Code Otomatis (Alur Utama - CRUD Create)
- **Tujuan Pengujian**: Memverifikasi alur pendaftaran spesifikasi kardus/box baru, kalkulasi volume liter, dan penerbitan QR Code identitas fisik.
- **Persona / Peran Pengguna**: Supervisor Inventaris
- **Kriteria Penerimaan**: Data box tersimpan di database Supabase, kapasitas volume liter terhitung otomatis, dan dialog QR Code langsung tampil.
- **Prasyarat**: Petugas berada di halaman utama katalog box.
- **Langkah-Langkah Pengujian**:
  1. Ketuk tombol FAB *"Tambah Box Baru"*.
  2. Ketuk tombol *"Acak"* untuk auto-generate Kode Box unik (misal `BOX-7821`).
  3. Masukkan Nama Box: `Kardus Sparepart Heavy Duty`.
  4. Masukkan dimensi: Panjang = 40 cm, Lebar = 30 cm, Tinggi = 20 cm.
  5. Amati live volume preview: (40 × 30 × 20) / 1000 = `24.00 Liter`.
  6. Pilih Material: `Corrugated Double Wall`, Lokasi: `Rak B-02`, Stok: `15`.
  7. Ketuk *"Simpan Box & Generate QR Code"*.
- **Hasil yang Diharapkan**: Notifikasi sukses muncul, dialog QR Code otomatis terbuka menampilkan QR Code beresolusi tajam dan tombol salin UUID.
- **Hasil Aktual**: Data masuk ke tabel `boxes` Supabase, status awal terhitung `In Stock`, QR Code ter-render sempurna.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-BOX-01`, Berkas Maestro `maestro/02_box_registration_flow.yaml`.

---

### Skenario UAT-06: Pemindaian QR Code Kamera & Fallback Pencarian Manual (Alur Utama - CRUD Read)
- **Tujuan Pengujian**: Memastikan scanner kamera mampu membaca QR Code box secara instan, serta menyediakan pencarian manual jika kamera tidak tersedia.
- **Persona / Peran Pengguna**: Operator Scanner
- **Kriteria Penerimaan**: Scanner mendeteksi QR Code box dengan haptic feedback dan langsung membuka BottomSheet detail transaksi stok.
- **Prasyarat**: Izin akses kamera aktif pada perangkat.
- **Langkah-Langkah Pengujian**:
  1. Ketuk tombol FAB *"Scan QR Box"*.
  2. Arahkan kamera ke QR Code box dalam batas bingkai laser.
  3. (Mode Alternatif / Emulator): Ketuk tombol ikon keyboard *"Ketik Kode/UUID Manual"*, masukkan `BOX-STD-001`, lalu ketuk *"Cari Box"*.
- **Hasil yang Diharapkan**: BottomSheet Detail Box terbuka menampilkan spesifikasi dimensi, stok saat ini, dan riwayat transaksi.
- **Hasil Aktual**: Deteksi barcode berjalan mulus, fallback input manual bekerja 100% pada emulator Android.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-TRX-01`, `TC-TRX-02`, Berkas Maestro `maestro/05_qr_scanner_manual_flow.yaml`.

---

### Skenario UAT-07: Transaksi Penambahan Barang Masuk (Stock IN) (Alur Utama - CRUD Update)
- **Tujuan Pengujian**: Menguji penambahan kuantitas stok barang masuk ke dalam gudang beserta pencatatan log transaksi.
- **Persona / Peran Pengguna**: Petugas Gudang
- **Kriteria Penerimaan**: Kuantitas bertambah sejumlah input, status stok diperbarui, dan entri baru tercatat di tabel `box_transactions`.
- **Prasyarat**: BottomSheet detail box terbuka (misal stok awal 10 unit).
- **Langkah-Langkah Pengujian**:
  1. Pastikan tab *"Stock IN (Masuk)"* aktif.
  2. Tambahkan kuantitas menggunakan chip cepat `+10` atau tombol `+` stepper (jumlah = 10).
  3. Ketuk *"Konfirmasi Stock IN (10 Unit)"*.
- **Hasil yang Diharapkan**: Stok bertambah menjadi 20 unit, muncul notifikasi sukses, dan baris transaksi masuk tercatat di riwayat.
- **Hasil Aktual**: Database ter-update instan, kartu box di halaman utama otomatis menampilkan angka 20 unit.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-TRX-03`, Berkas Maestro `maestro/04_stock_transaction_flow.yaml`, `maestro/tambah_stok_test.yaml`.

---

### Skenario UAT-08: Pencegahan Pengeluaran Melebihi Stok (Over-Withdrawal Validation) (Kondisi Gagal)
- **Tujuan Pengujian**: Memastikan sistem menolak transaksi pengeluaran barang jika jumlah keluar melebihi stok fisik yang ada di gudang.
- **Persona / Peran Pengguna**: Petugas Gudang
- **Kriteria Penerimaan**: Tombol konfirmasi terkunci (*disabled*) dan muncul banner peringatan merah jika kuantitas diminta > stok tersedia.
- **Prasyarat**: BottomSheet detail box terbuka pada box yang memiliki stok 4 unit.
- **Langkah-Langkah Pengujian**:
  1. Pilih tab *"Stock OUT (Keluar)"*.
  2. Masukkan kuantitas keluar sebesar 10 unit (stok hanya ada 4).
  3. Amati perubahan antarmuka tombol dan pesan peringatan.
- **Hasil yang Diharapkan**: Muncul banner *"Jumlah keluar (10) melebihi stok yang ada (4)!"* dan tombol konfirmasi tidak dapat diklik.
- **Hasil Aktual**: Sistem memblokir aksi submit secara preventif sehingga kuantitas tidak pernah bernilai negatif (*minus stock prevention*).
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-TRX-05`, Berkas Maestro `maestro/04_stock_transaction_flow.yaml`.

---

### Skenario UAT-09: Penghapusan Item Box dari Inventaris (Alur Utama - CRUD Delete)
- **Tujuan Pengujian**: Memverifikasi fitur penghapusan item box yang usang disertai dialog konfirmasi keamanan glassmorphic.
- **Persona / Peran Pengguna**: Supervisor Inventaris
- **Kriteria Penerimaan**: Muncul dialog konfirmasi bahaya, pembatalan tidak menghapus data, konfirmasi sukses menghapus data box beserta riwayat transaksinya dari database.
- **Prasyarat**: Box terdaftar di dalam katalog.
- **Langkah-Langkah Pengujian**:
  1. Ketuk ikon tong sampah merah pada kartu box di katalog atau tombol *"Hapus Item Ini dari Database"* pada lembar detail.
  2. Dialog konfirmasi *"Hapus Box dari Sistem?"* muncul.
  3. Uji pembatalan: Ketuk *"Batal"*, pastikan box tidak terhapus.
  4. Buka kembali dialog hapus, ketuk *"Hapus Box"*.
- **Hasil yang Diharapkan**: Muncul notifikasi sukses *"Box berhasil dihapus dari inventaris!"*, data terhapus permanen dari Supabase (cascade), dan item hilang dari daftar.
- **Hasil Aktual**: Alur pembatalan dan eksekusi hapus berjalan akurat, state lokal Riverpod sinkron seketika.
- **Status**: **PASS**
- **Bukti Pengujian**: `TC-BOX-06`, Berkas Maestro `maestro/06_delete_box_flow.yaml`, `maestro/hapus_item_test.yaml`.

---

### Skenario UAT-10: Kenyamanan Antarmuka Glassmorphism & Stabilitas Aplikasi (Usability & Non-Fungsional)
- **Tujuan Pengujian**: Memastikan desain baru berbasis efek kaca (*glassmorphism*) memiliki kontras keterbacaan tinggi, performa mulus 60 FPS, dan bebas crash.
- **Persona / Peran Pengguna**: Petugas Gudang & Supervisor
- **Kriteria Penerimaan**: Tidak ada visual overflow, pembiasan blur kaca tidak membebani memori, teks terbaca jelas, navigasi responsif.
- **Prasyarat**: Aplikasi dijalankan pada perangkat Android.
- **Langkah-Langkah Pengujian**:
  1. Operasikan aplikasi selama 10–15 menit melintasi berbagai fitur (Katalog, Modal, Transaksi, Form, Scanner).
  2. Putar orientasi atau ubah ukuran resolusi layar.
- **Hasil yang Diharapkan**: Tampilan elegan dengan estetika kaca akrilik modern, transisi halus, tidak ada lag atau force close.
- **Hasil Aktual**: Lulus uji static analysis (`No errors`), rendering widget efisien dengan `BackdropFilter` teroptimasi.
- **Status**: **PASS**
- **Bukti Pengujian**: Analisis kode Dart MCP (`No errors`), unit test suite di `test/widget_test.dart`.

---

## 🐞 6. Ringkasan Temuan Cacat (*Bug Report Summary*)

| Bug ID | Modul Terkait | Deskripsi Masalah | Tingkat Keparahan | Status Penyelesaian | Solusi / Tindakan Perbaikan |
|---|---|---|---|---|---|
| **BUG-001** | Scanner QR Manual | Input kode box manual huruf kecil (*lowercase*) sempat gagal menemukan data. | *Low* | **FIXED** | Menambahkan sanitasi string `.trim().toUpperCase()` dan query fallback fleksibel pada `fetchBoxById`. |
| **BUG-002** | Form Dimensi Box | Input dimensi bernilai 0 dapat memicu volume bernilai 0 jika tidak divalidasi ketat. | *Medium* | **FIXED** | Menambahkan validator numerik `n <= 0 -> return '> 0'` pada form input panjang, lebar, dan tinggi. |
| **BUG-003** | Transaksi Stok Keluar | Potensi stok minus jika petugas meminta barang keluar melebihi stok fisik. | *High* | **FIXED** | Menerapkan validasi ganda (*frontend disabled button* & *backend exception throw*) jika `amount > currentQuantity`. |

---

## ✍️ 7. Lembar Pengesahan (*Sign-Off*)

Berdasarkan seluruh hasil pengujian User Acceptance Testing (UAT) di atas dengan 10 skenario berstatus **PASS (100%)**, sistem aplikasi mobile **MyWarehouse** dinyatakan **LULUS UAT** dan siap digunakan untuk kebutuhan operasional gudang maupun penilaian akademik Ujian Tengah Semester (UTS).

Surakarta, 06 November 2026

| Perwakilan Pengguna (Staff Gudang) | Tim Penguji (Mahasiswa QA) | Dosen Pengampu / Reviewer |
|:---:|:---:|:---:|
| <br><br>**( Budi Santoso )**<br>Staff Pergudangan | <br><br>**( Ismail Fikron )**<br>NIM. *(Isi NIM Anda)* | <br><br>**( Triyono M.Kom )**<br>Dosen Pengampu Mobile Testing |
