## GUIA: Setup a cron job

### Setup
```bash
# install cron
apt install cron
sudo systemctl status cron

# check the system's datetime
timedatectl

# create a new task (a cron tab)
crontab -e

# check cron logs (options)
journalctl -u cron
grep CRON /var/log/syslog
tail /var/log/syslog

# last implemenetation (3am every 1st of the month)
0 3 1 * * DB_PASS="" DO_ACCESS_KEY="" DO_SECRET_KEY="" ENCRYPTION_KEY="" /root/IFC_Backend/backups/cron-backup.sh
/tmp
```
```
* * * * * comando
│ │ │ │ │
│ │ │ │ └── Día de la semana (0-7, 7 = Domingo)
│ │ │ └──── Mes (1-12)
│ │ └────── Día del mes (1-31)
│ └──────── Hora (0-23)
└────────── Minuto (0-59)
```

### Ejemplos

```bash
crontab -e          # Editar tareas
crontab -l          # Listar tareas
crontab -r          # Eliminar tareas
systemctl status cron
systemctl start cron
systemctl restart cron

# Todos los lunes a las 09:00
0 9 * * 1 /root/reporte.sh

# Primer día de cada mes
0 0 1 * * /root/mensual.sh

# Ejecutarlo todos los días a las 03:30 y guardar el resultado en un log
30 3 * * * /root/script.sh >> /root/logs/script.log 2>&1
```