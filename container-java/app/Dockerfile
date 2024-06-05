# Use uma imagem base com JDK 17
FROM openjdk:17-slim

# Instalar netcat e outras dependências necessárias
RUN apt-get update && apt-get install -y netcat-openbsd procps

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo JAR e o script de espera para o diretório de trabalho no contêiner
COPY lifeline.jar /app/lifeline.jar
COPY wait-for-it.sh /app/wait-for-it.sh

# Torne o script executável
RUN chmod +x /app/wait-for-it.sh

# Especifique o comando para rodar a aplicação Java
CMD ["./wait-for-it.sh", "db", "3306", "--", "java", "-jar", "/app/lifeline.jar"]
