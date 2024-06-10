#!/usr/bin/env bash
host="$1"
shift
port="$1"
shift

echo "Host: $host, Port: $port"
echo "Aguardando a inicialização do banco de dados em $host:$port..."

while ! nc -z "$host" "$port"; do
  sleep 1
done

echo "Banco de dados disponível. Iniciando o aplicativo..."
exec "$@"
