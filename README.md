# Konfigurasi Rclone ke Google Drive (Cross-Platform)

## 1. Download rclone

| OS          | Langkah                                                                                                                                                          |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Windows** | Kunjungi [rclone.org/downloads](https://rclone.org/downloads/), pilih Windows zip, ekstrak ke folder, misal `C:\rclone\`                                         |
| **macOS**   | Kunjungi [rclone.org/downloads](https://rclone.org/downloads/), pilih macOS zip, ekstrak ke folder, misal `~/rclone/`, lalu jalankan: `chmod +x ~/rclone/rclone` |
| **Linux**   | Kunjungi [rclone.org/downloads](https://rclone.org/downloads/), pilih Linux zip, ekstrak ke folder, misal `~/rclone/`, lalu jalankan: `chmod +x ~/rclone/rclone` |

---

## 2. Jalankan konfigurasi rclone

* **Windows (PowerShell atau CMD):**

```powershell
C:\rclone\rclone.exe config
```

* **macOS / Linux (Terminal):**

```bash
~/rclone/rclone config
```

---

## 3. Buat remote baru

* Pilih `n` → **New remote**
* Masukkan nama remote, misal:

```
name> gdrive
```

---

## 4. Pilih tipe cloud

* Ketik `drive` → **Google Drive**

```
Storage> drive
```

---

## 5. Client ID / Client Secret

* Jika ingin menggunakan default Google API, tekan **Enter**.
* Jika punya client sendiri, masukkan `client_id` dan `client_secret`.

---

## 6. Scope akses

* Pilih `1` → `Full access all files`
  (untuk backup seluruh file ke Drive)

---

## 7. Root folder ID

* Biasanya kosong saja → tekan **Enter**

---

## 8. Service Account

* Pilih `n` → Tidak menggunakan service account

---

## 9. Edit advanced config

* Pilih `n` → Tidak

---

## 10. Autenticasi

* Pilih `y` → Open URL di browser
* Login ke akun Google Drive
* Copy **verification code** dari browser ke terminal

---

## 11. Konfirmasi konfigurasi

* Pilih `y` → Save remote

---

## 12. Uji koneksi

* **Windows:**

```powershell
C:\rclone\rclone.exe lsd gdrive:
```

* **macOS / Linux:**

```bash
~/rclone/rclone lsd gdrive:
```

Jika daftar folder muncul, berarti rclone sudah berhasil terkoneksi dengan Google Drive.

---

## Tips Cross-Platform

* Pastikan **path rclone di script sesuai OS**, misal:

| OS      | Contoh path rclone di script       |
| ------- | ---------------------------------- |
| Windows | `RCLONE="C:\\rclone\\rclone.exe"`  |
| macOS   | `RCLONE="$BASE_DIR/rclone/rclone"` |
| Linux   | `RCLONE="$BASE_DIR/rclone/rclone"` |

* Gunakan nama remote sama dengan yang ada di script backup, misal `gdrive`.
