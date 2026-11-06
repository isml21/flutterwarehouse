import os
import openpyxl
from copy import copy

def update_uat_workbook():
    filename = 'UAT.UDB Warehouse.xlsx'
    if not os.path.exists(filename):
        filename = 'UAT_UDB_Market_Place.xlsx'
    
    print(f"Loading workbook: {filename}")
    wb = openpyxl.load_workbook(filename)

    # ==========================================
    # 1. SHEET: Petunjuk
    # ==========================================
    ws_petunjuk = wb['Petunjuk']
    ws_petunjuk['A1'] = "Studi Kasus Mobile Testing: MyWarehouse (Warehouse Inventory & QR Tracking)"
    ws_petunjuk['A2'] = "Mata Kuliah Mobile Testing • Teknik Informatika • Universitas Duta Bangsa Surakarta"
    ws_petunjuk['B4'] = "MyWarehouse (Warehouse Inventory & QR Tracking System), versi mobile Flutter (Android) dengan Glassmorphic UI & Logo Baru"
    ws_petunjuk['B5'] = "F-01 Autentikasi Petugas Gudang • F-02 Manajemen Katalog (Tambah & Hapus Box) • F-03 Scanner QR Code & Transaksi Stok (In/Out) • F-04 Modern Glassmorphism UI"
    ws_petunjuk['B6'] = "Export PDF/Excel, Pelacakan GPS Multi-Gudang, Integrasi Payment Gateway / Invoicing"
    ws_petunjuk['A7'] = "Akun admin/petugas"
    ws_petunjuk['B7'] = "admin@gudang.com / warehouse123 (Tersedia tombol 'Isi Akun Demo Cepat')"
    ws_petunjuk['A8'] = "Akun pendaftaran"
    ws_petunjuk['B8'] = "Pendaftaran mandiri melalui tombol 'Daftar akun baru' pada halaman login"
    ws_petunjuk['B9'] = "Dijalankan tim QA (mahasiswa). Menguji verifikasi fungsional, validasi input form, boundary stok/dimensi, fitur hapus, dan penanganan error."
    ws_petunjuk['B10'] = "Dijalankan perwakilan pengguna (Staff Gudang & Supervisor Inventaris). Bahasa operasional sehari-hari gudang."
    ws_petunjuk['B11'] = "Catat setiap cacat/FAIL yang ditemukan saat pengujian. Tautkan ID bug ke kolom Bug ID."

    # ==========================================
    # 2. SHEET: Test Case (Row 5 to 22)
    # ==========================================
    ws_tc = wb['Test Case']
    test_cases = [
        # TS-01 Autentikasi
        (
            "TC-AUTH-01",
            "TS-01 Autentikasi",
            "Login berhasil dengan kredensial valid",
            "Positif",
            "Aplikasi terpasang; Halaman Login terbuka; koneksi internet aktif",
            "1. Masukkan Email Gudang yang terdaftar\n2. Masukkan Kata Sandi valid (>=6 karakter)\n3. Ketuk tombol 'Masuk Sekarang'",
            "Email: admin@gudang.com\nPassword: warehouse123",
            "Muncul snackbar hijau 'Selamat datang kembali!', sesi tersimpan, dialihkan ke beranda Katalog Box Gudang (BoxListScreen)",
            "Login berhasil, muncul notifikasi 'Selamat datang kembali!', dan masuk ke katalog box",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-AUTH-02",
            "TS-01 Autentikasi",
            "Validasi field email dan kata sandi kosong",
            "Negatif",
            "Halaman Login terbuka",
            "1. Kosongkan field Email Gudang\n2. Kosongkan field Kata Sandi\n3. Ketuk tombol 'Masuk Sekarang'",
            "Email: (kosong)\nPassword: (kosong)",
            "Form memunculkan pesan validasi: 'Email wajib diisi' dan 'Kata sandi wajib diisi'; proses sign in dibatalkan",
            "Muncul pesan validasi 'Email wajib diisi' dan 'Kata sandi wajib diisi', form tidak diproses",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-AUTH-03",
            "TS-01 Autentikasi",
            "Validasi format email tidak sesuai standar",
            "Negatif",
            "Halaman Login terbuka",
            "1. Masukkan email tanpa tanda @ atau tanpa domain .\n2. Masukkan kata sandi valid\n3. Ketuk tombol 'Masuk Sekarang'",
            "Email: petugasgudang@\nPassword: warehouse123",
            "Muncul pesan error validasi input: 'Format email tidak valid'; proses login ditolak",
            "Muncul pesan validasi 'Format email tidak valid' di bawah input email",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-AUTH-04",
            "TS-01 Autentikasi",
            "Validasi panjang kata sandi 5 karakter (di bawah batas minimum)",
            "Boundary",
            "Halaman Login terbuka",
            "1. Masukkan email valid\n2. Masukkan kata sandi tepat 5 karakter\n3. Ketuk tombol 'Masuk Sekarang'",
            "Email: admin@gudang.com\nPassword: 12345 (5 karakter)",
            "Muncul pesan validasi: 'Kata sandi minimal 6 karakter'; request tidak dikirim ke backend",
            "Validasi aktif dan memunculkan teks error 'Kata sandi minimal 6 karakter'",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-AUTH-05",
            "TS-01 Autentikasi",
            "Fitur pengisian otomatis Kredensial Demo Cepat",
            "Positif",
            "Halaman Login terbuka; kedua field input kosong",
            "1. Ketuk tombol outline 'Isi Akun Demo Cepat'\n2. Periksa isian field email & password",
            "Tombol 'Isi Akun Demo Cepat'",
            "Field email otomatis terisi 'admin@gudang.com', password terisi 'warehouse123', dan muncul notifikasi info 'Kredensial Demo terisi otomatis.'",
            "Email dan password terisi otomatis secara instan beserta snackbar notifikasi info",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),

        # TS-02 Katalog & Registrasi
        (
            "TC-BOX-01",
            "TS-02 Katalog & Registrasi",
            "Registrasi box baru dengan data lengkap dan auto-generate kode",
            "Positif",
            "Petugas login; Layar Registrasi Box Baru terbuka",
            "1. Ketuk tombol 'Acak' untuk auto-generate Kode Box\n2. Isi Nama Box\n3. Isi Panjang, Lebar, Tinggi dalam cm\n4. Pilih Tipe Material\n5. Isi Lokasi Rak & Stok Awal\n6. Ketuk 'Simpan Box & Generate QR Code'",
            "Kode: Auto (BOX-XXXX)\nNama: Kardus Sparepart Heavy Duty\nDimensi: 40x30x20 cm\nMaterial: Corrugated Double Wall\nLokasi: Rak B-02\nStok: 15",
            "Data tersimpan di Supabase, volume terhitung (24.00 L), muncul snackbar sukses dan otomatis menampilkan popup Dialog QR Code",
            "Box tersimpan di Supabase, stok tercatat 15 unit (In Stock), dan Dialog QR Code tampil otomatis",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-BOX-02",
            "TS-02 Katalog & Registrasi",
            "Validasi nilai dimensi box bernilai 0 atau negatif",
            "Boundary",
            "Layar Registrasi Box Baru terbuka",
            "1. Masukkan Panjang = 0\n2. Lengkapi field lainnya\n3. Ketuk 'Simpan Box & Generate QR Code'",
            "Panjang: 0 cm\nLebar: 20 cm\nTinggi: 15 cm",
            "Field Panjang menolak nilai <= 0 dengan pesan validasi '> 0'; form tidak disimpan ke database",
            "Muncul pesan error validasi '> 0' di bawah kolom panjang; data tidak tersimpan",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-BOX-03",
            "TS-02 Katalog & Registrasi",
            "Pencarian box realtime berdasarkan Kode, Nama, dan Lokasi",
            "Positif",
            "Layar Katalog Box menampilkan daftar data box",
            "1. Ketik kata kunci pada kolom Search Bar (nama box, kode, atau nomor rak)\n2. Amati pembaruan daftar box",
            "Keyword: 'Rak A' atau 'BOX-'",
            "Daftar box langsung tersaring secara realtime sesuai query tanpa perlu tekan enter; menampilkan box yang relevan",
            "Daftar box terfilter secara instan dan akurat; jika tidak cocok muncul ilustrasi empty state",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-BOX-04",
            "TS-02 Katalog & Registrasi",
            "Penyaringan box berdasarkan status stok (All, In Stock, Low Stock, Out of Stock)",
            "Positif",
            "Terdapat box dengan berbagai level kuantitas di gudang",
            "1. Ketuk filter chip 'Low Stock'\n2. Ketuk filter chip 'Out of Stock'\n3. Ketuk filter chip 'In Stock'",
            "Filter Chip: Low Stock (stok 1-5), Out of Stock (stok 0)",
            "Daftar box hanya menampilkan box sesuai status yang dipilih dan jumlah counter pada KPI card di atas sinkron",
            "Filter bekerja akurat sesuai kategori stok; badge warna status sesuai aturan bisnis",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-BOX-05",
            "TS-02 Katalog & Registrasi",
            "Menampilkan Dialog QR Code Box dan Salin UUID ke Clipboard",
            "Positif",
            "Kartu box tampil di katalog",
            "1. Ketuk tombol 'QR Code' pada salah satu kartu box\n2. Periksa tampilan dialog QR\n3. Ketuk teks UUID untuk menyalin",
            "Kartu Box terpilih",
            "Tampil modal dialog QR Code beresolusi tinggi dengan data UUID box, nama, dimensi, dan notifikasi 'UUID Box copied to clipboard!' saat diketuk",
            "QR Code ter-render sempurna menggunakan qr_flutter, tombol salin berhasil menyalin teks UUID ke clipboard sistem",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-BOX-06",
            "TS-02 Katalog & Registrasi",
            "Penghapusan item box dari inventaris dengan dialog konfirmasi keamanan (Positif)",
            "Positif",
            "Petugas login; Kartu box tampil di katalog",
            "1. Ketuk ikon tong sampah (Hapus Box) pada kartu box atau lembar detail\n2. Periksa modal dialog konfirmasi kaca\n3. Ketuk tombol 'Hapus Box'",
            "Box target penghapusan",
            "Data box dan seluruh transaksi terkait dihapus dari Supabase (cascade), notifikasi sukses muncul, dan daftar diperbarui",
            "Box berhasil dihapus dari database dan state katalog langsung tersinkronisasi secara realtime",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-BOX-07",
            "TS-02 Katalog & Registrasi",
            "Pembatalan penghapusan box pada modal dialog konfirmasi kaca (Negatif)",
            "Negatif",
            "Petugas login; Kartu box tampil di katalog",
            "1. Ketuk ikon tong sampah (Hapus Box)\n2. Dialog konfirmasi 'Hapus Box dari Sistem?' muncul\n3. Ketuk tombol 'Batal'",
            "Tombol 'Batal'",
            "Dialog tertutup, proses delete dibatalkan, dan data box tetap utuh berada di katalog tanpa perubahan",
            "Dialog konfirmasi tertutup seketika dan data box tidak terhapus",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),

        # TS-03 QR Scanner & Transaksi
        (
            "TC-TRX-01",
            "TS-03 QR Scanner & Transaksi",
            "Scanning QR Code Box menggunakan kamera perangkat",
            "Positif",
            "Izin kamera diberikan; Layar Scanner QR Box terbuka; tersedia QR Code box valid",
            "1. Buka menu 'Scan QR Box'\n2. Arahkan kamera ke QR Code box dalam bingkai kotak bidik",
            "QR Code fisik / gambar berisi UUID Box valid",
            "Scanner mendeteksi barcode (getaran haptic), mengambil data dari Supabase, dan menampilkan BottomSheet Detail Box secara otomatis",
            "Kamera membaca QR code dengan cepat, haptic bergetar, dan BottomSheet transaksi box langsung terbuka",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-TRX-02",
            "TS-03 QR Scanner & Transaksi",
            "Fallback pencarian manual jika kamera tidak dapat memindai",
            "Positif",
            "Layar Scanner QR terbuka",
            "1. Ketuk icon keyboard atau link 'Ketik Kode/UUID Manual'\n2. Masukkan Kode Box atau UUID\n3. Ketuk 'Cari Box'",
            "Input: BOX-STD-001 atau UUID valid",
            "Sistem mencari ke Supabase berdasarkan UUID maupun box_code dan membuka BottomSheet Detail Box yang sesuai",
            "Dialog input manual muncul, data ditemukan, dan detail box terbuka normal tanpa kendala kamera",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-TRX-03",
            "TS-03 QR Scanner & Transaksi",
            "Transaksi Stock IN (Penambahan Stok Masuk Gudang)",
            "Positif",
            "BottomSheet Detail Box terbuka; stok saat ini N unit",
            "1. Pilih tab 'Stock IN (Masuk)'\n2. Tentukan jumlah penambahan (gunakan stepper atau chip +5 / +10)\n3. Ketuk tombol 'Konfirmasi Stock IN'",
            "Aksi: IN, Jumlah: 10 unit",
            "Stok bertambah N + 10 unit, status stok terupdate otomatis, tercatat log di 'Riwayat Transaksi Box Ini', dan muncul notifikasi sukses",
            "Stok bertambah 10 unit di database, indikator kartu dan riwayat transaksi langsung terupdate realtime",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-TRX-04",
            "TS-03 QR Scanner & Transaksi",
            "Transaksi Stock OUT (Pengeluaran Stok dari Gudang)",
            "Positif",
            "BottomSheet Detail Box terbuka; stok saat ini N unit (N >= 3)",
            "1. Pilih tab 'Stock OUT (Keluar)'\n2. Tentukan jumlah barang yang keluar (misal 3 unit)\n3. Ketuk 'Konfirmasi Stock OUT'",
            "Aksi: OUT, Jumlah: 3 unit",
            "Stok berkurang menjadi N - 3 unit, transaksi OUT tercatat pada riwayat, stok di katalog utama otomatis tersinkronisasi",
            "Stok berkurang tepat 3 unit, status stok berubah dinamis jika menyentuh batas low stock, riwayat transaksi tercatat",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
        (
            "TC-TRX-05",
            "TS-03 QR Scanner & Transaksi",
            "Pencegahan Stock OUT melebihi jumlah stok yang tersedia (Over-withdrawal)",
            "Negatif",
            "BottomSheet Detail Box terbuka; box memiliki stok 4 unit",
            "1. Pilih tab 'Stock OUT (Keluar)'\n2. Masukkan jumlah keluar lebih besar dari stok (misal 10 unit)\n3. Periksa tampilan UI dan tombol konfirmasi",
            "Stok ada: 4 unit, Jumlah diminta: 10 unit",
            "Muncul banner peringatan merah 'Jumlah keluar (10) melebihi stok yang ada (4)!', tombol konfirmasi dalam kondisi DISABLED (tidak bisa ditekan)",
            "Tombol konfirmasi disabled secara otomatis dan alert warning merah mencegah terjadinya stok minus",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),

        # TS-04 UI & Desain Visual
        (
            "TC-UI-01",
            "TS-04 UI & Desain Visual",
            "Verifikasi tampilan Glassmorphism (efek kaca) dan logo baru MyWarehouse",
            "Positif",
            "Aplikasi dijalankan pada perangkat Android",
            "1. Buka layar Katalog, Tambah Box, dan BottomSheet Transaksi\n2. Periksa estetika frosted glass blur, specular border, dan logo baru",
            "Elemen GlassContainer dan logo MyWarehouse",
            "Seluruh kartu, modal sheet, dan dialog menampilkan efek kaca buram transparan yang elegan, kontras teks terjaga tajam, dan logo proporsional 1:1",
            "Desain Glassmorphism ter-render sempurna tanpa lag, logo baru MyWarehouse tampil tajam di AppBar dan Login",
            "PASS",
            "-",
            "QA Tester / 06-11-2026"
        ),
    ]

    ref_row_tc = 5
    for i, row_data in enumerate(test_cases, start=5):
        for col_idx, val in enumerate(row_data, start=1):
            cell = ws_tc.cell(row=i, column=col_idx, value=val)
            # Copy style from reference cell
            ref_cell = ws_tc.cell(row=ref_row_tc, column=col_idx)
            cell.font = copy(ref_cell.font)
            cell.border = copy(ref_cell.border)
            cell.fill = copy(ref_cell.fill)
            cell.alignment = copy(ref_cell.alignment)

    max_tc_row = 4 + len(test_cases)
    print(f"Updated Sheet 'Test Case': {len(test_cases)} test cases (rows 5 to {max_tc_row})")

    # ==========================================
    # 3. SHEET: UAT (Row 5 to 15)
    # ==========================================
    ws_uat = wb['UAT']
    uat_scenarios = [
        (
            "UAT-01",
            "Petugas Gudang",
            "Sebagai petugas gudang, saya ingin masuk ke aplikasi dengan akun email dan sandi yang terdaftar agar dapat mengelola data inventaris.",
            "Membuka aplikasi dan login menggunakan akun gudang resmi atau memanfaatkan tombol 'Isi Akun Demo Cepat'.",
            "Aplikasi berhasil login dalam waktu < 5 detik dan langsung menampilkan dashboard katalog box.",
            "Tinggi",
            "PASS",
            5,
            "Proses login sangat cepat, tombol demo cepat sangat membantu saat pengujian di lapangan.",
            "Budi Santoso (Staff Gudang)",
            "06/11/2026"
        ),
        (
            "UAT-02",
            "Petugas Gudang",
            "Sebagai petugas gudang, saya ingin melihat informasi validasi yang jelas jika salah memasukkan format email atau kata sandi.",
            "Mencoba login dengan mengosongkan field atau memasukkan format email tanpa tanda domain.",
            "Pesan peringatan muncul tepat di bawah kolom input dengan bahasa yang jelas dan mudah dimengerti.",
            "Sedang",
            "PASS",
            5,
            "Pesan validasi langsung terlihat dan tidak membuat bingung.",
            "Budi Santoso (Staff Gudang)",
            "06/11/2026"
        ),
        (
            "UAT-03",
            "Supervisor Inventaris",
            "Sebagai supervisor inventaris, saya ingin melihat ringkasan KPI stok box (Total Jenis, Total Unit, Stok Kritis, Habis) secara instan.",
            "Membuka halaman utama katalog box dan mengamati 4 kartu indikator ringkasan di bagian atas layar.",
            "Angka ringkasan akurat sesuai jumlah data di gudang, serta memberi tanda warna mencolok jika ada stok kritis/habis.",
            "Tinggi",
            "PASS",
            5,
            "Sangat informatif, memudahkan pemantauan stok menipis tanpa perlu hitung manual.",
            "Hendra Wijaya (Supervisor)",
            "06/11/2026"
        ),
        (
            "UAT-04",
            "Petugas Gudang",
            "Sebagai petugas gudang, saya ingin mencari box berdasarkan kode, nama, atau lokasi rak tertentu dengan cepat.",
            "Mengetikkan nama barang atau kode rak (misal 'Rak A') pada kotak pencarian di halaman utama.",
            "Daftar box langsung tersaring secara otomatis tanpa jeda, menampilkan box yang sesuai kata kunci.",
            "Tinggi",
            "PASS",
            5,
            "Pencarian realtime sangat responsif dan akurat.",
            "Budi Santoso (Staff Gudang)",
            "06/11/2026"
        ),
        (
            "UAT-05",
            "Supervisor Inventaris",
            "Sebagai supervisor inventaris, saya ingin mendaftarkan tipe box baru beserta dimensi dan langsung mendapatkan QR Code fisiknya.",
            "Membuka menu 'Tambah Box Baru', mengisi spesifikasi dimensi, memilih material, lalu menyimpan data.",
            "Data tersimpan ke database, kapasitas volume terhitung otomatis, dan dialog QR Code langsung muncul di layar.",
            "Tinggi",
            "PASS",
            5,
            "Fitur auto-generate kode box dan live preview volume liter sangat praktis.",
            "Hendra Wijaya (Supervisor)",
            "06/11/2026"
        ),
        (
            "UAT-06",
            "Operator Scanner",
            "Sebagai operator scanner, saya ingin memindai QR Code pada fisik box dengan kamera ponsel secara cepat saat berada di lorong gudang.",
            "Membuka menu 'Scan QR Box' dan mengarahkan kamera ponsel ke QR Code box yang tertempel di rak.",
            "Kamera merespons dengan getaran haptic dan langsung memunculkan lembar informasi detail box.",
            "Tinggi",
            "PASS",
            5,
            "Scanner responsif dan ada tombol lampu senter (torch) yang berguna saat lorong rak gelap.",
            "Agus Pratama (Operator)",
            "06/11/2026"
        ),
        (
            "UAT-07",
            "Petugas Gudang",
            "Sebagai petugas gudang, saya ingin melakukan Stock IN (tambah barang masuk) secara mudah saat ada kiriman baru tiba.",
            "Memilih tab Stock IN pada detail box, memasukkan jumlah unit barang masuk, lalu menekan konfirmasi.",
            "Jumlah stok box bertambah, status ketersediaan diperbarui, dan riwayat transaksi bertambah secara realtime.",
            "Tinggi",
            "PASS",
            5,
            "Tombol quick add (+5, +10) sangat mempermudah input barang dalam jumlah banyak.",
            "Budi Santoso (Staff Gudang)",
            "06/11/2026"
        ),
        (
            "UAT-08",
            "Petugas Gudang",
            "Sebagai petugas gudang, saya ingin sistem menolak pengeluaran barang (Stock OUT) jika jumlahnya melebihi stok yang ada agar tidak minus.",
            "Mencoba melakukan Stock OUT dengan kuantitas yang lebih besar daripada stok aktual di rak.",
            "Tombol konfirmasi terkunci (disabled) dan muncul peringatan bahwa stok tidak mencukupi.",
            "Tinggi",
            "PASS",
            5,
            "Validasi ini sangat penting untuk menjaga integritas data gudang fisik.",
            "Budi Santoso (Staff Gudang)",
            "06/11/2026"
        ),
        (
            "UAT-09",
            "Supervisor Inventaris",
            "Sebagai supervisor inventaris, saya ingin menghapus box yang sudah rusak atau tidak diproduksi lagi disertai konfirmasi keamanan.",
            "Mengetuk ikon tempat sampah pada kartu box, memeriksa rincian box pada dialog peringatan, lalu menekan 'Hapus Box'.",
            "Box terhapus permanen dari Supabase beserta seluruh riwayat transaksi (cascade), muncul notifikasi sukses, dan daftar katalog ter-update realtime.",
            "Tinggi",
            "PASS",
            5,
            "Fitur hapus box sangat aman karena ada konfirmasi pencegah klik tidak sengaja dan otomatis membersihkan transaksi terkait.",
            "Hendra Wijaya (Supervisor)",
            "06/11/2026"
        ),
        (
            "UAT-10",
            "Petugas Gudang",
            "Sebagai petugas gudang, saya ingin dapat membatalkan proses penghapusan box jika saya salah memilih item agar data tidak hilang.",
            "Mengetuk ikon hapus pada box, lalu memilih tombol 'Batal' pada dialog konfirmasi kaca.",
            "Dialog tertutup seketika dan data box tetap utuh berada di katalog tanpa perubahan apa pun.",
            "Sedang",
            "PASS",
            5,
            "Tombol Batal berfungsi normal dan memastikan data box tetap aman di katalog.",
            "Budi Santoso (Staff Gudang)",
            "06/11/2026"
        ),
        (
            "UAT-11",
            "Petugas Gudang",
            "Sebagai pengguna aplikasi mobile, saya ingin tampilan antarmuka modern dengan efek kaca (Glassmorphism), teks mudah dibaca, dan logo baru MyWarehouse yang rapi.",
            "Mengoperasikan aplikasi di berbagai layar (katalog, modal, form input, dialog) dan mengamati kenyamanan visual serta responsivitasnya.",
            "Efek kaca buram (frosted glass) terlihat elegan, kontras teks tetap tajam dan jelas dibaca, logo baru proporsional, serta navigasi mulus tanpa lag.",
            "Sedang",
            "PASS",
            5,
            "Desain efek kaca sangat modern, elegan, tidak silau, dan logo baru warehouse sangat profesional.",
            "Agus Pratama (Operator)",
            "06/11/2026"
        ),
    ]

    ref_row_uat = 5
    for i, row_data in enumerate(uat_scenarios, start=5):
        for col_idx, val in enumerate(row_data, start=1):
            cell = ws_uat.cell(row=i, column=col_idx, value=val)
            ref_cell = ws_uat.cell(row=ref_row_uat, column=col_idx)
            cell.font = copy(ref_cell.font)
            cell.border = copy(ref_cell.border)
            cell.fill = copy(ref_cell.fill)
            cell.alignment = copy(ref_cell.alignment)

    max_uat_row = 4 + len(uat_scenarios)
    print(f"Updated Sheet 'UAT': {len(uat_scenarios)} UAT scenarios (rows 5 to {max_uat_row})")

    # ==========================================
    # 4. SHEET: Bug Report
    # ==========================================
    ws_bug = wb['Bug Report']
    ws_bug['A5'] = "BUG-001"
    ws_bug['B5'] = "[Scanner] Input kode box manual huruf kecil tidak otomatis disamakan case-insensitive"
    ws_bug['C5'] = "TC-TRX-02"
    ws_bug['D5'] = "Android 14 • Samsung Galaxy A52 • WiFi"
    ws_bug['E5'] = "1. Buka Input Manual pada layar scanner\n2. Ketik 'box-std-001' huruf kecil\n3. Ketuk 'Cari Box'"
    ws_bug['F5'] = "Data box ditemukan dan detail box ditampilkan"
    ws_bug['G5'] = "Sistem sempat gagal menemukan data karena pencarian case-sensitive pada kode box"
    ws_bug['H5'] = "Low"
    ws_bug['I5'] = "Low"
    ws_bug['J5'] = "screenshot-bug-001.png"
    ws_bug['K5'] = "Fixed"
    ws_bug['L5'] = "QA Tester"

    # ==========================================
    # 5. SHEET: Rekap & Sign-off (Dynamic Range Formulas)
    # ==========================================
    ws_rekap = wb['Rekap & Sign-off']
    
    # Formulas dynamically pointing to exact max row of Test Case & UAT
    ws_rekap['B5'] = f"=COUNTA('Test Case'!A5:A{max_tc_row})"
    ws_rekap['C5'] = f"=COUNTA('UAT'!A5:A{max_uat_row})"
    ws_rekap['B6'] = f'=COUNTIF(\'Test Case\'!J5:J{max_tc_row},"PASS")'
    ws_rekap['C6'] = f'=COUNTIF(\'UAT\'!G5:G{max_uat_row},"PASS")'
    ws_rekap['B7'] = f'=COUNTIF(\'Test Case\'!J5:J{max_tc_row},"FAIL")'
    ws_rekap['C7'] = f'=COUNTIF(\'UAT\'!G5:G{max_uat_row},"FAIL")'
    ws_rekap['B8'] = f'=COUNTIF(\'Test Case\'!J5:J{max_tc_row},"BLOCKED")'
    ws_rekap['C8'] = f'=COUNTIF(\'UAT\'!G5:G{max_uat_row},"BLOCKED")'
    ws_rekap['C11'] = f'=IFERROR(AVERAGE(\'UAT\'!H5:H{max_uat_row}),"-")'
    ws_rekap['B14'] = f'=COUNTIF(\'UAT\'!F5:F{max_uat_row},"Tinggi")-COUNTIFS(\'UAT\'!F5:F{max_uat_row},"Tinggi",\'UAT\'!G5:G{max_uat_row},"PASS")'
    
    # Signatures
    ws_rekap['A24'] = "(Budi Santoso - Perwakilan Pengguna)"
    ws_rekap['B24'] = "(Ismail Fikron - Tim QA / Tester)"
    ws_rekap['C24'] = "(Triyono M.Kom - Dosen Pengampu)"
    ws_rekap['A25'] = "Tanggal: 06 November 2026"
    ws_rekap['B25'] = "Tanggal: 06 November 2026"
    ws_rekap['C25'] = "Tanggal: 06 November 2026"

    # Save workbook
    wb.save(filename)
    print(f"Successfully saved and updated: {filename}")

if __name__ == '__main__':
    update_uat_workbook()
