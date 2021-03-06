#!/usr/bin/env bash

# Deixar com que o arquivo apenas possa ser lido/escrito por sudoers
# senão a senha fica exposta

# Exportando o arquivo 'hextotex.sh'
#source "./hextotex.sh"

: << 'FIM'
Deixar com que apenas usuários permitidos possam ler
e modificar o arquivo, para a senha não ser exibida

Para fazer: criar um pompem da vida e inserir ele nesse programa! yay ;(
echo -e "\x72\x30\x64\x72\x69\x63\x62\x72" # Ofuscar a senha com hex

FIM

VERMELHO='\033[31;1m' # '\033[31m' = Vermelho ';' concatena o Vermelho com o '\033[1m' é Negrito
VERDE='\033[32;1m'    # '\033[32m' = Verde
AZUL='\033[34;1m'     # '\033[34m' = Azul
AMARELO='\033[33;1m'  # '\033[33' = Amarelo
CYANO='\033[0;36m'    # '\033[0;36m' = Cyano
FIM='\033[m'          # Reseta a cor

senha=$1
ajuda=$1
versao='2.0'

trap encerr 2

encerr(){
  echo -e "\n\n${AMARELO}Processo interrompido\nSaíndo!${FIM}\n"
  exit 130
}

_Ajuda_(){
  echo -e "
  Modo de uso:\n \
  \t$0 <senha>\n\n \
  Comandos:\n \
  \t-h | --help      : Painel de ajuda\n \
  \t-v | --version   : Versão do programa\n \
  \t-u | --uninstall : Desinstalar programa\n \
  \t-c | --credito   : Créditos \
  "
}

credito_(){
  echo -e "
  Criado por: RodricBr via GitHub\n\
  Github: github.com/RodricBr
  Data: 06/09/2021 \
  "
  exit 0
}

uninstall_1(){
  #local enter_return=$2
  echo -e "Você deseja desinstalar o programa?\n"
  read -rp "Sim[y] Não[N]: " resposta_1
  case "$resposta_1" in
    Y|y)  echo -e "Desinstalando..." ;
      sleep 3 ;
      rm -f $0 && rm -rf ~/secret ;
      exit 0 ;;
    N|n)  exit 0 ;;
    '\n') exit 0 ;; #[[ $enter_return ]] && return "$enter_return"
  esac
}

case $ajuda in
  "-h"|"--help") _Ajuda_ ;
      exit 0
  ;;
  "-v"|"--versao") echo -e "\nVersão: $versao" ;
      exit 0
  ;;
  "-u"|"--uninstall") uninstall_1 ;
      exit 0
  ;;
  "-c"|"--credito") credito_ ;;
esac

_hex_(){
  if [[ -z "$*" ]]; then
    read -rp "Digite um número hex: " opcao_hex2
    echo -ne "O valor decimal do ${opcao_hex2} é: "
    echo "obase=10; ibase=16; ${opcao_hex2}" | bc
    if [[ ! -z $(command -v bc 2>/dev/null) ]]; then
      echo -e "${VERMELHO}Erro:${FIM} bc não encontrado no seu sistema!\n\
      Favor instale para poder usar esta opção."
      exit 1
    fi
  else
    echo -n "O valor decimal do $* é: "
    echo "ibase=16; $*" | bc
  fi
}

binario_(){
  read -rp "$(echo -e $CYANO"Valor: "$FIM)" lendo_

  for arg in $lendo_; do
    perl -e 'printf "%b\n",'$arg
    #let "index+=1"
  done
}

lspci_(){
  if [[ -z $(command -v lspci 2>/dev/null) ]]; then
    echo -e "${VERMELHO}Erro:${FIM} lspci não encontrado no seu sistema!\n\
    Favor instale para poder usar esta opção."
    exit 1
  else
    respo=$(lspci | grep -e Ethernet | awk '{print $1}')
    lspci -s $respo -v
  fi
}

if [[ "$senha" == "r0dricbr" ]]; then
  echo -e "\n\t${VERDE}Sucesso!${FIM}\n"
  echo -e "\t${AMARELO}[V] Inicializando programa...${FIM}"
  sleep 2
  echo -e "\n\t${VERDE}[+] Bem vindo,${FIM} $USER!\n"
  while true; do
    echo -e "\n<============== ${AZUL}M${VERDE}e${AMARELO}n${CYANO}u${FIM} ==============>"
    echo -e "\n\t${VERMELHO}\
 [!] Menu de Opções:${FIM}\n\t\
 ${AZUL} 1 Diretório Atual\n\t\
  2 ID do Usuário\n\t\
  3 Maior arquivo\n\t\
  4 Processos em execução\n\t\
  5 Data e hora\n\t\
  6 Hex2Text\n\t\
  7 Tradutor Binario\n\t\
  8 Informações do Sistema\n\t\
  9 Informações de Rede\n\t\
  0 Sair da aplicação${FIM}"
    read -rp "Sua escolha: " opcao_menu #-r para evitar quebrar/bugar o código
    case "$opcao_menu" in
      1) echo "" ;
          ls -la --color ;
          echo -e "\n${CYANO}Caminho:${FIM} " $(pwd) ;;
      2) echo -e "\n${CYANO}Info:${FIM} " $(id) ;;
      3) read -rp "Diretório: " opcao_dir ;
          echo -e "\n${AMARELO}Tamanho | Arquivo\n   V         V${FIM}" ;
          du $opcao_dir -aBM | sort -nr | head -n 10 | more ;;
      4) echo -e "" ;
          ps ;;
      5) echo -e "${CYANO}\n$(date +"%d/%m/%y | %T")${FIM}" ;;
      6) echo -e "${VERDE}\nComo usar:\nHex: 72 73 74${FIM}\n" ;
          _hex_ ;;
      7) echo -e "${VERDE}\nComo usar:\nValor: 255 254 253 251${FIM}\n" ;
          binario_ ;;
      8) echo -e "${VERDE}\nInformações do sistema:${FIM}\n\n" ;
          cat /proc/cpuinfo ; echo -e "\n${VERDE}Informações de memória:${FIM}\n\n" && cat /proc/meminfo ;
          exit 0 ;;
      9) echo -e "${VERDE}\nInformações de rede:${FIM}\n\n" ;
          lspci_ ;;
      0) echo -e "${VERMELHO}\nFinalizando...${FIM}" ;
          exit 0 ;;
    esac
    echo -e "\n<==================================>\n"
  done
else
  if [[ -z "$@" ]]; then
    echo -e "\n\t${RED}Nenhuma senha/argumento inserido${FIM}"
    _Ajuda_
    exit 0
  else
    if [[ "$senha" != "r0dricbr" ]]; then
      echo -e "\n\t${RED}Senha errada!${FIM}\n"
      echo -e "\tUsuário não autorizado\n  \
      esse ato será reportado!\n"
      usuario=$USER
      dia_=$(date +"%d/%m/%y | %T")
      touch $usuario.txt | echo -e "$dia_ - Usuário '$usuario' obteve acesso negado\nComando: $0 $@\n" >> $usuario.txt
    else
      exit 0
    fi
  fi
fi

# Visualizar dispositivos PCI (Informações sobre barramento de hardware):
# $ lspci
# $ echo -e "Controlador de placa de rede: " && lspci | grep -e Ethernet
# Detalhes específicos:
# $ lspci -s 00:03.0 -v ### 00:03.0 é a linha do código de informações lspci

# Informação de CPU
# $ cat /proc/cpuinfo

# Fazer um método pra mudar de senha
# dentro do menu, já logado como r0dricbr
