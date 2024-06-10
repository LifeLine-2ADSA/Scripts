#!/bin/bash

# Definição de variáveis constantes para acesso ao banco de dados
readonly USERNAME=root
readonly PASSWORD=urubu100
readonly DATABASE=lifeline

# URL do repositório Git onde o projeto está localizado
repositorio="https://github.com/LifeLine-2ADSA/scriptDocker.git"

# Atualiza as listas de pacotes disponíveis e instala ferramentas necessárias
sudo apt update
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Criação de diretório para armazenar chaves de repositório e download da chave GPG do Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório do Docker às fontes do APT
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza novamente as listas de pacotes após adicionar o repositório do Docker
sudo apt-get update

# Instalação de ferramentas Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Instalação de outras dependências
sudo apt install -y nala git


# Instalação do Docker Compose diretamente do binário
sudo curl -L "https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Inicia o serviço do Docker, caso não esteja em execução
sudo systemctl start docker

# Verifica se o Docker Daemon está em execução
echo "Aguardando o Docker iniciar..."
while ! sudo systemctl is-active --quiet docker; do
    printf "."
    sleep 2
done
echo "Docker iniciado com sucesso."

git clone $repositorio
cd scriptDocker

# Derruba e inicia os contêineres usando o Docker Compose
docker-compose down
docker-compose up -d db

# Aguarda o contêiner do banco de dados estar totalmente operacional
echo "Aguardando o banco de dados iniciar..."
until docker exec db_container mysqladmin ping -h "127.0.0.1" --silent; do
    printf "."
    sleep 2
done

# Loop para realizar o login com as credenciais fornecidas pelo usuário
LOGIN=0
touch .env
while [ "$LOGIN" -eq 0 ]; do
  echo "Digite o email"
  read email

  echo "Digite a senha"
  read senha

  # Executa uma consulta SQL no banco de dados
  query=$(sudo docker exec db_container bash -c "MYSQL_PWD="$PASSWORD" mysql --batch -u root -D "$DATABASE" -e 'SELECT idUsuario, email, senha FROM usuario where email = \"$email\" AND senha = \"$senha\" LIMIT 1;'")

  # Verifica se o usuário foi encontrado no banco de dados
  if [ -z "$query" ]; then
    echo "Usuário não encontrado"
  else
    # Exibe mensagem de login bem-sucedido e configura as variáveis de ambiente
    echo "Login efetuado com sucesso"
    LOGIN=1
    sleep 3

    # Extrai o ID, email e senha do resultado da consulta SQL
    ID=$(echo "$query" | awk 'NR == 2 {print $1}')
    EMAIL=$(echo "$query" | awk 'NR == 2 {print $2}')
    SENHA=$(echo "$query" | awk 'NR == 2 {print $3}')

    # Salva as variáveis de ambiente em um arquivo .env
    echo "ID=$ID" > .env
    echo "EMAIL=$EMAIL" >> .env
    echo "SENHA=$SENHA" >> .env
  fi
done

# Derruba os contêineres existentes e inicia novamente o contêiner do aplicativo com as novas variáveis de ambiente
docker-compose down
docker-compose up app
