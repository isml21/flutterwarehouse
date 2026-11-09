# 🎬 NASKAH LENGKAP PRESENTASI & VIDEO DEMO UTS MOBILE TESTING
### Aplikasi: MyWarehouse (Warehouse Inventory & QR Tracking System)
**Mata Kuliah:** Mobile Testing • **Program Studi:** Teknik Informatika (TI-23B)  
**Fakultas:** Ilmu Komputer • **Universitas:** Universitas Duta Bangsa (UDB) Surakarta  
**Dosen Pengampu:** Triyono M.Kom  
**Penyaji / Lead QA:** Ismail Fikrun Amin (NIM: *Isi NIM Anda*)

---

## ⏱️ Rencana Pembagian Durasi Video (Total: ~8 - 10 Menit)

| Segmen | Topik Bahasan | Tampilan Layar (*Visual Scene*) | Estimasi Waktu |
|:---:|---|---|:---:|
| **1** | Pembukaan & Identitas Mahasiswa | Wajah Mahasiswa / Slide Judul | 01:00 |
| **2** | Latar Belakang & Arsitektur MyWarehouse | Slide / Halaman Utama Aplikasi | 01:30 |
| **3** | Demo Manual Fitur Aplikasi di Emulator | Layar Emulator Android (App Walkthrough) | 02:30 |
| **4** | Bedah Kode & Penjelasan 4 File YAML Maestro | Editor VS Code (Bedah Sintaks Maestro) | 02:30 |
| **5** | Live Execution Otomasi Maestro | Terminal CLI (`maestro test`) + Emulator | 01:30 |
| **6** | Laporan UAT & Lembar Persetujuan | Spreadsheet Excel & Dokumen Markdown | 01:00 |
| **7** | Penutup | Wajah Mahasiswa / Slide Penutup | 00:30 |

---

## 🎙️ NASKAH KATA DEMI KATA (VERBATIM SCRIPT)

### 📌 SEGMEN 1: PEMBUKAAN & PERKENALAN DIRI (00:00 - 01:00)
*(Tampilan Layar: Wajah Anda di kamera atau slide pembuka yang memuat Logo UDB, Nama Aplikasi, Nama, NIM, dan Dosen Pengampu).*

> **[Bicara dengan percaya diri dan tempo teratur]:**
> 
> "Assalamu’alaikum Warahmatullahi Wabarakatuh.  
> Selamat pagi/siang/sore kepada Bapak **Triyono M.Kom** selaku dosen pengampu mata kuliah **Mobile Testing**, serta rekan-rekan sekalian.
> 
> Perkenalkan, nama saya **Ismail Fikrun Amin**, mahasiswa Program Studi Teknik Informatika kelas **TI-23B**, Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta.
> 
> Pada kesempatan kali ini, saya akan mempresentasikan serta mendemonstrasikan hasil pengerjaan proyek **Ujian Tengah Semester (UTS) Mobile Testing**. Proyek ini mencakup pengembangan aplikasi inventaris gudang berbasis Flutter bernama **MyWarehouse**, perancangan skenario *User Acceptance Testing* (UAT), dan implementasi otomasi pengujian *End-to-End* menggunakan **Maestro**."

---

### 📌 SEGMEN 2: LATAR BELAKANG & GAMBARAN APLIKASI (01:00 - 02:30)
*(Tampilan Layar: Buka aplikasi MyWarehouse di Emulator Android).*

> **[Bicara]:**
> 
> "Sebelum masuk ke pengujian, izinkan saya menjelaskan secara singkat mengenai aplikasi **MyWarehouse**.
> 
> **1. Masalah yang Diselesaikan:**  
> Pada operasional pergudangan konvensional, pencatatan keluar-masuk box barang sering kali dilakukan secara manual atau terpisah. Hal ini rentan terhadap *human error*, selisih stok fisik, ketidakakuratan data volume ruang rak, serta proses pelacakan lokasi barang yang lambat.
> 
> **2. Solusi yang Diberikan MyWarehouse:**  
> MyWarehouse hadir sebagai solusi modern manajemen inventaris box dengan fitur unggulan:
> - **Autentikasi Aman:** Terintegrasi dengan database *cloud* Supabase.
> - **Katalog & Registrasi Box:** Dilengkapi fitur *Auto-Code Generator*, kalkulasi volume otomatis secara realtime (*Panjang x Lebar x Tinggi*), serta penerbitan QR Code instan.
> - **Transaksi Stok Terpadu:** Pencatatan *Stock In* dan *Stock Out* dengan sistem proteksi *over-withdrawal* (mencegah penarikan barang melebihi stok yang ada).
> - **Fitur Baru - Hapus Item/Box:** Memungkinkan staf gudang menghapus box yang rusak atau tidak digunakan lagi, dilengkapi dialog konfirmasi keamanan serta *Cascade Delete* di database.
> - **Desain Modern Glassmorphism:** Tampilan visual baru berefek kaca akrilik (*frosted glass*) dengan *ambient lighting* dan icon launcher MyWarehouse yang proporsional."

