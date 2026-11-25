# Portfolio Pribadi

Aplikasi portofolio pribadi berbasis Flutter yang melanjutkan Tutorial 08 dan Tutorial 09. Proyek ini terhubung ke backend Django REST Framework dari Tutorial 07 melalui token API. Pengguna dapat melihat daftar proyek, membuka detail, login, menambahkan proyek, dan logout. Formulir Pendidikan yang sudah ada tetap tersedia.

## Menjalankan aplikasi

Pastikan Flutter SDK sudah terpasang, lalu jalankan perintah berikut dari folder proyek:

```powershell
flutter pub get
dart run build_runner build
flutter run
```

Android Emulator menggunakan `http://10.0.2.2:8000` secara default. Untuk Flutter Web, jalankan dengan URL backend lokal:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

Endpoint yang digunakan adalah `GET` dan `POST /api/v1/projects/`, `POST /api/v1/auth/token/`, serta `POST /api/v1/auth/logout/`. Backend perlu mengaktifkan TokenAuthentication, CORS untuk Flutter Web, dan mengizinkan host emulator seperti dijelaskan di Tutorial 10. Izin cleartext Android di manifest ini ditujukan untuk pengembangan lokal; backend produksi sebaiknya memakai HTTPS.

Workflow `.github/workflows/ci.yml` menjalankan build dan analisis Flutter, menghasilkan serializer JSON, membangun APK release setelah job build berhasil, lalu menyimpan APK sebagai artefak `app-release-apk`. Isi GitHub Actions repository variable `API_BASE_URL` dengan alamat backend HTTPS jika APK CI harus menunjuk ke backend deploy. Jika kosong, build memakai alamat emulator lokal dari Tutorial 10.

Untuk memeriksa kode, jalankan:

```powershell
flutter analyze
```

## Data pemilik

- **NPM:** 2506547153
- **Nama:** Stephanie Tamus
- **Kelas:** PBP C

### Tugas 7

1. **Widget tree** adalah susunan widget bertingkat yang membentuk antarmuka. Pada aplikasi ini, `MyApp` memasang `MaterialApp`, yang menampilkan `MyHomePage`. Halaman itu menyusun `Scaffold`, `AppBar`, dan isi halaman; isinya kemudian tersusun lagi dari kartu profil, teks sambutan, dan kartu aksi. Widget induk menentukan struktur dan batas tata letak bagi anaknya, sedangkan widget anak membentuk bagian yang lebih kecil. Dengan komposisi ini, antarmuka dapat dipecah menjadi bagian yang mudah dipahami dan digunakan kembali.

2. Widget yang digunakan dalam proyek ini meliputi:
   - **Widget buatan proyek:** `MyApp` membangun aplikasi, `MyHomePage` menyusun halaman utama, `InfoCard` menampilkan satu informasi profil, dan `ItemCard` menampilkan satu aksi yang bisa ditekan.
   - **Widget Material dan konten:** `MaterialApp` menyediakan kerangka aplikasi Material; `Scaffold` menyediakan struktur halaman; `AppBar` menampilkan bilah atas; `Card` membungkus informasi; `Material` menyediakan permukaan untuk kartu aksi; `Text` menampilkan tulisan; `Icon` menampilkan simbol; dan `SnackBar` memberi umpan balik singkat setelah kartu aksi ditekan.
   - **Widget tata letak dan interaksi:** `SafeArea` menjaga isi dari area sistem; `SingleChildScrollView` memungkinkan halaman digulir; `Padding` memberi jarak; `Column` dan `Row` menyusun anak secara vertikal dan horizontal; `Expanded` membagi lebar kartu profil; `SizedBox` memberi jarak; `FittedBox` mengecilkan teks profil agar tetap muat; `GridView` menyusun kartu aksi dalam kisi; `Center` menempatkan isi di tengah; dan `InkWell` menangani sentuhan serta efek riak.

3. `MaterialApp` mengatur dasar sebuah aplikasi Material, seperti tema dan navigasi, lalu menyediakan halaman awal melalui properti `home`. Widget ini umum dipakai sebagai root karena konfigurasi tersebut dapat diakses oleh halaman-halaman di bawahnya. Pada proyek ini, `MaterialApp` menetapkan tema aplikasi dan menampilkan `MyHomePage`.

4. `StatelessWidget` cocok untuk UI yang hanya bergantung pada konfigurasi tetap dan `BuildContext`; widget ini tidak menyimpan state yang dapat berubah. `StatefulWidget` memiliki objek `State` untuk data yang berubah selama aplikasi berjalan, misalnya nilai formulir atau pilihan yang perlu diperbarui dengan `setState`. `MyHomePage`, `InfoCard`, dan `ItemCard` menggunakan `StatelessWidget` karena data tampilannya diberikan sebagai konfigurasi. Jika nanti halaman perlu mengelola formulir tambah proyek atau daftar proyek yang berubah, bagian tersebut dapat menggunakan `StatefulWidget`.

