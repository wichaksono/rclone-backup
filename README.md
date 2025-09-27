# Download Rclone

* Situs resmi: [https://rclone.org/downloads/](https://rclone.org/downloads/)
* Pilih OS → ekstrak ke folder `backup/rclone/os/`
* Pastikan executable:

```bash
chmod +x backup/rclone/macos/rclone    # macOS
chmod +x backup/rclone/linux/rclone    # Linux
# Windows sudah executable (.exe)
```

# Struktur Folder Project

```
backup/
├─ backup.sh
├─ backup_config.conf
└─ rclone/
   ├─ macos/
   │   └─ rclone
   ├─ linux/
   │   └─ rclone
   └─ windows/
       └─ rclone.exe
```

# Jalankan Konfigurasi Rclone

**macOS / Linux:**

```bash
./rclone/rclone/macos/rclone config
./rclone/rclone/linux/rclone config
```

**Windows (PowerShell):**

```powershell
.\rclone\windows\rclone.exe config
```

# Buat Remote Baru

1. Pilih `n` → New remote
2. Masukkan nama remote:

```
name> gdrive
```

# Pilih Tipe Cloud

```
Storage> drive
```

# Client ID / Secret

* Tekan **Enter** untuk default Google API atau isi jika punya client sendiri.

# Scope Akses

* Pilih `1` → Full access all files

# Root Folder ID

* Kosong → tekan **Enter**

# Service Account

* Pilih `n` → Tidak menggunakan service account

# Advanced Config

* Pilih `n` → Tidak

# Autentikasi

* Pilih `y` → Open URL di browser
* Login ke Google Drive
* Copy **verification code** ke terminal

# Konfirmasi

* Pilih `y` → Save remote

# Uji Koneksi

**macOS / Linux:**

```bash
./rclone/rclone/macos/rclone lsd gdrive:
./rclone/rclone/linux/rclone lsd gdrive:
```

**Windows:**

```powershell
.\rclone\windows\rclone.exe lsd gdrive:
```

# Integrasi dengan backup.sh

```bash
# macOS
RCLONE="$BASE_DIR/rclone/macos/rclone"

# Linux
RCLONE="$BASE_DIR/rclone/linux/rclone"

# Windows (PowerShell)
RCLONE="$BASE_DIR\rclone\windows\rclone.exe"
```

* Nama remote harus sama (`gdrive`)
* Upload backup ke: `BackupProjects/projectname/tahun_bulan_tanggal/`
