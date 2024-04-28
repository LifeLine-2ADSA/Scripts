#!/bin/bash
repositorio="https://github.com/LifeLine-2ADSA/JAR-LifeLine/"
executar() {
	read exec
	if test $exec = "Y" || test $exec = "y"; then
		cd ~
		cd ~/LifeLine/JAR-LifeLine/lifeline/target/
		sudo chmod +x lifeline-1.0-SNAPSHOT-jar-with-dependencies.jar
		java -jar lifeline-1.0-SNAPSHOT-jar-with-dependencies.jar
	else
		cd ..
		echo "$(tput setaf)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Ok, até mais!"
		sleep 2
		exit 0
	fi
}
echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Olá, sou o Wizard de instalação da lifeline e vou te ajudar a instalar nossa aplicação!"
#print no terminal
sleep 2
echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Deseja começar o processo de instalação da nossa aplicação?.. (Y/n)"
read confirmacao
if test $confirmacao = "Y" || test $confirmacao = "y"; then
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Ok! Começando o processo de instalação..."
	sleep 3
	sudo apt upgrade && sudo apt update -y
	sudo apt install nala -y
	sleep 2
	clear
	echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Deseja aumentar a velocidade do download usando a melhor fonte? (Y/n)"
	read mirror
	if test $mirror = "Y" || test $mirror = "y"; then
		echo "$(tput setaf)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Buscando a fonte com maior velocidade de download"
		sudo nala fetch --auto
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Melhor fonte de download selecionada! Prosseguindo para o download"
	else
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Verificando se você possui o Java instalado em seu dispositivo.. "
		sleep 2
	fi
	java --version
	if [ $? -eq 0 ]; then
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Você já tem Java instalado em seu dispositivo!"
		sleep 3

		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Iniciando o processo de instalação..."
		sleep 2
	else
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Nossa solução foi desenvolvida na linguagem de programação Java, você não possui Java instalado, deseja instalar o Java para continuar com a instalação da aplicação? (Y/n)..."
		read java
		if test $java = "Y" || test $java = "y"; then
			sudo nala install openjdk-17-jre -y
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Agora que o Java foi instalado podemos prossguir com a instalação.."
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
		echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Você já possui git..."
		sleep 2
		if test -d "JAR-LifeLine"; then
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Você já possui nossa aplicação, deseja atualizar? (Y/n)"
			read att
			if test $att = "Y" || test $att = "y"; then
				git pull
				sleep 2
				echo "$(tput setaf)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Aplicação atualizada!"
				sleep 1
				echo "$(tput setaf)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Deseja executar a aplicação(Y/n)?"
				executar
			fi
		else
			echo "$(tput setaf 6)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Instalando nossa solução.."
			git clone "$repositorio"
			echo "$(tput setaf)$(tput smso)<Instalador LifeLine>$(tput sgr0): $(tput setaf 7)Deseja executar a aplicação?(Y/n)"
			executar
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
