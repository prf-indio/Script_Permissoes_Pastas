#!/bin/bash

momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
log="/var/log/new_user.log"
cria_usuario() {
  read -p "Digite um nome para o novo usuário: " nome
  if [ $(getent passwd $nome) ] ; then
    echo "O usuário $nome já existe, tente outro nome."
  else
    adduser --no-create-home --disabled-login --disabled-password --shell /usr/sbin/nologin $nome
    smbpasswd -a $nome
#   return $nome
  fi
}

cria_grupo() {
  groupadd "$nome-g"
}

'''
altera_permissao() {
  if [ -d $pasta ] ; then
  else
  fi
}
'''

remove_usuario() {
#  "mini menu com opcoes -listar usuarios -digitar usuario"
  read -p "Digite o nome do usuário a ser removido: " d_nome
  if [ $(getent passwd $d_nome) ] ; then
    deluser --remove-all-files $d_nome
    echo -e "Usuário $d_nome removido completamente."
    echo "$momento"
  else
    echo "O usuário $d_nome não existe, verifique se o nome digitado está correto."
    sleep 10
  fi
}

menu_inicial() {
    clear
    echo -e "\e[32;1;1m#####Entre com o numero da opcao desejada:\e[m"
    echo -e "\e[32;1;1m1 \e[m- Opcao 1"
    echo -e "\e[32;1;1m2 \e[m- Opcao 2"
    echo -e "\e[32;1;1m3 \e[m- Opcao 3"
    echo -e "\e[32;1;1m0 \e[m- Remover"
    echo -e "\e[32;1;1m9 \e[m- Sair"
    echo -e "\e[32;1;1m#####\e[m \n"
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
        3) echo "Função - altera permissão"
          sleep 2 ;;
        9) clear
        echo "Encerrando o script..."
        sleep 2
        clear
        echo -e "Script encerrado em $momento. \n"
        break ;;
        0) remove_usuario ;;
        *) echo "Opção incorreta!" ;;
    esac
    menu_inicial
  done
fi
