#!/bin/bash
### Patrick R. Faria - GTI ###
log="/var/log/new_user.log"
raiz="/home/gti/compartilhamentos/"
listagrupos="/var/local/grupos.txt"
listausuarios="/var/local/usuarios.txt"
admin="administrador"
momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
lasthost=`last -i -n 1 | awk 'FNR==1{print $3}'`

cria_pasta() {
  clear
  if [ $1 -eq 2 ] ;
    then
      unset opcao
      mkdir "$pasta"
      chmod -R 770 "$pasta"
      chown -R "$admin" "$pasta"
      chgrp -R "$admin" "$pasta"
      echo -e "$momento - A pasta \e[32;1;1m$nomepasta\e[m foi criada em $raiz com sucesso!" >> $log
      echo -e "A pasta \e[34;1;1m$nomepasta\e[m foi criada em $raiz com sucesso! \n"
      read -p "Deseja tornar um grupo dono desta pasta? (S)im ou (N)ão? [N] " opcao
      case $opcao in
        n|N|"") echo "Retornando para o menu..."
          sleep 1
          break ;;
        s|S) menu_altera_permissao 1 ;;
        *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
    else
      unset nomepasta
      read -p "Qual o nome da pasta que deseja criar? " nomepasta
      nomepasta=$(echo "$nomepasta" | sed -r 's/(.*)/\U\1/g')
      pasta="$raiz$nomepasta"
      if [ -d "$pasta" ] ;
        then
          unset opcao
          echo "A pasta $nomepasta já existe! Verifique se o nome digitado está correto."
          read -p "Deseja alterar a permissão desta pasta? (S)im ou (N)ão? [N] " opcao
          case $opcao in
            n|N|"") echo "Retornando para o menu..."
              sleep 1
              break ;;
            s|S) menu_altera_permissao 1 ;;
            *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
              read -p "Tecle <Enter> para retornar ao menu." ;;
          esac
        else
          unset opcao
          mkdir "$pasta"
          chmod -R 770 "$pasta"
          chown -R "$admin" "$pasta"
          chgrp -R "$admin" "$pasta"
          echo -e "$momento - A pasta \e[34;1;1m$nomepasta\e[m foi criada em $raiz com sucesso!" >> $log
          echo -e "A pasta \e[34;1;1m$nomepasta\e[m foi criada em $raiz com sucesso! \n"
          read -p "Deseja tornar um grupo dono desta pasta? (S)im ou (N)ão? [N] " opcao
          case $opcao in
            n|N|"") echo "Retornando para o menu..."
              sleep 1
              break ;;
            s|S) menu_altera_permissao 1 ;;
            *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
              read -p "Tecle <Enter> para retornar ao menu." ;;
          esac
      fi
  fi
}

altera_permissao() {
  clear
  unset grupo
  read -p "Qual grupo deve ser dono desta pasta? Digite o nome: " grupo
  grupo=$(echo "$grupo" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if [ $(getent group "$grupo") ] ;
    then
      chgrp -R "$grupo" "$pasta"
      #adicionar checagem de erro do comando anterior
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo -e "$momento - Permissão da pasta \e[34;1;1m$nomepasta\e[m alterada. O grupo \e[34;1;1m$grupo\e[m é o novo dono." >> $log
      echo -e "O grupo $grupo é o novo dono da pasta $nomepasta.\n"
      unset opcao
      read -p "Deseja também tornar um Usuário específico dono desta pasta? (S)im ou (N)ão? [N] " opcao
      case $opcao in
        s|S)
          unset usuario
          read -p "Digite o nome do usuário que deseja tornar dono desta pasta: " usuario
          usuario=$(echo "$usuario" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
          if [ $(getent passwd "$usuario") ] ;
            then
              chown -R "$usuario" "$pasta"
              #adicionar checagem de erro do comando anterior
              momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
              echo -e "$momento - Permissão da pasta \e[34;1;1m$nomepasta\e[m alterada. O usuário \e[34;1;1m$usuario\e[m é o novo dono." >> $log
              echo -e "O usuário $usuario é o novo dono da pasta $nomepasta.\n"
              read -p "Tecle <Enter> para continuar..."
            else
              echo "Este usuário não existe!"
              unset opcao
              read -p "Deseja criá-lo? (S)im ou (N)ão? [N] " opcao
              case $opcao in
                n|N|"") echo "Retornando para o menu..."
                  sleep 1
                  break ;;
                s|S) cria_usuario ;;
                *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
                read -p "Tecle <Enter> para retornar ao menu." ;;
              esac
          fi
            ;;
        n|N|"")
          echo "Retornando para o menu..."
          sleep 2
          ;;
        *)
          echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu."
          ;;
        esac
    else
      echo -e "Este grupo $grupo NÃO existe."
      unset opcao
      read -p "Deseja criar? (S)im ou (N)ão? [N] " opcao
      case $opcao in
        n|N|"") echo "Retornando para o menu..."
          sleep 1
          break ;;
        s|S) cria_grupo ;;
        *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
  fi
}