---

### 📌 SEGMEN 3: DEMO FITUR APLIKASI DI EMULATOR (02:30 - 05:00)
*(Tampilan Layar: Tunjukkan interaksi langsung pada layar Emulator Android).*

> **[Bicara sambil mempraktikkan di layar]:**
> 
> "Sekarang, mari kita lihat demonstrasi langsung fitur aplikasi di emulator:
> 
> 1. **Layar Login (Autentikasi):**  
>    Di sini terdapat validasi form yang ketat. Jika email kosong atau formatnya salah, sistem akan menampilkan pesan validasi. Untuk kemudahan pengujian, tersedia tombol **'Isi Akun Demo Cepat'**, lalu kita klik **'Masuk Sekarang'**.
> 
> 2. **Katalog Box Gudang:**  
>    Setelah masuk, kita disambut antarmuka modern *Glassmorphism*. Di bagian atas terdapat ringkasan KPI *Total Jenis Box*, *Total Unit*, dan *Unit Rendah*. Di bawahnya terdapat *Search Bar* untuk pencarian realtime dan *Filter Chips* status stok (*In Stock*, *Low Stock*, *Out of Stock*).
> 
> 3. **Registrasi Box Baru & Live Volume:**  
>    Saat menekan tombol **'Tambah Box Baru'**, kita bisa menekan tombol **'Acak'** untuk membuat kode box otomatis. Saat dimensi panjang, lebar, dan tinggi diubah, label estimasi volume langsung terkalkulasi secara realtime. Setelah disimpan, muncul modal dialog **QR Code** berisi identifier unik UUID box yang siap discan.
> 
> 4. **Fitur Transaksi Cepat (Stock In/Out):**  
>    Pada setiap kartu box terdapat tombol **'Stock In / Out'**. Kita dapat menambah stok dengan quick chip (+10) atau mengurangi stok. Jika kita mencoba mengurangi stok melebihi jumlah unit yang ada, muncul peringatan merah yang memblokir transaksi.
> 
> 5. **Fitur Baru: Hapus Item/Box Permanen:**  
>    Ini adalah fitur terbaru yang diminta. Pada setiap kartu box terdapat ikon tong sampah merah.  
>    - Jika diklik, muncul modal dialog konfirmasi transparan berefek kaca yang menampilkan ringkasan data box dan peringatan bahwa tindakan ini permanen.  
>    - Jika kita klik **'Batal'**, dialog tertutup dan box tetap aman (*Negative Flow*).  
>    - Namun jika kita klik **'Hapus Box'**, sistem akan mengeksekusi *cascade delete* di Supabase dan kartu box langsung hilang dari katalog secara *realtime* (*Positive Flow*)."

---

### 📌 SEGMEN 4: PENJELASAN OTOMASI PENGUJIAN MAESTRO (05:00 - 07:30)
*(Tampilan Layar: Buka folder `maestro/` di Visual Studio Code, buka satu per satu filenya).*

