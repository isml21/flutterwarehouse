# Panduan Pengujian Mobile Testing dengan Maestro CLI

Direktori ini berisi berkas konfigurasi **Maestro Test Suite (YAML)** untuk menguji seluruh fitur pada aplikasi **Box Management System (Warehouse & QR Tracking System)** (`com.warehouse.box_management_system`).

---

## 📁 Struktur Berkas Pengujian

| Berkas YAML | Deskripsi Skenario & Test Case |
|---|---|
| [`01_auth_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/01_auth_flow.yaml) | **TS-01 Autentikasi**: Validasi field kosong, format email salah, password < 6 karakter, tombol demo cepat, dan login sukses (TC-AUTH-01 s/d TC-AUTH-05). |
| [`02_box_registration_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/02_box_registration_flow.yaml) | **TS-02 Registrasi Box**: Validasi dimensi `0` (Boundary), auto-generate kode acak, input box baru, hitung volume otomatis, dan dialog QR Code (TC-BOX-01, TC-BOX-02, TC-BOX-05). |
| [`03_catalog_search_filter_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/03_catalog_search_filter_flow.yaml) | **TS-02 Pencarian & Filter**: Pencarian realtime search bar, filter chip status stok (*In Stock*, *Low Stock*, *Out of Stock*, *Semua*), dan dialog QR Code (TC-BOX-03 s/d TC-BOX-05). |
| [`04_stock_transaction_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/04_stock_transaction_flow.yaml) | **TS-03 Transaksi Stok**: Stock IN (+10 unit), validasi over-withdrawal stok minus, dan Stock OUT valid (TC-TRX-03 s/d TC-TRX-05). |
| [`05_qr_scanner_manual_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/05_qr_scanner_manual_flow.yaml) | **TS-03 Scanner QR & Fallback**: Membuka scanner, fallback pencarian input manual kode box/UUID jika pada emulator kamera tidak aktif (TC-TRX-01, TC-TRX-02). |
| [`06_delete_box_flow.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/06_delete_box_flow.yaml) | **TS-06 Hapus Item / Box**: Membuka dialog konfirmasi glassmorphic, uji pembatalan, dan konfirmasi penghapusan item box (TC-DEL-01, TC-DEL-02). |
| [`run_all.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/run_all.yaml) | **Master Test Suite**: Menjalankan seluruh pengujian di atas secara sekuensial end-to-end. |
| [`subflows/login.yaml`](file:///c:/xampp/FLUTTER/TUGAS%20MOBILETESTING/maestro/subflows/login.yaml) | *Helper subflow* untuk login otomatis sebelum menjalankan skenario individual. |

---

## 🚀 Cara Menjalankan Maestro

### 1. Prasyarat Instalasi
Pastikan perangkat Android (fisik atau Emulator) sudah terhubung dan terdeteksi melalui ADB:
```bash
adb devices
```

Jika Maestro belum terpasang di sistem Windows, pasang melalui PowerShell:
```powershell
# Menggunakan PowerShell (Official installer via curl/scoop/npm)
curl -fsSL "https://get.maestro.mobile.dev" | powershell
```
Atau jika menggunakan Node.js:
```bash
npm install -g maestro-cli
```

### 2. Build & Install Aplikasi ke Emulator / Device
Sebelum pengujian dijalankan, pastikan aplikasi sudah ter-install di emulator:
```bash
flutter run
# atau
flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### 3. Menjalankan Uji Otomatis

#### A. Menjalankan Seluruh Suite Pengujian (End-to-End)
```bash
maestro test maestro/run_all.yaml
```

#### B. Menjalankan Alur Spesifik Saja
```bash
# Uji Autentikasi & Validasi Form
maestro test maestro/01_auth_flow.yaml

# Uji Registrasi Box Baru & QR Code
maestro test maestro/02_box_registration_flow.yaml

# Uji Pencarian & Filter Katalog
maestro test maestro/03_catalog_search_filter_flow.yaml

# Uji Transaksi Stok IN & OUT
maestro test maestro/04_stock_transaction_flow.yaml

# Uji Scanner & Input Manual
maestro test maestro/05_qr_scanner_manual_flow.yaml

# Uji Hapus Item / Box
maestro test maestro/06_delete_box_flow.yaml
```

#### C. Mode Interaktif (Maestro Studio)
Untuk melihat hierarki UI dan elemen aplikasi secara visual di browser saat menulis atau memvalidasi test:
```bash
maestro studio
```
