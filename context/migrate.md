## GUIA: Migration

### Encrypted (up-to-date)

```bash
scp -i "~/.ssh/KEY_CREADA" -r "C:\RUTA_CARPETA_EMISORA" root@IP_DROPLET:~/

# at /root 
gpg --decrypt backup_supabase-db_date.tar.gpg | tar -xf -
tar --xattrs --acls -xzvf ~/storage.tar.gz -C ~/IFC_Backend/volumes
tar --xattrs --acls -xzvf ~/data.tar.gz -C ~/IFC_Backend/volumes/db

# recuerda remover los archivos .tar y .gpg
```

### Deprecated

<aside>

Exporta la base:

```bash
# outside container
docker exec -it supabase-db bash

# error, apaga los servicios de escritura antes de dumping
docker compose down
docker compose up -d supabase-db

# inside container
pg_dump -Fc -U postgres -d postgres -f /tmp/myfirstbackup.dump
exit

# outside container
docker cp supabase-db:/tmp/myfirstbackup.dump ~/

# backend composer
docker compose down

# at root, get exactly (volumes/db/data and volumes/storage)
tar --xattrs \
    --acls \
    --preserve-permissions \
    -czvf storage.tar.gz \
    -C ~/IFC_Backend/volumes storage
    
tar --xattrs --acls -czvf data.tar.gz \
  -C ~/IFC_Backend/volumes/db data

# inside La Carpeta Emisora
cd Desktop/migration01
scp -i ~/.ssh/KEY_CREADA root@IP_DROPLET_ORIGEN:~/myfirstbackup.dump .
scp -i ~/.ssh/KEY_CREADA root@IP_DROPLET_ORIGEN:~/storage.tar.gz .
scp -i ~/.ssh/KEY_CREADA root@IP_DROPLET_ORIGEN:~/data.tar.gz .
```

En el nuevo servidor, después de clonar el repositorio:

```
cd migration01

# inside La Carpeta Emisora
scp -i "~/.ssh/KEY_CREADA" -r "C:\RUTA_CARPETA_EMISORA" root@IP_DROPLET:~/
ssh -i ~/.ssh/KEY_CREADA root@IP_DROPLET

# inside new droplet, descomprimir en carpeta destino
tar --xattrs --acls -xzvf ~/migration01/storage.tar.gz -C ~/IFC_Backend/volumes
tar --xattrs --acls -xzvf ~/migration01/data.tar.gz -C ~/IFC_Backend/volumes/db

# después de copiar .env, levanta docker
docker exec -i supabase-db pg_restore -U **supabase_admin** -d postgres < ~/migration01/myfirstbackup.dump
```

Y luego solamente:

```
- recuerda borrar la carpeta de migración porque es storage no usado
```

</aside>

- Si existe un estándar MinIO y S3 como file managers, porque los conservan mucho mejor al parecer.
- Bug que mejoró los backups:
    
    ```markdown
    - Se rompió la liga de consultar archivo
    - entonces el problema suele estar en la capa de Storage API, URL pública, proxy reverso (Nginx/Traefik/Caddy)
    "raw":"{\"code\":\"ENODATA\",\"errno\":61}"
    "message":"The extended attribute does not exist."
    - docker compose logs -f storage
    ```