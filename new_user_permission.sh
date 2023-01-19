#!/bin/bash
### Patrick R. Faria - GTI ###
log="/var/log/new_user.log"
raiz="/home/gti/compartilhamentos/"
momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
lasthost=`last -i -n 1 | awk 'FNR==1{print $3}'`
echo -e "$momento - Script iniciado pelo host \e[32;1;1m$lasthost\e[m." >> $log

cria_pasta() {
  clear
  #talvez ter um mini menu perguntando se quer criar uma pasta nova ou só atribuir alguma permissão a usuario e pastas já existentes
  #está função podera chamar função de criar usuario caso este não esteja criado?
  unset nomepasta
  read -p "Qual pasta? " nomepasta
  nomepasta=$(echo $nomepasta | sed -r 's/(.*)/\U\1/g')
  pasta="$raiz$nomepasta"
  if [ -d $pasta ] ;
    then
      echo "A pasta $nomepasta já existe! Verifique se o nome digitado está correto."
      read -p "Tecle <Enter> para retornar ao menu."
    else
      mkdir $pasta
      echo -e "A pasta \e[32;1;1m$nomepasta\e[m foi criada em $raiz com sucesso! \n" >> $log
      echo -e "A pasta \e[32;1;1m$nomepasta\e[m foi criada em $raiz com sucesso! \n"
      read -p "Deseja atribuir um usuário como dono desta pasta? (S)im ou (N)ão? [N] " opcao
      case $opcao in
        n|N|"") echo "Retornando para o menu..."
          sleep 1
          break ;;
        s|S) altera_permissao 1 ;;
        *) echo -e "\e[32;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
  fi
}

altera_permissao() {
  #teste Se usuario nao existir, perguntar se deseja criar
  if [ $1 -eq 0 ] ;
    then
      read -p "Qual pasta deseja alterar a permisão? "
      nomepasta=$(echo $nomepasta | sed -r 's/(.*)/\U\1/g')
      pasta="$raiz$nomepasta"
      if [ -d $pasta ] ;
        then
          echo "Alterar permissoes"
        else
          echo "Pasta não existe. Deseja criar?"
      fi
    else
      echo -e "Deseja alterar permissões da ultima pasta criada?\nPasta: \e[32;1;1m$nomepasta\e[m "
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

cria_usuario() {
  clear
  unset nome
  read -p "Digite um nome para o novo usuário: " nome
  nome=$(echo $nome | sed -r 's/(.*)/\L\1/g')
  if [ $(getent passwd $nome) ] ;
    then
      echo -e "O usuário $nome já existe, tente outro nome.\n"
      read -p "Tecle <Enter> para retornar ao menu."
    else
      #adduser --disabled-login --disabled-password --no-create-home --shell /usr/sbin/nologin --quiet $nome
      adduser --system --no-create-home --quiet $nome
      #talvez criar aqui, uma testagem para só continuar se o comando der certo
      sleep 1
      echo -e "\e[32;1;1mCrie uma senha para acessar o compartilhamento de pastas.\e[m"
      smbpasswd -a $nome
      clear
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo -e "$momento - O usuário \e[32;1;1m$nome\e[m foi criado com sucesso!" >> $log
      echo -e "$momento - O usuário \e[32;1;1m$nome\e[m foi criado com sucesso! \n"
      read -p "Tecle <Enter> para continuar..."
  fi
}

remove_usuario() {
  clear
  unset nome
  read -p "Digite o nome do usuário a ser removido: " nome
  nome=$(echo $nome | sed -r 's/(.*)/\L\1/g')
  smbpasswd -x $nome
    if [ $? -eq 0 ] ;
    then
      deluser $nome
      clear
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo -e "$momento - Usuário \e[32;1;1m$nome\e[m removido." >> $log
      echo -e "$momento - Usuário \e[32;1;1m$nome\e[m removido completamente. \n"
      read -p "Tecle <Enter> para continuar..."
    else
      clear
      echo -e "O usuário $nome não existe ou não é um usuário válido para remover!\n"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

cria_grupo() {
  clear
  unset grupo
  read -p "Digite um nome para o novo usuário: " grupo
  grupo=$(echo $grupo | sed -r 's/(.*)/\L\1/g')
  if [ $(getent passwd $grupo) ] ;
    then
      echo -e "O grupo $grupo já existe, tente outro nome.\n"
      read -p "Tecle <Enter> para retornar ao menu."
    else
      groupadd $grupo
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo -e "$momento - O grupo \e[32;1;1m$grupo\e[m foi criado com sucesso!" >> $log
      echo -e "$momento - O grupo \e[32;1;1m$grupo\e[m foi criado com sucesso! \n"
      read -p "Tecle <Enter> para continuar..."
  fi
}

remove_grupo() {
  clear
  unset grupo
  read -p "Digite o nome do grupo a ser excluído: " grupo
  grupo=$(echo $grupo | sed -r 's/(.*)/\L\1/g')
  groupdel $grupo
  if [ $? -eq 0 ] ;
    then
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo -e "$momento - Grupo \e[32;1;1m$grupo\e[m removido." >> $log
      echo -e "$momento - Grupo \e[32;1;1m$grupo\e[m removido. \n"
      read -p "Tecle <Enter> para continuar..."
    else
      clear
      echo -e "O grupo $grupo não existe!\n"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

adiciona_a_grupo() {
  return 0
}

remove_de_grupo() {
  return 0
}

menu_inicial() {
    clear
    echo -e "\e[32;1;1m##### ##### ##### ##### ##### ##### #####\n > Informe o número da opção desejada:\e[m"
    echo -e "\e[32;1;1m1 \e[m- Criar pasta de rede"
    echo -e "\e[32;1;1m2 \e[m- Alterar permissão de pasta"
    echo -e "\e[32;1;1m3 \e[m- Criar usuário"
    echo -e "\e[32;1;1m4 \e[m- Criar grupo"
    echo -e "\e[32;1;1m5 \e[m- Adicionar usuário a um grupo"
    echo -e "\e[32;1;1m6 \e[m- Remover usuário de um grupo"
    echo -e "\e[32;1;1m- - - - -\e[m"
    echo -e "\e[32;1;1m8 \e[m- Remover usuário"
    echo -e "\e[32;1;1m9 \e[m- Remover grupo"
    echo -e "\e[32;1;1m- - - - -\e[m"
    echo -e "\e[32;1;1m0 \e[m- Sair"
    echo -e "\e[32;1;1m##### ##### ##### ##### ##### ##### #####\e[m \n"
}

verifica_SU() {
  USER_ID=$(/usr/bin/id -u)
  return $USER_ID
}

verifica_SU
if [ $? -ne "0" ];
  then
    clear
    echo -e "\e[32;41;1mVocê não tem permissões de Super-usuário! Tente executar este script como root.\e[m \n"
    exit 1
  else
    menu_inicial
    while true; do
      echo "O que deseja fazer?"
      read -p "> " opcao_menu
      case $opcao_menu in
        1) cria_pasta ;;
        2) altera_permissao ;;
        3) cria_usuario ;;
        4) cria_grupo ;;
        5) adiciona_a_grupo ;;
        6) remove_de_grupo ;;
        8) remove_usuario ;;
        9) remove_grupo ;;
        0) clear
          echo "Encerrando o script..."
          sleep 1
          clear
          break ;;
        *) echo -e "\e[32;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
      menu_inicial
    done
fi

momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
echo -e "$momento - Script encerrado. \n-------------------\n" >> $log
echo -e "$momento - \e[32;1;1mScript encerrado.\e[m \n"