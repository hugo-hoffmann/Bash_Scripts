#!/usr/bin/env bash  



#----------------------------------------------------------#
#DESCRIÇÃO DO CÓDIGO

#Script para pós instalação. Instala a lista de programas
#listada nas variáveis $PROGRAMAS_PARA_INSTALAT_APT, 
#$PROGRAMAS_PARA_INSTALAR_SNAP E $PROGRAMAS_PARA_INSTALAR_DEBS

#Recomendações de configuração

#Distribuições Debian no geral.

#---------------------------------------------------------#
#CHANGELOG

#---------------------------------------------------------#
#TESTED ON:

#Testado no bash 5.2.2(1)



####################### VARIÁVEIS ##########################
PPA_PIPER_LIBRATAG="ppa:libratbag-piper-libratbag-git"
PPA_LUTRIS="ppa:lutris-team/lutris"
DIRETORIO_DOWNLOAD_PROGRAMAS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR_APT=(

)

PROGRAMAS_PARA_INSTALAR_SNAP=(

)

PROGRAMAS_PARA_INSTALAR_DEBS=(

)

###########################################################################################

####################### TESTES ##########################
if ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo "[ERRO] - Seu computador não tem conexão com a internet."
  exit 1
else
  echo "[INFO] - Conexão com a internet funcionando."
fi


if [[ ! -x 'which wget' ]]; then
  echo "[INFO] wget não está instalado."
   echo "[INFO] Instalando wget."
  sudo apt install wget -y &> /dev/null
  
fi
###########################################################################################

################################## FUNÇÕES ###########################################
remover_locks(){
 echo "[INFO] - Removendo locks.."
 sudo rm/var/lib/dpkg/lock-frontend &> /dev/null
 sudo rm/ var/cache/apt/archive/lock &> /dev/null
}

adicionar_arquitetura_1386(){
   echo "[INFO] - Adicionando arquitetura 1386."
   sudo dpkg --add architecture 1386 &> /dev/null
}

update_repositorios () {
  echo "[INFO] - Atualizando Repositórios."
  sudo apt update &> /dev/null
}

adicionar_ppas () {
   echo "[INFO] - Adicionando PPAs."
   sudo apt - add - repository "$PPA_PIPER_LIBRATAG" -y &> /dev/null
   sudo apt - add - repository "$PPA_LUTRIS" -y &> /dev/null
}

baixar_debs () {
   if [[ ! -d "$DIRETORIO_DOWNLOAD_PROGRAMAS" ]] ; then
     mkdir $DIRETORIO_DOWNLOAD_PROGRAMAS
     
    fi
   for url in ${PROGRAMAS_PARA_INSTALAR_DEBS[@]}; do
     url_extraida=$(echo ${url##*/} | sed 's/-/_/g' | cut -d _ -f 1)
     
     if ! dpkg -l | grep -i $url_extraida; then 
         echo "[INFO] - Baixando o arquivo $url_extraida."
         wget -c "$url" -P "$DIRETORIO_DOWNLOAD_PROGRAMAS" &> /dev/null
         echo "[INFO] - Instalando $url_extraida."
         sudo dpkg -i $DIRETORIO_DOWNLOAD_PROGRAMAS/${url##*/} &> /dev/null
         
     else
       echo "[INFO] - O pacote $url_extraida já está instalado."
       
     fi
     done
     
     sudo apt -f install -y &> /dev/null
}

instalar_pacotes_apt () {
for pacote in ${PROGRAMAS_PARA_INSTALAR_APT[@]}; do
   
   if ! dpkg -l | grep - q $pacote; then
     echo "[INFO] - Instalando $pacote."
     sudo apt install $pacote -y &> /dev/null
   else
     echo "[INFO] - O pacote $pacote já está instalado."
     
    fi
done
}

instalar_pacotes_snap(){
 for pacote in ${PROGRAMAS_PARA_INSTALAR_SNAP[@]}; do
   
   if ! snap list  | grep - q $pacote; then
     echo "[INFO] - Instalando $pacote."
     sudo snap install $pacote &> /dev/null
   else
     echo "[INFO] - O pacote $pacote já está instalado."
     
    fi
done
}

upgrade_e_limpa_sistema () {
 sudo apt dist-upgrade -y &> /dev/null
 sudo apt autoclean &> /dev/null
 sudo apt autoremove -y &> /dev/null
} 
###########################################################################################

###################################### EXECUÇÃO ###########################################

#chama as funções
remover_locks
adicionar_arquitetura_1386
update_repositorios
adicionar_ppas
baixar_debs
instalar_debs
instalar_pacotes_apt
instalar_pacotes_snaps
upgrade_e_limpa_sistema
###########################################################################################
