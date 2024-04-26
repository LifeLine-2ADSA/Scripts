#!/bin/bash
repositorio="https://github.com/LifeLine-2ADSA/JAR-LifeLine"
echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Olá, sou o Wizard de instalação da lifeline e vou te ajudar a instalar nossa aplicação!"
#print no terminal
sleep 2
echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Deseja começar o processo de instalação da nossa aplicação?.. (Y/n)"
read comfirmacao
if test $comfirmacao = "Y" || test $comfirmacao = "y"; then
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Ok! Começando o processo de instalação..."
	sleep 3
	sudo apt upgrade && sudo apt update -y
	sudo apt install nala -y
	clear
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Buscando a fonte com maior velocidade de download"
	sudo nala fetch --auto
	clear
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Melhor fonte de download selecionada! Prosseguindo para o download"

	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Verificando se você possui o Java instalado em seu dispositivo.. "
	sleep 2
	java --version

	if [ $? -eq 0 ]; then
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Você já tem Java instalado em seu dispositivo!"
		sleep 1

		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Instalação da aplicação LifeLine começando...."
		sleep 4

		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Iniciando o processo de instalação..."
		sleep 2
		clear
	else
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Nossa solução foi desenvolvida na linguagem de programação Java, você não possui Java instalado, deseja instalar o Java para continuar com a instalação da aplicação? (Y/n)..."
		read java
		if test $java = "Y" || test $java = "y"; then
			sudo nala install openjdk-17-jre -y
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Agora que o Java foi instalado podemos prossguir com a instalação.."
			sleep 2
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7) Reiniciando processo de instalação.. "
			sleep 3
			clear
		else
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Ok, cancelando a instalação..."
			sleep 3
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Estaremos te esperando caso mude de ideia, até mais."
			sleep 5
			exit 0
		fi
	fi

	git --version
	if test $? -eq 0; then
		if test -d "JAR-LifeLine"; then
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Você já possui nossa aplicação, atualizando..."
			sleep 3
			cd "JAR-LifeLine"
			git pull
			cd ..
		else
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Instalando nossa solução.."
			git clone "$repositorio"
		fi
	else
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Utilizamos git para fazer a instalação e atualização da nossa aplicação, você não possui git, deseja instalar o git para continuar com a instalação da aplicação? (Y/n)..."
		read get

		if test $get = "Y" || test $get = "y"; then
			sudo nala install git -y
			git clone "$repositorio"
			sleep 3
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Obrigada por instalar a nossa solução, espero que tenha uma otima experiencia.."
			sleep 7
			exit 0
		else
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Ok, cancelando a instalação..."
			sleep 3
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Estaremos te esperando caso mude de ideia, até mais."
			sleep 5
			exit 0
		fi
	fi

else
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Ok, cancelando a instalação..."
	sleep 3
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Estaremos te esperando caso mude de ideia, até mais."
	sleep 5
	exit 0
fi
