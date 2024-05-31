#!/bin/bash
readonly USERNAME=root
readonly PASSWORD=pLIJYGRD123!
readonly DATABASE=lifeline

repositorio="https://github.com/LifeLine-2ADSA/scriptSh/"
sudo apt update
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
# sudo apt install nala -y

# sudo nala install git -y

docker compose up
# sudo docker run -d -p 3306:3306 --name lifelineBD -e "MYSQL_ROOT_PASSWORD=pLIJYGRD123!" vicg0/lifeline-1.0
echo "Digite o email"
read email

echo "Digite a senha"
read senha

sudo docker exec -it lifelineBD bash -c "mysql -u root -p"$PASSWORD" -e 'SELECT * FROM "$DATABASE".usuario where email = \"$email\" AND senha = \"$senha\";'"

#mysql -u root -p
#$PASSWORD
#SELECT * FROM $DATABASE.usuario;
