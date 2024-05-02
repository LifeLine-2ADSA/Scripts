#!/bin/bash

# Entidades
declare -A entities
entities[usuario]="idUsuario nome endereco telefone cargo senha email cpf fkEmpresa"
entities[empresa]="idEmpresa nome cnpj logradouro email telefone matriz"
entities[maquina]="idMaquina nomeMaquina ip macAddress sistemaOperacional maxCpu maxRam maxDisco maxDispositivos fkUsuario"
entities[postagem]="idPostagem titulo conteudo tag fkUsuario"
entities[registro]="idRegistro dataHora fkMaquina consumoDisco consumoRam consumoCpu"
entities[limitador]="idLimitador fkMaquina limiteCpu limiteRam limiteDisco"
# Credenciais
readonly USERNAME=lifeline_user
readonly PASSWORD=urubu100
readonly DATABASE=lifeline

CHECK_TABLE_EXISTS() {
	# atribuindo o nome das tabelas pela lista de entidades acima
	local table_names=("${!entities[@]}")
	# tabelas que não existem
	non_existent_tables=()
	# tabelas que existem
	existent_tables=()

	# Sql queries para checar se as tabelas existem "Obs: as queries são do tipo local que é o equivalente a private para não
	# serem modificadas fora da função"
	for table in "${table_names[@]}"; do
		local query_table_exists=$(printf 'SHOW TABLES LIKE "%s"' "$table")
		local query_table_is_empty=$(printf 'SELECT 1 FROM %s LIMIT 1' "$table")
		if [[ $(mysql -u $USERNAME -p$PASSWORD -e "$query_table_exists" $DATABASE) ]]; then
			existent_tables+=("$table")
		else
			non_existent_tables+=("$table")
		fi
	done
}
#TODO:
#CREATE_NON_EXISTENT_TABLES() {
#	for table in "${non_existent_tables[@]}"; do
#		echo "$TABLE"
#	done
#}

CHECK_TABLES_INTEGRITY() {
	# Lista de tabelas que estão fora do escopo
	tables_to_fix=()
	# Laço de repetição for each tabela nas tabelas existentes
	for table in "${existent_tables[@]}"; do
		# String private (local no bash) que contém todos os atributos
		local entity_attributes=${entities[$table]}
		# regex que separa os atributos por " "(espaço em branco)
		IFS=' '
		read -r -a entity_attributes_array <<<"$entity_attributes"
		# query que busca os atributos no banco de dados e usa o awk para printar apenas a primeira coluna (Nome do atributo)
		local attribute_names=$(mysql -u $USERNAME -p$PASSWORD -N -e "SHOW COLUMNS FROM $table" $DATABASE | awk '{print $1}')
		# regex que separa os atibutos do banco por quebra de linha
		IFS=$'\n'
		read -r -d '' -a table_attributes_array <<<"$attribute_names"
		# Checa se o size das arrays são equivalentes se não eles são armazenados na lista de tabelas com erro
		if ! [[ "${#table_attributes_array[@]}" -eq "${#entity_attributes_array[@]}" ]]; then
			echo "Número de atributos da tabela $table não corresponde ao número esperado."
			echo "$(tput bold)Esperado$(tput sgr0) = $(tput setaf 2)${#entity_attributes_array[@]}$(tput sgr0)"
			echo "$(tput bold)Recebido$(tput sgr0) = $(tput setaf 1)${#table_attributes_array[@]}$(tput sgr0)"
			tables_to_fix+=($table)
		else
			# checa atributo por atributo até encontrar um atributo fora do escopo e o armazena na lista de tabelas com erro
			for ((i = 0; i < "${#entity_attributes_array[@]}"; i++)); do
				if [[ $(echo " ${table_attributes_array[$i]} " | xargs) != $(echo " ${entity_attributes_array[$i]} " | xargs) ]]; then
					echo "Atributo fora de escopo encontrado:"
					echo "$(tput smul)$(tput bold)Atributo esperado$(tput rmul)$(tput sgr0): ${entity_attributes_array[$i]}"
					echo "$(tput smul)$(tput bold)Atributo recebido$(tput rmul)$(tput sgr0): ${table_attributes_array[$i]}"
					tables_to_fix+=($table)
					break
				fi
			done
		fi
	done
}

# chamando as funções
CHECK_TABLE_EXISTS 2>/dev/null
CHECK_TABLES_INTEGRITY 2>/dev/null
# CREATE_NON_EXISTENT_TABLES 2>/dev/null
for entitie in ${!entities[@]}; do
	for down_table in ${non_existent_tables[@]}; do
		if [[ $entitie == $down_table ]]; then
			echo "$entitie STATUS: $(tput setaf 1)$(tput bold)DOWN  $(tput sgr0)"
		fi
	done
	for modified_table in ${tables_to_fix[@]}; do
		if [[ $entitie == $modified_table ]]; then
			echo "$entitie STATUS: $(tput setaf 3)$(tput bold)MODIFIED  $(tput sgr0)"
			#TODO: STATUS DAS maquinas ok
			#else
			#echo "$entitie STATUS: $(tput setaf 2)$(tput bold)OK  $(tput sgr0)"
		fi
	done
done