5. `BuildContext` menunjukkan posisi suatu widget di dalam widget tree dan menyediakan akses ke informasi dari widget induk. Di dalam `build`, konteks dipakai untuk mencari tema terdekat dengan `Theme.of(context)`. Pada `ItemCard`, konteks juga dipakai oleh `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar` pada halaman yang menaunginya. Konteks sebaiknya digunakan saat diperlukan dan tidak disimpan untuk dipakai kemudian. [Dokumentasi BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Hot reload** memasukkan perubahan kode Dart dan membangun ulang UI sambil mempertahankan state aplikasi; proses ini tidak menjalankan ulang `main()` atau `initState()`. **Hot restart** menjalankan ulang aplikasi Flutter dari `main()` sehingga state aplikasi direset. **Full restart** menghentikan dan menjalankan kembali aplikasi beserta proses platform-nya. Hot reload biasanya cukup untuk perubahan tampilan atau logika Dart. Gunakan hot restart saat perubahan pada `main()` atau nilai inisialisasi global/static perlu diterapkan. Gunakan full restart setelah perubahan kode native Android/iOS atau konfigurasi platform yang memerlukan kompilasi ulang. [Dokumentasi hot reload Flutter](https://docs.flutter.dev/tools/hot-reload).

### Tutorial 09

- `lib/screens/menu.dart` berisi halaman utama dan kartu aksi.
- `lib/screens/project_form.dart` berisi formulir proyek. Nama dan deskripsi wajib diisi; kategori memiliki pilihan bawaan; teknologi dan tautan bersifat opsional.
- `lib/widgets/left_drawer.dart` menyediakan navigasi Home dan Add Project. Drawer tersedia di halaman utama maupun formulir.
- `lib/widgets/project_card.dart` menangani tampilan kartu dan navigasi dari **Tambah Proyek** ke formulir.
- Menekan **Save** menampilkan ringkasan proyek. Tombol **OK** menutup dialog dan mengosongkan formulir.

### Tugas 8

1. `Navigator.push()` menambahkan halaman baru ke atas navigation stack sehingga halaman sebelumnya masih bisa dibuka dengan tombol kembali. `Navigator.pushReplacement()` mengganti halaman teratas dan menghapus halaman sebelumnya dari stack, sedangkan `Navigator.pop()` menutup halaman teratas. Kartu **Tambah Pendidikan** menggunakan `Navigator.push()`. Opsi **Home** di drawer menggunakan `Navigator.pushReplacement()` untuk membuka halaman utama, termasuk saat formulir pendidikan sedang terbuka.

2. `Scaffold` memberi struktur halaman yang konsisten untuk `AppBar`, `Drawer`, dan isi. Drawer yang sama dipakai di halaman utama dan kedua formulir. Warna `colorScheme.primary` dari tema aplikasi dipakai pada `AppBar` dan tombol simpan, sehingga elemen tersebut konsisten di beberapa halaman.

3. Formulir disusun dalam `Column` dengan `SizedBox` untuk memberi jarak antarinput. `SingleChildScrollView` membuat seluruh kolom dan tombol **Simpan** tetap dapat dijangkau saat ruang layar terbatas atau papan ketik tampil.

4. `GlobalKey<FormState>` menyediakan akses ke state `Form`. Setiap `validator` memeriksa nilai pada kolomnya, lalu `validate()` menjalankan semua validator ketika **Simpan** ditekan. Contohnya, nama institusi yang hanya berisi spasi ditolak. Pemilihan papan ketik saja tidak cukup untuk menolak masukan kosong atau memastikan tanggal selesai tidak mendahului tanggal mulai.

Halaman Pendidikan menggunakan lima input: institusi, gelar, program studi, tanggal mulai, dan tanggal selesai. Tanggal dipilih melalui `showDatePicker()`. Isian ringkasan hanya ditampilkan setelah seluruh validasi berhasil.

## Penggunaan AI

- **Alat:** OpenAI Codex.
- **Log prompt (ringkas):** Codex diminta membaca `tutorial-10.pdf` dan menerapkan bagian yang sesuai pada proyek Flutter ini.
- **Bagian yang dibantu AI:** integrasi API Django REST Framework, model dan serialisasi JSON, daftar serta detail proyek, login/logout token, validasi dan pengiriman formulir proyek, serta workflow CI untuk membangun APK.
- **Pemeriksaan:** `dart format lib`, code generation dengan `build_runner`, dan `dart analyze lib` berhasil; analyzer melaporkan tidak ada isu. Test suite dan alur end-to-end dengan backend belum dijalankan.
- **Batasan dan tinjauan:** backend Django tidak berada di workspace ini. Endpoint, autentikasi, dan permintaan jaringan perlu dicoba bersama backend yang sudah dikonfigurasi sesuai Tutorial 10.
