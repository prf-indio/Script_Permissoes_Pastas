#!/bin/bash
### Patrick R. Faria - GTI ###
log="/var/log/new_user.log"
momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
echo -e "$momento - Script iniciado." >> $log

cria_usuario() {
  unset nome
  read -p "Digite um nome para o novo usuário: " nome
  if [ $(getent passwd $nome) ] ;
    then
      echo "O usuário $nome já existe, tente outro nome."
      read -p "Tecle <Enter> para retornar ao menu."
    else
      adduser --no-create-home --disabled-login --disabled-password --shell /usr/sbin/nologin --quiet $nome
      sleep 1
      clear
      echo -e "\e[32;1;1mCrie uma senha para acessar o compartilhamento de pastas.\e[m"
      smbpasswd -a $nome
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo "$momento - O usuário $nome foi criado com sucesso!" >> $log
      echo -e "$momento - O usuário $nome foi criado com sucesso!\e[m \n"
      read -p "Tecle <Enter> para continuar..."
  fi
}

remove_usuario() {
  unset nome
  read -p "Digite o nome do usuário a ser removido: " nome
  smbpasswd -x $nome
    if [ $? -eq 0 ] ;
    then
      deluser $nome
      clear
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo "$momento - Usuário $nome foi removido." >> $log
      echo -e "$momento - \e[32;1;1mUsuário $nome removido completamente.\e[m \n"
      read -p "Tecle <Enter> para continuar..."
    else
      clear
      echo "O usuário $nome não existe!"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

cria_grupo() {
  unset grupo
  read -p "Digite um nome para o novo usuário: " grupo
  if [ $(getent passwd $grupo) ] ;
    then
      echo "O grupo $grupo já existe, tente outro nome."
      read -p "Tecle <Enter> para retornar ao menu."
    else
      groupadd $grupo
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo "$momento - O grupo $grupo foi criado com sucesso!" >> $log
      echo -e "$momento - O grupo $grupo foi criado com sucesso!\e[m \n"
      read -p "Tecle <Enter> para continuar..."
  fi
}

remove_grupo() {
  unset grupo
  read -p "Digite o nome do grupo a ser excluído: " grupo
  groupdel $grupo
    if [ $? -eq 0 ] ;
    then
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo "$momento - Grupo $grupo foi removido." >> $log
      echo -e "$momento - \e[32;1;1mGrupo $grupo removido.\e[m \n"
      read -p "Tecle <Enter> para continuar..."
    else
      clear
      echo "O grupo $grupo não existe!"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

adiciona_a_grupo() {
  return 0
}

remove_de_grupo() {
  return 0
}

altera_permissao() {
  #if [ -d $pasta ] ; then
  #else
  #fi
  return 0
}



menu_inicial() {
    clear
    echo -e "\e[32;1;1m#####Entre com o numero da opcao desejada:\e[m"
    echo -e "\e[32;1;1m1 \e[m- Alterar permissão de pasta"
    echo -e "\e[32;1;1m2 \e[m- Criar usuário"
    echo -e "\e[32;1;1m3 \e[m- Criar grupo"
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
      echo "Qual opção?"
      read -p "> " opcao_menu
      case $opcao_menu in
        1) altera_permissao ;;
        2) cria_usuario ;;
        3) cria_grupo ;;
        8) remove_usuario ;;
        9) remove_grupo ;;
        0) clear
        echo "Encerrando o script..."
        sleep 2
        clear
        break ;;
        *) echo -e "\e[32;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
      menu_inicial
    done
fi

momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
echo -e "$momento - Script encerrado. \n" >> $log
echo -e "\e[32;1;1m$momento - Script encerrado.\e[m \n"