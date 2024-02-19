 <p align="center">
  <a href="" rel="noopener">
 <img src="https://raw.githubusercontent.com/numen111104/absensi_flutter/master/preview.jpg" alt="Project logo" width='1080' height="700"></a>
</p>
<h3 align="center">Aplikasi Absensi Karyawan with Flutter + Laravel</h3>

<div align="center">

![Numenide](https://img.shields.io/badge/absensi-flutter?style=for-the-badge&logo=flutter&logoColor=B7C9F2&label=flutter&labelColor=FFF67E&color=B7C9F2)
![Static Badge](https://img.shields.io/badge/tugas-kampus?style=for-the-badge&logo=school&logoColor=416D19&label=IDN&labelColor=FFF67E&color=B7C9F2)

</div>

---

<p align="center"> Tugas ke 14 dari pak Dedi Gunawan MT. CCIE.
    <br> 
</p>

## 📝 Table of Contents

- [Dependencies / Limitations](#packages)
- [Setting up a local environment](#getting_started)
- [Technology Stack](#tech_stack)
- [Contributing](../CONTRIBUTING.md)
- [Authors](#authors)

## ⛓️ Dependencies / packages <a name = "packages"></a>

Projek ini membutuhkan beberapa dependensi tambahan sbg berikut:

- cupertino_icons: ^1.0.6
- google_fonts: ^6.1.0
- location: ^5.0.3
- syncfusion_flutter_maps: ^24.2.6
- shared_preferences: ^2.2.2
- http: ^1.2.0

## 🏁 Getting Started <a name = "getting_started"></a>

Sebelum mengisntall pastikan sudah menginstall kotlin versi terbaru di `android/build.gradle`

### Flutter project

1. clone projek git ini di local storage anda

```
git clone https://github.com/numen111104/absensi_flutter.git
```

2. update dependenci dari projek ini

```
flutter pub get
```

### set back-end

Anda dapat menggunakan api yang sudah terhosting dari https://cek-wa.com/presensi/public/
atau anda bisa juga menginstall api anda di local server anda menggunakan hotspot, berikut adalah caranya:

1. Pastikan hotspot portable sudah tersambung di laptop anda, kemudian cek ipv4 addres nya dengan cara mengetik perintah `ipconfig` di cmd, dan salin. Contoh

```
Wireless LAN adapter WiFi:

   ...
   ...
   IPv4 Address. . . . . . . . . . . : 172.18.20.59
   ...
   ....
```

2. fork project backendnya dari repositori milik pak adji [@SeptiawanAjiP](https://github.com/SeptiawanAjiP) dan clone repositorinya

```
git clone https://github.com/SeptiawanAjiP/presensi-backend.git
```

3. Update Composer dan dependensi lainnya, kemudian copy .env.example dan ubah namanya menjadi .env

```
composer update
cp .env.example .env
php artisan key:generate
```

4. Setting database dan lain-lain pada file .env
5. Jalankan projek ke server lokal menggunakan addres IPv4 yang tadi sudah dicek, pastikan itu laptop anda sudah terhubung ke hotspot yang sama dengan hp yang anda gunakan sebagai debugger

```
php artisan serve --host:172.18.20.59 --port:8000
```

## ⛏️ Built With <a name = "tech_stack"></a>

- [MySQL](https://www.mysql.com/) - Database
- [Laravel](https://laravel.com/) - Server Framework
- [Flutter](https://docs.flutter.dev/) - Mobile Framework
- [Apache](https://apache.org/) - Server Environment

## ✍️ Authors <a name = "authors"></a>

- [@SeptiawanAjiP](https://github.com/SeptiawanAjiP) - API Maker
- [@numen111104](https://github.com/numen111104) - Flutter Design

Lihat detail [Kontributor](https://github.com/SeptiawanAjiP/presensi-backend/graphs/contributors)
yang ikut andil dalam projek ini.
