#!/bin/bash
readonly USERNAME=root
readonly PASSWORD=urubu100
readonly DATABASE=lifeline

repositorio="https://github.com/LifeLine-2ADSA/JAR-LifeLine.git"
sudo apt update
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt install -y nala git

# Usar o Docker Compose a partir do binário
sudo curl -L "https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Iniciar Docker se não estiver em execução
sudo systemctl start docker

# Verificar se o Docker Daemon está em execução
echo "Aguardando o Docker iniciar..."
while ! sudo systemctl is-active --quiet docker; do
    printf "."
    sleep 2
done
echo "Docker iniciado com sucesso."

docker-compose down
docker-compose up -d db

# Aguarda o contêiner do banco de dados estar totalmente operacional
echo "Aguardando o banco de dados iniciar..."
until docker exec db_container mysqladmin ping -h "127.0.0.1" --silent; do
    printf "."
    sleep 2
done

LOGIN=0
touch .env
while [ "$LOGIN" -eq 0 ]; do
  echo "Digite o email"
  read email

  echo "Digite a senha"
  read senha

  query=$(sudo docker exec db_container bash -c "MYSQL_PWD="$PASSWORD" mysql --batch -u root -D "$DATABASE" -e 'SELECT idUsuario, email, senha FROM usuario where email = \"$email\" AND senha = \"$senha\" LIMIT 1;'")

  if [ -z "$query" ]; then
    echo "Usuário não encontrado"
  else
    echo "Login efetuado com sucesso"
    LOGIN=1
    sleep 3

    ID=$(echo "$query" | awk 'NR == 2 {print $1}')
    EMAIL=$(echo "$query" | awk 'NR == 2 {print $2}')
    SENHA=$(echo "$query" | awk 'NR == 2 {print $3}')

    echo "ID=$ID" > .env
    echo "EMAIL=$EMAIL" >> .env
    echo "SENHA=$SENHA" >> .env
  fi
done

# Reiniciar o serviço do app com as novas variáveis de ambiente
docker-compose down
docker-compose up app
