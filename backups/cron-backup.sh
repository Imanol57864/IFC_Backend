#!/bin/bash

# ==========================================
# PRE-REQUISITOS
# ==========================================

# sudo apt update
# sudo apt install awscli gpg tar -y
# digital ocean cold storage key
# encryption key

# ==========================================
# CONFIGURACIÓN DEL SCRIPT
# ==========================================

# Datos de la base de datos (Ejemplo con MySQL/MariaDB, ajusta según tu BD)
DB_USER=""
DB_PASS=""
DB_NAME=""

# Directorio temporal local para procesar el respaldo
BACKUP_DIR="/tmp/db_backups"
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
NOMBRE_RESPALDO="backup_${DB_NAME}_${FECHA}"
BACKEND_DIR="" # /home/ubuntu = ~/

# Configuración de DigitalOcean Spaces
DO_SPACE_NAME=""
DO_REGION="" 
DO_ENDPOINT="https://${DO_SPACE_NAME}.${DO_REGION}.digitaloceanspaces.com"

# Almacena esta clave en un lugar seguro (como un gestor de contraseñas), la necesitarás para restaurar.
ENCRYPTION_KEY=""

# ==========================================
# PROCESO DE RESPALDO
# ==========================================

docker compose down
mkdir -p ${BACKUP_DIR}
echo "[${FECHA}] Iniciando proceso de respaldo..."

# docker exec -it supabase-db bash
# pg_dump -Fc -U postgres -d postgres -f /tmp/myfirstbackup.dump
docker exec -u postgres supabase-db pg_dump -Fc -U postgres -d postgres > ${BACKUP_DIR}/myfirstbackup.dump
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
    myfirstbackup.dump \
    storage.tar.gz \
    data.tar.gz

# ENCRIPTAR el archivo .tar usando GPG (.tar.gpg) (Cifrado simétrico AES-256) (ilegible sin la contraseña) (echo . input stdin)
echo "${ENCRYPTION_KEY}" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar.gpg ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar

# 5. Subir a DigitalOcean Spaces usando AWS CLI apuntando al endpoint de DO
echo "Subiendo a DigitalOcean Spaces..."
aws s3 cp ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar.gpg s3://${DO_SPACE_NAME}/${NOMBRE_RESPALDO}.tar.gpg --endpoint-url=${DO_ENDPOINT} --acl private

# 6. Limpieza local (Borrar archivos temporales para no saturar el disco del servidor)
rm -f ${BACKUP_DIR}/myfirstbackup.sql
rm -f ${BACKUP_DIR}/storage.tar.gz
rm -f ${BACKUP_DIR}/data.tar.gz
rm -f ${BACKUP_DIR}/${NOMBRE_RESPALDO}.tar

# Restablecer el servicio de docker backend
docker compose up -d

echo "Backup script exited with status code 0. (Success)"