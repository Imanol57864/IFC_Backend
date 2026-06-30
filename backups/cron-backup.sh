#!/bin/bash

# ==========================================
# PRE-REQUISITOS
# ==========================================

# chmod +x cron-backup.sh
# sudo apt update
# sudo apt install awscli gpg tar -y
# digital ocean cold storage key
# encryption key

# ==========================================
# CONFIGURACIÓN DEL SCRIPT
# ==========================================

# Datos de la base de datos (Ejemplo con MySQL/MariaDB, ajusta según tu BD)
DB_USER="supabase_admin"
DB_NAME="supabase-db"

# Directorio temporal local para procesar el respaldo
BACKUP_DIR="/tmp/db_backups"
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
NOMBRE_RESPALDO="backup_${DB_NAME}_${FECHA}"
BACKEND_DIR="/root/IFC_Backend" # /root = ~/

# Configuración de DigitalOcean Spaces
DO_SPACE_NAME="ifc-backups-01"
DO_REGION="sfo3" 
DO_ENDPOINT="https://${DO_SPACE_NAME}.${DO_REGION}.digitaloceanspaces.com"

# Danger zone
DB_PASS="${DB_PASS:?Falta DB_PASS}"
ENCRYPTION_KEY="${ENCRYPTION_KEY:?Falta ENCRYPTION_KEY}"
DO_ACCESS_KEY="${DO_ACCESS_KEY:?Falta DO_ACCESS_KEY}"
DO_SECRET_KEY="${DO_SECRET_KEY:?Falta DO_SECRET_KEY}"

# ==========================================
# PROCESO DE RESPALDO
# ==========================================

cd ${BACKEND_DIR}
docker compose down
#docker compose up -d supabase-db
mkdir -p ${BACKUP_DIR}
echo "[${FECHA}] Iniciando proceso de respaldo..."

# Consigue los archivos del backup
#docker exec -u postgres supabase-db pg_dump -Fc -U postgres -d postgres > ${BACKUP_DIR}/myfirstbackup.dump
tar --xattrs \
    --acls \
    --preserve-permissions \
    -czvf ${BACKUP_DIR}/storage.tar.gz \
    -C ${BACKEND_DIR}/volumes storage
    
tar --xattrs \
    --acls \
    --preserve-permissions \
    -czvf ${BACKUP_DIR}/data.tar.gz \
    -C ${BACKEND_DIR}/volumes/db data

# Empaquetar todos los respaldos en un solo archivo
tar -cvf ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar \
    -C ${BACKUP_DIR} \
    storage.tar.gz \
    data.tar.gz
    #myfirstbackup.dump \

# ENCRIPTAR el archivo .tar usando GPG (.tar.gpg) (Cifrado simétrico AES-256) (ilegible sin la contraseña) (echo . input stdin)
echo "${ENCRYPTION_KEY}" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar.gpg ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar

# Subir a DigitalOcean Spaces usando AWS CLI apuntando al endpoint de DO
echo "Subiendo a DigitalOcean Spaces..."

export AWS_ACCESS_KEY_ID="${DO_ACCESS_KEY}"
export AWS_SECRET_ACCESS_KEY="${DO_SECRET_KEY}"
export AWS_DEFAULT_REGION="${DO_REGION}"

aws s3api put-object \
  --bucket "${DO_SPACE_NAME}" \
  --key "${NOMBRE_RESPALDO}.tar.gpg" \
  --body "${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar.gpg" \
  --endpoint-url="${DO_ENDPOINT}"

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_DEFAULT_REGION

# 6. Limpieza local (Borrar archivos temporales para no saturar el disco del servidor)
#rm -f ${BACKUP_DIR}/myfirstbackup.dump
rm -f ${BACKUP_DIR}/storage.tar.gz
rm -f ${BACKUP_DIR}/data.tar.gz
rm -f ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar

# Restablecer el servicio de docker backend
docker compose up -d

echo "Backup script exited with status code 0. (Success)"