menu_altera_permissao() {
  if [ $1 -eq 1 ] ;
    then
      unset opcao
      read -p "Deseja mesmo alterar as permissões da pasta $nomepasta? (S)im ou (N)ão? [N] " opcao
      case $opcao in
        n|N|"") echo "Retornando para o menu..."
          sleep 1
          break ;;
        s|S) altera_permissao ;;
        *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
    else
      read -p "Qual pasta deseja alterar a permisão? " nomepasta
      nomepasta=$(echo "$nomepasta" | sed -r 's/(.*)/\U\1/g')
      pasta="$raiz$nomepasta"
      if [ -d "$pasta" ] ;
        then
          altera_permissao
        else
          unset opcao
          read -p "Esta pasta não existe. Deseja criá-la? (S)im ou (N)ão? [N] " opcao
          case $opcao in
            n|N|"") echo "Retornando para o menu..."
              sleep 1
              break ;;
            s|S) cria_pasta 2 ;;
            *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
            read -p "Tecle <Enter> para retornar ao menu." ;;
          esac
      fi
  fi
}

cria_usuario() {
  clear
  unset usuario
  read -p "Digite um nome para o novo usuário: " usuario
  usuario=$(echo "$usuario" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if [ $(getent passwd "$usuario") ] ;
    then
      echo -e "O usuário $usuario já existe, tente outro nome.\n"
      read -p "Tecle <Enter> para retornar ao menu."
    else
      #adduser --disabled-login --disabled-password --no-create-home --shell /usr/sbin/nologin --quiet $nome
      adduser --system --no-create-home --quiet "$usuario"
      #talvez criar aqui, uma testagem para só continuar se o comando der certo
      echo -e "\e[34;1;1mCrie uma senha para acessar o compartilhamento de pastas.\e[m"
      smbpasswd -a "$usuario"
      clear
      momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
      echo "$usuario" >> $listausuarios
      echo -e "$momento - O usuário \e[34;1;1m$usuario\e[m foi criado com sucesso!" >> $log
      echo -e "O usuário \e[34;1;1m$usuario\e[m foi criado com sucesso! \n"
      read -p "Tecle <Enter> para continuar..."
      #perguntar se deseja criar grupo com mesmo nome
  fi
}

remove_usuario() {
  clear
  unset usuario
  read -p "Digite o nome do usuário a ser removido: " usuario
  usuario=$(echo "$usuario" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if grep -q "$usuario" "$listausuarios" && [ "$usuario" != "$admin" ] ;
    then
      smbpasswd -x "$usuario"
      if [ $? -ne "0" ];
        then
          read -p "Um erro ocorreu. Tecle <Enter> para retornar ao menu."
        else
          deluser "$usuario"
          if [ $? -ne "0" ];
            then
              read -p "Um erro ocorreu. Tecle <Enter> para retornar ao menu."
            else
              clear
              momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
              sed -i "/$usuario/d" $listausuarios
              echo -e "$momento - Usuário \e[34;1;1m$usuario\e[m removido." >> $log
              echo -e "Usuário \e[34;1;1m$usuario\e[m removido completamente. \n"
              read -p "Tecle <Enter> para continuar..."
          fi
        fi
    else
      clear
      echo -e "O usuário \e[34;1;1m$usuario\e[m não existe ou não é um usuário válido para remover!\n"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

cria_grupo() {
  clear
  unset grupo
  read -p "Digite um nome para o novo grupo: " grupo
  grupo=$(echo "$grupo" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if [ $(getent group "$grupo") ] ;
    then
      echo -e "O grupo $grupo já existe, tente outro nome.\n"
      read -p "Tecle <Enter> para retornar ao menu."
    else
      groupadd "$grupo"
      if [ $? -ne "0" ];
        then
          read -p "Um erro ocorreu. Tecle <Enter> para retornar ao menu."
        else
          gpasswd -a "$admin" "$grupo"
          momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
          echo "$grupo" >> $listagrupos
          echo -e "$momento - O grupo \e[34;1;1m$grupo\e[m foi criado com sucesso! O usuário $admin foi adicionado automaticamente a este grupo." >> $log
          echo -e "O grupo \e[34;1;1m$grupo\e[m foi criado com sucesso! \nO usuário $admin foi adicionado automaticamente a este grupo. \n"
          read -p "Tecle <Enter> para continuar..."
          #Deseja inserir algum usuario a este grupo?
      fi
  fi
  #perguntar se deseja criar usuário com mesmo nome
  #perguntar se quer alterar permissão de alguma pasta
}

remove_grupo() {
  clear
  echo -e "\e[34;1;1m- - - - -\e[m"
  cat $listagrupos
  echo -e "\e[34;1;1m- - - - -\e[m \n"
  read -p "Digite o nome do grupo a ser excluído: " grupo
  grupo=$(echo "$grupo" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if grep -q "$grupo" "$listagrupos" && [ "$grupo" != "$admin" ] ;
    then
      groupdel -f "$grupo"
      if [ $? -ne "0" ];
        then
          read -p "Um erro ocorreu. Tecle <Enter> para retornar ao menu."
        else
          momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
          sed -i "/$grupo/d" $listagrupos
          echo -e "$momento - Grupo \e[34;1;1m$grupo\e[m removido." >> $log
          echo -e "Grupo \e[34;1;1m$grupo\e[m removido. \n"
          read -p "Tecle <Enter> para continuar..."
      fi
    else
      clear
      echo -e "O grupo $grupo não existe ou não é um grupo válido para remover!\n"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

adiciona_a_grupo() {
  clear
  echo -e "\e[34;1;1m- - - - -\e[m"
  cat $listagrupos
  echo -e "\e[34;1;1m- - - - -\e[m \n"
  read -p "Em qual grupo você deseja adicionar o usuário? Digite o nome: " grupo
  grupo=$(echo "$grupo" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if grep -q "$grupo" "$listagrupos" ;
    then
      echo -e "\e[34;1;1m- - - - -\e[m"
      cat $listausuarios
      echo -e "\e[34;1;1m- - - - -\e[m \n"
      read -p "Qual usuário você deseja adicionar ao grupo $grupo? Digite o nome: " usuario
      usuario=$(echo "$usuario" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
      if grep -q "$usuario" "$listausuarios" && [ "$usuario" != "$admin" ] ;
        then
          gpasswd -a "$usuario" "$grupo"
          if [ $? -ne "0" ];
            then
              read -p "Um erro ocorreu. Tecle <Enter> para retornar ao menu."
            else
              echo -e "Usuário \e[34;1;1m$usuario\e[m adicionado ao grupo \e[34;1;1m$grupo\e[m!"
              echo -e "$momento - Usuário \e[34;1;1m$usuario\e[m adicionado ao grupo \e[34;1;1m$grupo\e[m!" >> $log
              read -p "Tecle <Enter> para retornar ao menu."
          fi
        else
          clear
          echo -e "O usuário \e[34;1;1m$usuario\e[m não existe ou não é um usuário válido para adicionar ao grupo.\n"
          read -p "Tecle <Enter> para retornar ao menu."
      fi
    else
      clear
      echo -e "O grupo \e[34;1;1m$grupo\e[m não existe ou não é um grupo permitido alterar!\n"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

remove_de_grupo() {
  clear
  echo -e "\e[34;1;1m- - - - -\e[m"
  cat $listagrupos
  echo -e "\e[34;1;1m- - - - -\e[m \n"
  read -p "De qual grupo você deseja remover o usuário? Digite o nome: " grupo
  grupo=$(echo "$grupo" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
  if grep -q "$grupo" "$listagrupos" ;
    then
      echo -e "\e[34;1;1m- - - - -\e[m"
      getent group "$grupo" | cut -d: -f4 | tr ',' '\n'
      echo -e "\e[34;1;1m- - - - -\e[m \n"
      read -p "Qual usuário você deseja remover do grupo $grupo? Digite o nome: " usuario
      usuario=$(echo "$usuario" | sed -r 's/(.*)/\L\1/g' | sed 's/ /\_/g')
      if grep -q "$usuario" "$listausuarios" && [ "$usuario" != "$admin" ] ;
        then
          gpasswd -d "$usuario" "$grupo"
          if [ $? -ne "0" ];
            then
              read -p "Um erro ocorreu. Tecle <Enter> para retornar ao menu."
            else
              echo -e "Usuário \e[34;1;1m$usuario\e[m removido do grupo \e[34;1;1m$grupo\e[m!"
              echo -e "Usuário \e[34;1;1m$usuario\e[m removido do grupo \e[34;1;1m$grupo\e[m!" >> $log
              read -p "Tecle <Enter> para retornar ao menu."
          fi
        else
          clear
          echo -e "O usuário \e[34;1;1m$usuario\e[m não existe ou não é um usuário válido para remover do grupo.\n"
          read -p "Tecle <Enter> para retornar ao menu."
      fi
    else
      clear
      echo -e "O grupo \e[34;1;1m$grupo\e[m não existe ou não é um grupo permitido alterar!\n"
      read -p "Tecle <Enter> para retornar ao menu."
  fi
}

menu_inicial() {
    clear
    echo -e "\e[34;1;1m##### ##### ##### ##### ##### ##### #####\n > Informe o número da opção desejada:\e[m"
    echo -e "\e[34;1;1m1 \e[m- Criar pasta de rede"
    echo -e "\e[34;1;1m2 \e[m- Alterar permissão de pasta"
    echo -e "\e[34;1;1m3 \e[m- Criar usuário"
    echo -e "\e[34;1;1m4 \e[m- Criar grupo"
    echo -e "\e[34;1;1m5 \e[m- Adicionar usuário a um grupo"
    echo -e "\e[34;1;1m6 \e[m- Remover usuário de um grupo"
    echo -e "\e[34;1;1m- - - - -\e[m"
    echo -e "\e[34;1;1m99 \e[m- Remover usuário"
    echo -e "\e[34;1;1m00 \e[m- Remover grupo"
    echo -e "\e[34;1;1m- - - - -\e[m"
    echo -e "\e[34;1;1mexit \e[m- Sair"
    echo -e "\e[34;1;1m##### ##### ##### ##### ##### ##### #####\e[m \n"
}

verifica_SU() {
  USER_ID=$(/usr/bin/id -u)
  return $USER_ID
}

if [ "$1" == "--log" ] ;
  then
    cat $log
    exit 1
  else
    echo -e "\e[0;41;1mParametro inválido! Talvez você queira usar '--log'.\e[m \n"
    exit 1
fi

echo -e "\n$momento - Script iniciado pelo host \e[34;1;1m$lasthost\e[m." >> $log
verifica_SU
if [ $? -ne "0" ];
  then
    clear
    echo -e "\e[0;41;1mVocê não tem permissões de Super-usuário! Tente executar este script novamente como root.\e[m \n"
    exit 1
  else
    menu_inicial
    while true; do
      echo "O que deseja fazer?"
      read -p "> " opcao_menu
      case $opcao_menu in
        1) cria_pasta 0 ;;
        2) menu_altera_permissao 0 ;;
        3) cria_usuario ;;
        4) cria_grupo ;;
        5) adiciona_a_grupo ;;
        6) remove_de_grupo ;;
        99) remove_usuario ;;
        00) remove_grupo ;;
        sair|exit) clear
          echo "Encerrando o script..."
          sleep 1
          clear
          break ;;
        *) echo -e "\e[0;41;1mOpção incorreta!\e[m \n" 
          read -p "Tecle <Enter> para retornar ao menu." ;;
      esac
      menu_inicial
    done
fi

momento=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`
echo -e "$momento - Script encerrado. \n-------------------" >> $log
echo -e "$momento - \e[34;1;1mScript encerrado.\e[m \n"