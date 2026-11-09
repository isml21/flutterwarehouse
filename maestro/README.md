# 📱 Panduan Lengkap Otomasi Pengujian Maestro & Naskah Presentasi UTS
### Proyek: MyWarehouse (Warehouse Inventory & QR Tracking System)
**Mata Kuliah:** Mobile Testing • **Kelas:** TI-23B  
**Fakultas:** Ilmu Komputer • **Universitas:** Universitas Duta Bangsa Surakarta  
**Dosen Pengampu:** Triyono M.Kom  
**Penyaji / Lead QA:** Ismail Fikrun Amin  
**Target Package ID:** `com.warehouse.box_management_system`

---

## 📑 Daftar Isi
1. [Ringkasan 4 Alur Pengujian Utama](#-1-ringkasan-4-alur-pengujian-utama)
2. [Naskah Presentasi & Video Demo (~8 - 10 Menit)](#-2-naskah-presentasi--video-demo)
3. [Penjelasan Mendalam Tiap Flow Pengujian (YAML Deep Dive)](#-3-penjelasan-mendalam-tiap-flow-pengujian)
   - [Flow 01: Autentikasi & Form Login (`01_auth_test.yaml`)](#flow-01-autentikasi--form-login-01_auth_testyaml)
   - [Flow 02: Registrasi Box Baru, Volume & Katalog (`02_katalog_tambah_box_test.yaml`)](#flow-02-registrasi-box-baru-volume--katalog-02_katalog_tambah_box_testyaml)
   - [Flow 03: Transaksi Stok In/Out & Scanner QR (`03_transaksi_stok_qr_test.yaml`)](#flow-03-transaksi-stok-inout--scanner-qr-03_transaksi_stok_qr_testyaml)
   - [Flow 04: Fitur Hapus Box & Dialog Keamanan (`04_hapus_box_test.yaml`)](#flow-04-fitur-hapus-box--dialog-keamanan-04_hapus_box_testyaml)
   - [Master Suite: Eksekusi Penuh Sekaligus (`run_all.yaml`)](#master-suite-eksekusi-penuh-sekaligus-run_allyaml)
4. [Cara Menjalankan Pengujian](#-4-cara-menjalankan-pengujian)
5. [Q&A Cheatsheet (Antisipasi Pertanyaan Dosen)](#-5-qa-cheatsheet-antisipasi-pertanyaan-dosen)

---

## 📂 1. Ringkasan 4 Alur Pengujian Utama

| Berkas YAML | Cakupan Modul | Kategori Pengujian | Test Case Terkait |
|---|---|:---:|---|
| [`01_auth_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/01_auth_test.yaml) | **Autentikasi & Login** | Negatif & Positif | `TC-AUTH-01` s/d `TC-AUTH-05` |
| [`02_katalog_tambah_box_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/02_katalog_tambah_box_test.yaml) | **Registrasi Box & Katalog** | Fungsional & UI | `TC-BOX-01` s/d `TC-BOX-05` |
| [`03_transaksi_stok_qr_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/03_transaksi_stok_qr_test.yaml) | **Transaksi Stok & QR** | Batas (*Boundary*) & Integrasi | `TC-TRX-01` s/d `TC-TRX-05` |
| [`04_hapus_box_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/04_hapus_box_test.yaml) | **Hapus Box & Keamanan** | Negatif & Positif (*Cascade*) | `UAT-09`, `UAT-10`, `TC-BOX-06`, `TC-BOX-07` |
| [`run_all.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/run_all.yaml) | **Master End-to-End Suite** | Regresi Penuh | Menjalankan ke-4 file di atas secara berurutan |

---

## 🎙️ 2. Naskah Presentasi & Video Demo

Gunakan naskah ini saat merekam video penjelasan UTS (Estimasi waktu: 8 - 10 menit):

### Segmen A: Pembukaan & Identitas Mahasiswa (00:00 - 01:00)
> *"Assalamu’alaikum Warahmatullahi Wabarakatuh.  
> Selamat pagi/siang/sore kepada Bapak **Triyono M.Kom** selaku dosen pengampu mata kuliah **Mobile Testing**, serta rekan-rekan sekalian.  
> Perkenalkan, nama saya **Ismail Fikrun Amin**, mahasiswa Program Studi Teknik Informatika kelas **TI-23B**, Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta.  
> Pada video ini, saya akan mempresentasikan hasil proyek UTS Mobile Testing pada aplikasi **MyWarehouse**, meliputi implementasi fitur baru hapus box, perombakan antarmuka Glassmorphism, serta otomasi pengujian End-to-End menggunakan **Maestro**."*

### Segmen B: Gambaran Singkat Aplikasi MyWarehouse (01:00 - 02:30)
> *"Aplikasi **MyWarehouse** dirancang untuk mengatasi permasalahan pencatatan pergudangan manual yang rawan selisih stok dan penempatan barang yang tidak terorganisir.  
> Fitur utamanya meliputi:  
> 1. Autentikasi aman terintegrasi Supabase.  
> 2. Katalog box dengan kartu KPI dan filter status stok.  
> 3. Form registrasi box dengan kode acak unik, kalkulasi volume otomatis realtime (*Panjang x Lebar x Tinggi*), dan generator QR Code instan.  
> 4. Transaksi stok masuk/keluar dengan proteksi penarikan melebihi stok (*over-withdrawal protection*).  
> 5. **Fitur Baru - Hapus Item Box:** Memungkinkan staf gudang menghapus box lama/rusak melalui modal dialog konfirmasi transparan, dengan mekanisme pencegahan tombol 'Batal' dan eksekusi permanen berbasis *Cascade Delete* di database.  
> Seluruh antarmuka telah didesain ulang dengan gaya modern **Glassmorphism** (*frosted glass*)."*

### Segmen C: Live Demo Otomasi Maestro & Penutup (02:30 - selesai)
> *"Sekarang, saya akan mendemonstrasikan eksekusi otomasi pengujian Maestro yang telah diringkas menjadi 4 alur terpadu melalui perintah:  
> `maestro test maestro/run_all.yaml`  
> Mari kita bedah jalannya setiap skenario pengujian di layar emulator."*

---

## 🔍 3. Penjelasan Mendalam Tiap Flow Pengujian

---

### Flow 01: Autentikasi & Form Login (`01_auth_test.yaml`)
**Tujuan:** Memvalidasi mekanisme keamanan login, penanganan kesalahan masukan pengguna (*negative testing*), dan keberhasilan login petugas gudang.

#### 1. Skenario & Langkah Kerja:
- **Pembersihan State (`clearState: true`):** Memastikan sesi lama terhapus sehingga aplikasi dimulai benar-benar dari layar masuk.
- **Validasi Field Kosong (Negative Test):**  
  Mengetuk tombol `'Masuk Sekarang'` tanpa mengisi apapun.  
  *Assertion:* Memastikan pesan error `'Email wajib diisi'` dan `'Kata sandi wajib diisi'` muncul di bawah input.
- **Validasi Format Email (Negative Test):**  
  Mengetikkan email salah (tanpa domain valid), lalu mencoba masuk.  
  *Assertion:* Memastikan pesan `'Format email tidak valid'` muncul.
- **Validasi Panjang Password (Boundary Test):**  
  Memasukkan kata sandi hanya 5 karakter (`12345`).  
  *Assertion:* Memastikan pesan `'Kata sandi minimal 6 karakter'` muncul.
- **Fitur Kredensial Cepat & Login Sukses (Positive Test):**  
  Mengetikkan email dan password yang sah, menekan `'Masuk Sekarang'`, dan memverifikasi notifikasi sambutan serta transisi ke beranda katalog (`'Katalog Box Gudang'`).
- **Bukti Pengujian:** Mengambil tangkapan layar otomatis ke `screenshots/01_auth_success.png`.

#### 2. Narasi Video untuk Flow 01:
> *"Pada Flow 01, Maestro menguji keamanan layar login secara komprehensif. Pertama, Maestro sengaja menekan tombol masuk dalam kondisi form kosong untuk memicu validasi error. Selanjutnya, Maestro menguji input email tanpa format yang benar dan kata sandi di bawah 6 karakter. Terakhir, Maestro memasukkan kredensial yang sah dan memverifikasi bahwa beranda katalog terbuka secara sempurna."*

---

### Flow 02: Registrasi Box Baru, Volume & Katalog (`02_katalog_tambah_box_test.yaml`)
**Tujuan:** Menguji proses pendaftaran box gudang baru, akurasi perhitungan matematis volume secara realtime, terbitnya QR Code, serta fungsionalitas pencarian dan filter katalog.

#### 1. Skenario & Langkah Kerja:
- **Login Otomatis (Subflow Guard):** Memastikan status login aktif sebelum membuka katalog.
- **Pendaftaran Box Baru:**  
  Mengetuk `'Tambah Box Baru'`, lalu menekan tombol `'Acak'` untuk mengenerate kode acak unik (misal: `BOX-4821`).  
  Mengisi nama box dengan `'Box Sparepart Mesin Industri'`.
- **Kalkulasi Volume Otomatis (Realtime Math Test):**  
  Memasukkan Panjang = `40 cm`, Lebar = `30 cm`, Tinggi = `20 cm`.  
  *Formula:* $(40 \times 30 \times 20) / 1000 = 24.00\text{ Liter}$.  
  *Assertion:* Memverifikasi bahwa label `24.00 Liter` langsung terhitung dan tampil di kartu glassmorphic.
- **Pencegahan Halangan Keyboard (`hideKeyboard`):**  
  Menutup keyboard Android agar tombol `'Simpan Box & Generate QR Code'` tidak tertutup saat discroll.
- **Penerbitan QR Code & Penutupan Dialog:**  
  Menyimpan box, memverifikasi dialog pop-up QR Code terbit, lalu menutup dialog untuk kembali ke katalog.
- **Pengujian Pencarian & Filter Status:**  
  Mencari lokasi rak (`'Rak B-04'`) pada search bar, menguji filter chips (`In Stock`, `Low Stock`, `Semua`), dan mengambil tangkapan layar `screenshots/02_katalog_tambah_box_success.png`.

#### 2. Narasi Video untuk Flow 02:
> *"Pada Flow 02, Maestro membuka form registrasi box baru dan mendemonstrasikan fitur kode acak. Ketika dimensi 40x30x20 dimasukkan, Maestro melakukan assertion bahwa sistem secara tepat menghitung volume 24 liter secara otomatis tanpa perlu menekan tombol hitung. Setelah disimpan, modal QR Code muncul dan ditutup, dilanjutkan dengan pengujian pencarian box di katalog."*

---

### Flow 03: Transaksi Stok In/Out & Scanner QR (`03_transaksi_stok_qr_test.yaml`)
**Tujuan:** Menguji akurasi pencatatan inventaris barang masuk, pengurangan barang keluar, validasi batas stok (*over-withdrawal boundary check*), dan integrasi modul scanner.

#### 1. Skenario & Langkah Kerja:
- **Membuka Modal Transaksi:** Mengetuk tombol `'Stock In / Out'` pada kartu box pertama.
- **Transaksi Stock IN (+10 Unit):**  
  Memilih tab `'Stock IN (Masuk)'`, mengetuk quick chip `'+10'`, dan menekan konfirmasi. Stok bertambah secara realtime di database.
- **Validasi Over-Withdrawal (Pencegahan Stok Negatif):**  
  Beralih ke tab `'Stock OUT (Keluar)'`, lalu memasukkan kuantitas ekstrim `9999`.  
  *Assertion:* Memverifikasi bahwa sistem menampilkan peringatan merah `'melebihi stok yang ada'` dan memblokir transaksi, sehingga stok fisik gudang tidak pernah menjadi minus.
- **Transaksi Stock OUT Valid (-2 Unit):**  
  Memasukkan nilai pengeluaran yang valid (`2 unit`), melakukan konfirmasi, dan menutup bottom sheet.
- **Modul Scanner QR Code & Fallback Manual:**  
  Membuka layar scanner kamera (`'Scan QR Box'`). Karena pengujian dijalankan di emulator tanpa kamera fisik, Maestro menguji fitur cadangan (*fallback*) `'Input Kode / UUID Manual'`, memasukkan kode box, dan memverifikasi detail box ditemukan.
- **Bukti Pengujian:** Mengambil tangkapan layar `screenshots/03_stock_transaction_success.png` dan `screenshots/03_qr_scanner_success.png`.

#### 2. Narasi Video untuk Flow 03:
> *"Pada Flow 03, kita menguji transaksi stok. Fitur krusial di sini adalah validasi over-withdrawal: jika staf gudang salah memasukkan jumlah keluar melebihi stok yang tersisa, sistem MyWarehouse secara pintar memunculkan peringatan merah dan menolak transaksi. Selain itu, Maestro juga menguji fleksibilitas scanner QR yang dilengkapi mode input manual."*

---

### Flow 04: Fitur Hapus Box & Dialog Keamanan (`04_hapus_box_test.yaml`)
**Tujuan:** Menguji fitur terbaru penghapusan item box, dialog konfirmasi keamanan glassmorphic, pencegahan kesalahan (*human error*), dan eksekusi penghapusan permanen.

#### 1. Skenario & Langkah Kerja:
- **Seleksi Tombol Hapus Presisi (`index: 0`):**  
  Di katalog terdapat banyak kartu box. Maestro menggunakan selektor:
  ```yaml
  - tapOn:
      text: "Hapus Item / Box"
      index: 0
  ```
  Hal ini menjamin Maestro menargetkan kartu box pertama tanpa memicu error ambiguitas elemen ganda.
- **Skenario Pembatalan Hapus (Negative Flow / Human Error Prevention):**  
  Saat dialog peringatan muncul, pengguna mengetuk tombol `'Batal'`.  
  *Assertion:* Dialog tertutup (`assertNotVisible`) dan kartu box dipastikan tetap aman berada di katalog tanpa perubahan data.
- **Skenario Konfirmasi Hapus Box (Positive Flow):**  
  Mengetuk kembali tombol hapus, lalu menekan tombol konfirmasi aksi dengan penanda posisi:
  ```yaml
  - tapOn:
      text: "Hapus Box"
      below: ".*permanen.*"
  ```
  Penanda `below` memastikan Maestro menekan tombol aksi di bagian bawah, bukan judul dialog di bagian atas.
- **Pembersihan Database (*Cascade Delete*):**  
  Data box beserta seluruh riwayat transaksi terkait otomatis terhapus dari Supabase via aturan foreign key `ON DELETE CASCADE`.
- **Bukti Pengujian:** Mengambil tangkapan layar `screenshots/04_hapus_box_success.png`.

#### 2. Narasi Video untuk Flow 04:
> *"Flow 04 menguji fitur paling baru, yaitu Hapus Item Box. Untuk menghindari penghapusan yang tidak sengaja, sistem dilengkapi dialog konfirmasi transparan berefek kaca. Maestro pertama-tama menguji tombol 'Batal' untuk membuktikan data tetap aman jika pengguna membatalkan aksi. Kemudian, Maestro menguji konfirmasi hapus permanen, di mana data langsung dihapus secara bersih dari database Supabase."*

---

### Master Suite: Eksekusi Penuh Sekaligus (`run_all.yaml`)
Berkas ini bertindak sebagai orkestrator yang memanggil ke-4 flow di atas dalam satu perintah:

```yaml
appId: com.warehouse.box_management_system
---
- runFlow: 01_auth_test.yaml
- runFlow: 02_katalog_tambah_box_test.yaml
- runFlow: 03_transaksi_stok_qr_test.yaml
- runFlow: 04_hapus_box_test.yaml
```

---

## 💻 4. Cara Menjalankan Pengujian

Pastikan emulator Android aktif (`adb devices` terdeteksi), lalu buka terminal di root folder proyek:

### A. Menjalankan Seluruh Pengujian (Rekomendasi saat Rekaman Video)
```bash
maestro test maestro/run_all.yaml
```

### B. Menjalankan Per-Modul Secara Individual
```bash
# 1. Uji Login & Validasi Form
maestro test maestro/01_auth_test.yaml

# 2. Uji Registrasi Box, Volume & Katalog
maestro test maestro/02_katalog_tambah_box_test.yaml

# 3. Uji Transaksi Stok & Scanner QR
maestro test maestro/03_transaksi_stok_qr_test.yaml

# 4. Uji Hapus Box & Dialog Keamanan
maestro test maestro/04_hapus_box_test.yaml
```

### C. Menjalankan via Maestro Studio (Web GUI Interaktif)
```bash
maestro studio
```
Buka browser di **`http://localhost:9999`**.

---

## 💡 5. Q&A Cheatsheet (Antisipasi Pertanyaan Dosen)

| No | Kemungkinan Pertanyaan Dosen | Jawaban Teknis & Tepat |
|:---:|---|---|
| **1** | *"Kenapa memilih Maestro dibanding Appium?"* | **Maestro bersifat deklaratif dan *driverless* (tanpa WebDriver).** Maestro membaca hierarki aksesibilitas antarmuka secara langsung seperti mata pengguna manusia, memiliki mekanisme *auto-retry* cerdas terhadap animasi Flutter, serta eksekusinya jauh lebih cepat tanpa konfigurasi rumit. |
| **2** | *"Bagaimana cara kerja penghapusan box pada database Supabase?"* | **Menggunakan aturan `ON DELETE CASCADE`.** Pada skema database PostgreSQL Supabase, tabel transaksi `box_transactions` memiliki foreign key yang merujuk ke tabel `boxes(id)`. Ketika sebuah box dihapus, seluruh riwayat transaksi keluar-masuknya otomatis dibersihkan sehingga tidak meninggalkan *orphaned data*. |
| **3** | *"Kenapa tidak menggunakan properti `hintText:` di berkas YAML Maestro?"* | **Karena `hintText:` bukan properti resmi Maestro.** Maestro secara otomatis memetakan teks petunjuk (*placeholder/hint*) sebagai teks biasa (`text:` atau string langsung). Oleh karena itu, menulis `tapOn: "nama@perusahaan.com"` adalah sintaks baku yang valid dan bebas dari error `Unknown property`. |
| **4** | *"Bagaimana Maestro mengatasi masalah elemen ganda (Ambiguous Element) pada tombol hapus?"* | **Menggunakan parameter indeks `index: 0`.** Karena katalog menampilkan banyak kartu box yang masing-masing memiliki tombol hapus, Maestro kita arahkan secara deterministik untuk memilih kartu pertama di bagian atas layar. |
