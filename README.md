## GUIA: Spin up Droplet

```
sudo apt update
sudo apt upgrade
sudo reboot

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
docker --version

# Docker Compose plugin
sudo apt install docker-compose-plugin -y
docker compose version
# Git
sudo apt install git
git --version

# subnet compose
docker network create ifc

# git clone
git clone --branch <branch> --single-branch <git url>
git clone 
```

## GUIA: Migration

<aside>

Exporta la base:

```
# outside container
docker exec -it supabase-db bash

# inside container
pg_dump -Fc -U postgres -d postgres -f /tmp/myfirstbackup.dump
exit

# outside container
docker cp supabase-db:/tmp/myfirstbackup.dump ~/

# backend composer
docker compose down

# at root, get exactly (volumes/db/data && volumes/storage)
tar -czvf storage.tar.gz -C ~/ifc_app/Plataforma_IFC/backend/volumes storage
tar -czvf data.tar.gz -C ~/ifc_app/Plataforma_IFC/backend/volumes/db data
exit

# inside La Carpeta Emisora
cd Desktop/migration01
scp root@IP_DROPLET:~/myfirstbackup.dump .
scp root@IP_DROPLET:~/storage.tar.gz .
scp root@IP_DROPLET:~/data.tar.gz .
```

En el nuevo servidor, después de clonar el repositorio:

```
cd migration01

# inside La Carpeta Emisora
scp -i "~/.ssh/KEY_CREADA" -r "C:\RUTA_CARPETA_EMISORA" root@IP_DROPLET:~/
ssh -i ~/.ssh/KEY_CREADA root@IP_DROPLET

# inside new droplet, descomprimir en carpeta destino
tar -xzf ~/migration01/storage.tar.gz -C ~/IFC_Backend/volumes
tar -xzf ~/migration01/data.tar.gz -C ~/IFC_Backend/volumes/db

# después de copiar .env, levanta docker
docker exec -i supabase-db pg_restore -U **supabase_admin** -d postgres < ~/migration01/myfirstbackup.dump
```

Y luego solamente:

```
- recuerda borrar la carpeta de migración porque es storage no usado
```

</aside>