> **[Bicara]:**
> 
> "Selanjutnya, kita masuk ke inti penilaian Mobile Testing, yaitu **Otomasi Pengujian dengan Maestro**.
> 
> **Mengapa Memilih Maestro?**  
> Maestro adalah framework pengujian mobile modern berbasis deklaratif YAML. Berbeda dengan Appium yang membutuhkan konfigurasi driver yang rumit, Maestro membaca elemen UI secara intuitif seperti mata pengguna asli, sangat cepat, dan tahan terhadap fluktuasi animasi Flutter.
> 
> Seluruh skenario pengujian di proyek ini telah diringkas secara elegan menjadi **4 Berkas YAML Utama**:
> 
> 1. **`01_auth_test.yaml` (Modul Autentikasi):**  
>    - Menguji skenario negatif: Validasi field kosong, format email tanpa '@', dan password kurang dari 6 karakter (*boundary test*).  
>    - Menguji skenario positif: Mengisi demo kredensial dan memverifikasi transisi layar ke 'Katalog Box Gudang'.
> 
> 2. **`02_katalog_tambah_box_test.yaml` (Modul Registrasi & Katalog):**  
>    - Mengetuk tombol 'Acak' kode box.  
>    - Memasukkan dimensi (Panjang 40, Lebar 30, Tinggi 20) dan melakukan assertion bahwa teks `24.00 Liter` muncul di layar secara realtime.  
>    - Menguji penutupan keyboard virtual dengan perintah `hideKeyboard` agar tombol simpan tidak tertutup.  
>    - Memverifikasi penerbitan dialog QR Code, menutupnya dengan perintah `back`, lalu menguji *search bar* dan *filter chip*.
> 
> 3. **`03_transaksi_stok_qr_test.yaml` (Modul Stok & Scanner):**  
>    - Membuka bottom sheet transaksi, menambah stok via quick chip (+10).  
>    - Menguji skenario negatif *over-withdrawal*: Memasukkan kuantitas 9999 unit dan memastikan banner peringatan 'melebihi stok yang ada' muncul.  
>    - Melakukan transaksi pengurangan 2 unit yang valid.  
>    - Menguji pembukaan kamera QR scanner dan fallback input manual kode box.
> 
> 4. **`04_hapus_box_test.yaml` (Modul Hapus Box & Dialog Keamanan):**  
>    - Menggunakan selector presisi `text: "Hapus Item / Box"` dengan parameter `index: 0` agar Maestro menarget kartu box pertama tanpa ambigu saat ada banyak box di layar.  
>    - Mengetuk 'Batal' dan memastikan dialog hilang tanpa menghapus data (*Negative Test*).  
>    - Mengetuk tombol hapus kembali, lalu mengeksekusi tombol 'Hapus Box' di bawah peringatan permanen (`below: ".*permanen.*"`).  
>    - Memverifikasi data box berhasil terhapus dari sistem.
> 
> Selain itu, terdapat berkas **`run_all.yaml`** yang berfungsi sebagai *master suite* untuk mengeksekusi ke-4 berkas di atas secara berurutan dari awal hingga akhir."

---

### 📌 SEGMEN 5: LIVE DEMO EKSEKUSI MAESTRO (07:30 - 09:00)
*(Tampilan Layar: Tampilkan layar terbelah: sebelah kiri Terminal CLI, sebelah kanan Emulator Android).*

> **[Bicara sambil mengetikkan perintah di Terminal]:**
> 
> "Sekarang, mari kita saksikan eksekusi otomasi pengujian Maestro secara langsung.  
> Saya akan menjalankan perintah master suite:
> 
> `maestro test maestro/run_all.yaml`
> 
> *(Sambil memperhatikan emulator yang bergerak otomatis)*:  
> - Terlihat Maestro otomatis meluncurkan aplikasi...
> - Menguji validasi form login yang sengaja dikosongkan dan disalahkan...
> - Login berhasil dan masuk ke halaman katalog...
> - Membuka form tambah box, mengisi ukuran, memverifikasi kalkulasi volume 24 liter, dan menutup QR code...
> - Melakukan penambahan stok dan mencoba penarikan stok berlebih...
> - Dan terakhir, menguji fitur hapus box: menekan tombol batal, kemudian menekan konfirmasi hapus permanen.
> 
> Seluruh assertion berhasil lolos dengan status **PASSED** tanpa ada error!"

---

### 📌 SEGMEN 6: LAPORAN UAT & LEMBAR PERSETUJUAN (09:00 - 09:45)
*(Tampilan Layar: Buka file `UAT.UDB Warehouse.xlsx` dan `LAPORAN_UAT.md`).*

