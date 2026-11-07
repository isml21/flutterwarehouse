# Panduan Pengujian Mobile Testing dengan Maestro CLI

Direktori ini berisi berkas konfigurasi **Maestro Test Suite (YAML)** yang telah diringkas secara optimal menjadi **4 Berkas Pengujian Utama** untuk menguji seluruh fitur pada aplikasi **MyWarehouse** (`com.warehouse.box_management_system`).

---

## 📁 4 Berkas Pengujian Utama

| Berkas YAML | Deskripsi Skenario & Test Case |
|---|---|
| [`01_auth_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/01_auth_test.yaml) | **Modul Autentikasi**: Validasi field kosong, format email salah, password < 6 karakter, fitur demo login cepat, dan keberhasilan masuk ke katalog (TC-AUTH-01 s/d TC-AUTH-05). |
| [`02_katalog_tambah_box_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/02_katalog_tambah_box_test.yaml) | **Modul Katalog & Registrasi**: Auto-generate kode acak, input nama/dimensi box, live kalkulasi volume (24.00 L), terbit popup QR Code, serta pengujian search bar dan filter status stok (TC-BOX-01 s/d TC-BOX-05). |
| [`03_transaksi_stok_qr_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/03_transaksi_stok_qr_test.yaml) | **Modul Transaksi & Scanner**: Transaksi Stock IN (+10 unit), validasi batas penarikan berlebih (*over-withdrawal boundary test*), Stock OUT (-2 unit), dan pembukaan scanner QR code serta pencarian kode manual (TC-TRX-01 s/d TC-TRX-05). |
| [`04_hapus_box_test.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/04_hapus_box_test.yaml) | **Modul Hapus Box & Keamanan**: Uji pembatalan hapus dialog (*Negative Flow / human error prevention*), modal konfirmasi glassmorphic, dan eksekusi hapus box permanen dari Supabase (*Positive Flow*) (UAT-09, UAT-10, TC-BOX-06, TC-BOX-07). |
| [`run_all.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/run_all.yaml) | **Master Test Suite**: Menjalankan ke-4 pengujian di atas secara berurutan (*Full End-to-End*). |

---

## 🚀 Cara Menjalankan Maestro

### 1. Menjalankan Uji Per-Fitur (Pilih Salah Satu dari 4 Berkas)
```bash
# 1. Uji Autentikasi & Form Login
maestro test maestro/01_auth_test.yaml

# 2. Uji Registrasi Box, Volume & Filter Katalog
maestro test maestro/02_katalog_tambah_box_test.yaml

# 3. Uji Transaksi Stok In/Out & Scanner QR
maestro test maestro/03_transaksi_stok_qr_test.yaml

# 4. Uji Hapus Item / Box & Keamanan Dialog
maestro test maestro/04_hapus_box_test.yaml
```

### 2. Menjalankan SEMUA Pengujian Sekaligus
```bash
maestro test maestro/run_all.yaml
```

### 3. Menggunakan Maestro Studio (Web GUI)
```bash
maestro studio
```
Buka browser di **`http://localhost:9999`**.
