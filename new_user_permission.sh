#!/bin/bash

log="/var/log/new_user.log"
momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
echo -e "$momento - Script iniciado." >> $log

cria_usuario() {
  read -p "Digite um nome para o novo usuário: " nome
  if [ $(getent passwd $nome) ] ; then
    echo "O usuário $nome já existe, tente outro nome."
    read -p "Tecle <Enter> para continuar..."
    else
      adduser --no-create-home --disabled-login --disabled-password --shell /usr/sbin/nologin $nome
      smbpasswd -a $nome
      echo "$momento - O usuário $nome foi criado com sucesso!" >> $log
      echo "$momento - O usuário $nome foi criado com sucesso!"
      read -p "Tecle <Enter> para continuar..."
  fi
}

cria_grupo() {
  #groupadd "$nome"
  return 0
}

altera_permissao() {
  #if [ -d $pasta ] ; then
  #else
  #fi
  return 0
}

remove_usuario() {
  #"mini menu com opcoes -listar usuarios -digitar usuario"
  read -p "Digite o nome do usuário a ser removido: " d_nome
  if [ $(deluser --remove-all-files $d_nome) ] ;
    then
      echo -e "$momento - \e[32;1;1mUsuário $d_nome removido completamente\e[m."
      echo "$momento - Usuário $d_nome removido." >> $log
      read -p "Tecle <Enter> para continuar..."
    else
      read -p "Tecle <Enter> para continuar..."
  fi
}

menu_inicial() {
    clear
    echo -e "\e[32;1;1m#####Entre com o numero da opcao desejada:\e[m"
    echo -e "\e[32;1;1m1 \e[m- Criar usuário"
    echo -e "\e[32;1;1m2 \e[m- Criar grupo"
    echo -e "\e[32;1;1m3 \e[m- Alterar permissão de pasta"
    echo -e "\e[32;1;1m9 \e[m- Remover usuário"
    echo -e "\e[32;1;1m- - - - -\e[m"
    echo -e "\e[32;1;1m0 \e[m- Sair"
    echo -e "\e[32;1;1m##### ##### ##### ##### ##### ##### #####\e[m \n"
}

verifica_SU() {
  USER_ID=$(/usr/bin/id -u)
  return $USER_ID
}

verifica_SU
if [ $? -ne "0" ]; then
    clear
    echo -e "\e[32;41;1mVocê não tem permissões de Super-usuário! Tente executar este script como root.\e[m \n"
    exit 1
  else
    menu_inicial
    while true; do
      echo "Qual opção?"
      read -p "> " opcao_menu
      case $opcao_menu in
        1) cria_usuario ;;
        2) cria_grupo ;;
        3) altera_permissao ;;
        9) remove_usuario ;;
        0) clear
        echo "Encerrando o script..."
        sleep 2
        clear
        break ;;
        *) echo "Opção incorreta!" ;;
      esac
      menu_inicial
    done
fi

momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
echo -e "$momento - Script encerrado. \n" >> $log
echo -e "$momento - Script encerrado. \n"