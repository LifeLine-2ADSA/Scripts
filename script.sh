#!/bin/bash
readonly USERNAME=root
readonly PASSWORD=urubu100
readonly DATABASE=lifeline

repositorio="https://github.com/LifeLine-2ADSA/JAR-LifeLine.git"
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
sudo apt install nala -y

sudo nala install git -y
docker compose down
docker compose up
docker start lifelineBD > /dev/null
# sudo docker run -d -p 3306:3306 --name lifelineBD -e "MYSQL_ROOT_PASSWORD=$PASSWORD" vicg0/lifeline-1.0

LOGIN=0
touch docker.env
while [ "$LOGIN" -eq 0 ]; do
echo "Digite o email"
read email

echo "Digite a senha"
read senha

query=$(sudo docker exec -it lifelineBD bash -c "MYSQL_PWD="$PASSWORD" mysql --batch -u root -D "$DATABASE" -e 'SELECT idUsuario, email, senha FROM usuario where email = \"$email\" AND senha = \"$senha\" LIMIT 1;'")

if [ -z "$query" ]; then
echo "Usuário não encontrados"

else

echo "Login efetuado com sucesso"
LOGIN=1
sleep 3

ID=$(echo "EMAIL=$query" | awk 'NR == 2 {print $1}')
EMAIL=$(echo "EMAIL=$query" | awk 'NR == 2 {print $2}')
SENHA=$(echo "EMAIL=$query" | awk 'NR == 2 {print $3}')

echo "ID=$ID" > docker.env
echo "EMAIL=$EMAIL" >> docker.env
echo "SENHA=$SENHA" >> docker.env

fi
done
#sudo nala install openjdk-17-jre -y

#rm -rf JAR-lifeLine
#git clone "$repositorio"
#cd JAR-LifeLine
#cd lifeline
#cd target
#java -jar lifeline-1.0-SNAPSHOT-jar-with-dependencies.jar

#mysql -u root -p
#$PASSWORD
#SELECT * FROM $DATABASE.usuario;