> **[Bicara]:**
> 
> "Seluruh hasil pengujian manual maupun otomatis ini telah didokumentasikan secara formal dalam berkas:
> 1. **`UAT.UDB Warehouse.xlsx`**:  
>    - Berisi sheet **Test Case** dengan **18 Test Cases terperinci** mulai dari validasi form, inventaris, transaksi stok, hingga fitur hapus item.  
>    - Sheet **UAT** dengan **11 Skenario Pengujian Lapangan** dari sudut pandang staf gudang.  
>    - Dilengkapi formula rekapitulasi otomatis dengan tingkat keberhasilan **100% PASS**.
> 2. **`LAPORAN_UAT.md`**:  
>    - Dokumen laporan komprehensif berstandar industri lengkap dengan profil penguji, kriteria penerimaan, tabel temuan bug yang teresolusi, dan lembar persetujuan (*Sign-Off*).
> 
> Seluruh kode sumber, riwayat commit bertahap GitFlow, dan tag rilis **v1.1.0** telah diunggah ke repositori GitHub saya di:  
> `https://github.com/isml21/flutterwarehouse.git`."

---

### 📌 SEGMEN 7: PENUTUP (09:45 - 10:00)
*(Tampilan Layar: Wajah Anda di kamera).*

> **[Bicara]:**
> 
> "Demikian presentasi dan demonstrasi proyek UTS Mobile Testing aplikasi MyWarehouse. Melalui proyek ini, saya berhasil membuktikan bahwa pengujian mobile otomatis menggunakan Maestro mampu meningkatkan efisiensi, akurasi, dan kualitas perangkat lunak secara signifikan.
> 
> Terima kasih banyak atas bimbingan Bapak Triyono M.Kom selama perkuliahan ini. Kurang lebihnya saya mohon maaf.
> 
> Wabillahi taufiq wal hidayah,  
> Wassalamu’alaikum Warahmatullahi Wabarakatuh."

---

## 💡 PANDUAN MENJAWAB PERTANYAAN DOSEN (Q&A CHEATSHEET)

Jika saat presentasi atau evaluasi Bapak Triyono M.Kom memberikan pertanyaan, berikut contekan jawabannya:

#### 1. *Tanya:* "Kenapa memilih Maestro dibanding Appium atau Flutter Driver?"
> **Jawab:**  
> *"Maestro bekerja di level antarmuka pengguna luar (black-box), sehingga tidak memerlukan modifikasi pada kode produksi seperti Flutter Driver. Selain itu, Maestro menggunakan sintaks deklaratif YAML yang mudah dibaca oleh siapa saja, memiliki built-in retry mechanism sehingga tes tidak mudah 'flaky' saat ada animasi, serta kece двигаasi eksekusinya jauh lebih cepat dan ringan dibanding Appium."*

#### 2. *Tanya:* "Bagaimana sistem memastikan integritas data saat Box dihapus?"
> **Jawab:**  
> *"Pada database Supabase (PostgreSQL), tabel transaksi `box_transactions` memiliki foreign key ke tabel `boxes` dengan aturan `ON DELETE CASCADE`. Artinya, saat sebuah box dihapus, seluruh riwayat transaksi barang masuk dan keluarnya akan otomatis terhapus secara bersih sehingga tidak meninggalkan data yatim (orphaned records)."*

#### 3. *Tanya:* "Kenapa di YAML Maestro tidak menggunakan `hintText:`?"
> **Jawab:**  
> *"Karena di standar skema Maestro, hint text pada input field Android/Flutter langsung dipetakan ke atribut teks standar (`text`). Oleh karena itu, kita cukup menggunakan selektor teks biasa `tapOn: 'nama@perusahaan.com'` tanpa perlu atribut khusus `hintText:`, sehingga sintaks menjadi valid dan bebas error."*

#### 4. *Tanya:* "Bagaimana cara menangani tombol Hapus yang memiliki banyak elemen serupa di layar?"
> **Jawab:**  
> *"Kami menggunakan parameter `index: 0` pada perintah `tapOn: { text: 'Hapus Item / Box', index: 0 }`. Dengan parameter ini, Maestro secara deterministik akan memilih kartu box pertama di urutan atas, sehingga mencegah terjadinya error 'Ambiguous Element' saat katalog menampilkan banyak box sekaligus."*
