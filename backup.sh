#!/bin/bash

# =========================
# Konfigurasi utama
# =========================
CONFIG_FILE="./backup_config.conf"
REMOTE_NAME="gdrive"
PART_SIZE="100M"

# =========================
# Lokasi script sebagai base
# =========================
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="$BASE_DIR/backup_$(date +%Y_%m_%d)"
mkdir -p "$TMP_DIR"

# =========================
# Path rclone relatif terhadap script
# =========================
RCLONE="$BASE_DIR/rclone/rclone"
if [ ! -x "$RCLONE" ]; then
    echo "Error: rclone tidak ditemukan atau tidak executable di $RCLONE"
    exit 1
fi

# =========================
# Fungsi parse project
# =========================
parse_project() {
    local section="$1"
    local key="$2"
    grep -A20 "^\[$section\]" "$CONFIG_FILE" | grep "^$key=" | cut -d'=' -f2-
}

# Ambil daftar project
PROJECTS=$(grep '^\[.*\]' "$CONFIG_FILE" | sed 's/^\[\(.*\)\]$/\1/')

for PROJECT_NAME in $PROJECTS; do
    echo "===== Backup project: $PROJECT_NAME ====="
    
    BACKUP_DIR=$(parse_project "$PROJECT_NAME" "path")
    DB_USER=$(parse_project "$PROJECT_NAME" "db_user")
    DB_PASSWORD=$(parse_project "$PROJECT_NAME" "db_password")
    DB_HOST=$(parse_project "$PROJECT_NAME" "db_host")
    DB_PORT=$(parse_project "$PROJECT_NAME" "db_port")
    DB_NAME=$(parse_project "$PROJECT_NAME" "db_name")
    EXCLUDE=$(parse_project "$PROJECT_NAME" "exclude")
    
    DEST_DIR="$TMP_DIR/$PROJECT_NAME"
    SQL_DEST="$DEST_DIR/sql"
    ZIP_DEST="$DEST_DIR/zip"
    mkdir -p "$SQL_DEST" "$ZIP_DEST"
    
    # =========================
    # Dump SQL jika db diisi
    # =========================
    if [[ -n "$DB_NAME" ]]; then
        echo "Dumping database $DB_NAME..."
        mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$SQL_DEST/${DB_NAME}_$(date +%Y_%m_%d).sql"
    fi

    # =========================
    # Zip direktori utama per part
    # =========================
    if [ -d "$BACKUP_DIR" ]; then
        cd "$BACKUP_DIR" || continue
        IFS=',' read -ra EXCLUDE_ARR <<< "$EXCLUDE"
        EXCLUDE_PARAMS=()
        for e in "${EXCLUDE_ARR[@]}"; do
            EXCLUDE_PARAMS+=("-x" "$e/*")
            EXCLUDE_PARAMS+=("-x" "$e")
        done
        echo "Zipping directory $BACKUP_DIR..."
        zip -r -s "$PART_SIZE" "$ZIP_DEST/${PROJECT_NAME}_backup_$(date +%Y_%m_%d).zip" . "${EXCLUDE_PARAMS[@]}"
    else
        echo "Folder $BACKUP_DIR tidak ditemukan, skip zip"
    fi

    # =========================
    # Upload ke Google Drive
    # Struktur: BackupProjects/projectname/tahun_bulan_tanggal/
    # =========================
    echo "Uploading to Google Drive..."

    REMOTE_BASE="$REMOTE_NAME:BackupProjects/$PROJECT_NAME/$(date +%Y_%m_%d)"
    $RCLONE mkdir "$REMOTE_BASE/sql"
    $RCLONE mkdir "$REMOTE_BASE/zip"

    # Upload SQL
    $RCLONE copy "$SQL_DEST/" "$REMOTE_BASE/sql" --progress --stats 1s
    # Upload ZIP
    $RCLONE copy "$ZIP_DEST/" "$REMOTE_BASE/zip" --progress --stats 1s

    # Uncomment jika ingin upload tanpa progress
    #$RCLONE copy "$SQL_DEST/" "$REMOTE_BASE/sql" --progress
    #$RCLONE copy "$ZIP_DEST/" "$REMOTE_BASE/zip" --progress

    echo "Backup project $PROJECT_NAME selesai"
done

# =========================
# Bersihkan temporary
# =========================
rm -rf "$TMP_DIR"
echo "Semua backup selesai."
