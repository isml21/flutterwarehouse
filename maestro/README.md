# 📱 Panduan Singkat Maestro & Poin Presentasi UTS
**Aplikasi:** MyWarehouse (`com.warehouse.box_management_system`)  
**Mata Kuliah:** Mobile Testing • **Kelas:** TI-23B • **Universitas:** UDB Surakarta  
**Mahasiswa:** Ismail Fikrun Amin • **Dosen Pengampu:** Triyono M.Kom  

---

## 🎙️ Poin Inti Presentasi Video (Cheat Sheet 3 Menit)

1. **Pembuka & Masalah:**
   > *"Aplikasi **MyWarehouse** dibuat untuk mendigitalkan pencatatan inventaris gudang agar terhindar dari selisih stok manual, salah hitung volume, dan kehilangan barang."*

2. **Fitur Utama Aplikasi:**
   - **Autentikasi Supabase:** Form login dengan validasi input yang ketat.
   - **Katalog & Registrasi Box:** Auto-generate kode unik, live hitung volume $(P \times L \times T / 1000)$, dan pop-up QR Code.
   - **Transaksi Stok:** Tambah stok (IN), kurangi stok (OUT), dan proteksi penarikan melebihi stok (*over-withdrawal*).
   - **Fitur Baru (Hapus Box):** Hapus item rusak/lama via modal konfirmasi glassmorphic dengan keamanan tombol 'Batal' dan *Cascade Delete* di database.
   - **Desain Glassmorphism:** Efek visual kaca modern (*frosted glass*) dengan logo baru.

3. **Kenapa Menggunakan Maestro:**
   > *"Maestro bersifat deklaratif berbasis YAML, sangat cepat, membaca UI seperti mata manusia tanpa perlu setup driver yang rumit, dan tidak mudah gagal (flaky) pada animasi Flutter."*

4. **Demonstrasi 4 Alur Otomasi:**
   > *(Jalankan `maestro test maestro/run_all.yaml` di terminal sambil menunjukkan emulator).*

5. **Hasil & Penutup:**
   > *"Seluruh 18 test cases dan 11 skenario UAT berhasil 100% PASS, terdokumentasi di file Excel dan GitHub."*

---

## 🔍 Penjelasan Inti Tiap Flow YAML

### 1. `01_auth_test.yaml` (Autentikasi & Form Login)
* **Fokus Uji:** Keamanan masukan dan validasi form login.
* **Inti Pengujian:**
  - **Negatif:** Cek form kosong $\rightarrow$ muncul *"Email/Sandi wajib diisi"*.
  - **Negatif:** Cek format email salah $\rightarrow$ muncul *"Format email tidak valid"*.
  - **Boundary:** Cek password 5 digit $\rightarrow$ muncul *"Kata sandi minimal 6 karakter"*.
  - **Positif:** Masuk dengan kredensial sah $\rightarrow$ berhasil pindah ke *"Katalog Box Gudang"*.

---

### 2. `02_katalog_tambah_box_test.yaml` (Tambah Box, Volume & Filter)
* **Fokus Uji:** Registrasi item baru, akurasi matematika volume, dan pencarian.
* **Inti Pengujian:**
  - Tekan **'Acak'** untuk generate kode box otomatis.
  - Masukkan dimensi $40 \times 30 \times 20\text{ cm}$ $\rightarrow$ sistem memverifikasi label **`24.00 Liter`** muncul realtime.
  - Perintah `hideKeyboard` menutup keyboard agar tombol simpan tidak tertutup.
  - Verifikasi dialog pop-up QR Code terbit, lalu tutup dialog (`back`).
  - Uji pencarian lokasi rak (`'Rak B-04'`) dan filter chip stok (`In Stock`, `Semua`).

---

### 3. `03_transaksi_stok_qr_test.yaml` (Transaksi Stok & Scanner)
* **Fokus Uji:** Keluar-masuk barang, pencegahan stok minus, dan QR scanner.
* **Inti Pengujian:**
  - **Stock IN:** Tambah unit dengan quick chip `+10` $\rightarrow$ stok bertambah.
  - **Proteksi Stok (Boundary):** Input jumlah keluar `9999` $\rightarrow$ sistem memblokir dengan peringatan *"melebihi stok yang ada"* (mencegah stok minus).
  - **Stock OUT:** Pengurangan sah `2 unit` $\rightarrow$ stok berkurang.
  - **Scanner QR:** Buka scanner kamera dan uji fallback *"Input Manual Kode Box/UUID"*.

---

### 4. `04_hapus_box_test.yaml` (Fitur Hapus Box & Keamanan)
* **Fokus Uji:** Penghapusan item permanen dan dialog pencegahan kesalahan.
* **Inti Pengujian:**
  - Selektor `index: 0` memastikan kartu box pertama yang dipilih (mencegah error elemen ambigu saat ada banyak box).
  - **Batal Hapus (Negatif):** Klik tombol tong sampah $\rightarrow$ dialog modal muncul $\rightarrow$ klik **'Batal'** $\rightarrow$ box **tetap aman** di katalog.
  - **Konfirmasi Hapus (Positif):** Klik tong sampah lagi $\rightarrow$ klik **'Hapus Box'** (di bawah teks permanen) $\rightarrow$ box **terhapus permanen** beserta riwayat transaksinya via *Cascade Delete* Supabase.

---

### 5. `run_all.yaml` (Master Runner)
* Menjalankan ke-4 file di atas secara sekuensial (Flow 01 $\rightarrow$ 02 $\rightarrow$ 03 $\rightarrow$ 04) dalam sekali perintah tanpa henti.

---

## ⚡ Perintah Cepat Terminal

```bash
# Jalankan SEMUA flow sekaligus (Disarankan saat rekaman video):
maestro test maestro/run_all.yaml

# Jalankan per-fitur jika ingin mendemokan satu per satu:
maestro test maestro/01_auth_test.yaml              # 1. Login
maestro test maestro/02_katalog_tambah_box_test.yaml # 2. Tambah Box
maestro test maestro/03_transaksi_stok_qr_test.yaml  # 3. Stok & QR
maestro test maestro/04_hapus_box_test.yaml          # 4. Hapus Box

# Buka Web GUI interaktif:
maestro studio
```

---

## 💡 Contekan Cepat Pertanyaan Dosen (Q&A)

1. **Kenapa pakai Maestro?**  
   *Sintaks deklaratif YAML mudah dibaca, tanpa setup driver rumit seperti Appium, dan punya auto-retry saat ada animasi Flutter.*
2. **Bagaimana data box terhapus di database?**  
   *Menggunakan aturan `ON DELETE CASCADE` di PostgreSQL Supabase sehingga riwayat transaksi box ikut terhapus bersih tanpa data yatim.*
3. **Kenapa pakai selektor `index: 0` di tombol hapus?**  
   *Untuk memilih kartu box pertama di layar dan mencegah error 'Ambiguous Element' karena ada banyak kartu box sekaligus.*
