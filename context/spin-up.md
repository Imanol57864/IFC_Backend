## GUIA: Spin up Droplet

```bash
# linux 
sudo apt update
sudo apt upgrade
sudo reboot

# docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
docker --version

# docker compose plugin
sudo apt install docker-compose-plugin -y
docker compose version

# git
sudo apt install git
git --version

# subnet compose
docker network create ifc

# backups plugin
sudo apt install unzip gpg tar -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# git clone
git clone --branch <branch> --single-branch <git url>
git clone 
chmod +x cron-backup.sh
```