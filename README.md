# Portfolio Pribadi

Aplikasi portofolio pribadi berbasis Flutter yang melanjutkan proyek Tutorial 08. Halaman utamanya menampilkan informasi mahasiswa dan tiga kartu aksi: **Lihat Proyek**, **Tambah Proyek**, dan **Logout**. Setiap kartu memiliki warna dan ikon sendiri, lalu menampilkan `SnackBar` saat ditekan.

## Menjalankan aplikasi

Pastikan Flutter SDK sudah terpasang, lalu jalankan perintah berikut dari folder proyek:

```powershell
flutter pub get
flutter run
```

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

## Penggunaan AI

- **Alat:** OpenAI Codex.
- **Log prompt (ringkas):** memberikan brief `tugas-7.pdf` dan meminta implementasi Tugas 7 dilanjutkan di repositori Flutter yang sudah ada, termasuk jawaban reflektif di README.
- **Bagian yang dibantu AI:** penambahan warna dan ikon berbeda untuk setiap `ItemHomepage`, penyesuaian tampilan kartu profil pada layar sempit, serta penyusunan draf jawaban enam pertanyaan reflektif dan dokumentasi proyek.
- **Pemeriksaan:** kode diperiksa dengan `flutter analyze`. Jawaban refleksi perlu saya baca ulang dan sesuaikan dengan pemahaman serta pengalaman praktik saya sebelum dikumpulkan.
- **Batasan:** penjelasan AI dapat terlalu umum; terutama uraian pengalaman praktik, saya perlu memastikan sendiri bahwa isinya sesuai dengan apa yang benar-benar saya kerjakan dan pahami.
