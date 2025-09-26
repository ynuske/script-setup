 #!/bin/bash
set -e # habilita o "exit" caso ocorra erro

# Cores para o terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # sem cor

echo "                  ██╗███╗   ██╗██╗ ██████╗██╗ ██████╗ "
echo "                  ██║████╗  ██║██║██╔════╝██║██╔═══██╗"
echo "                  ██║██╔██╗ ██║██║██║     ██║██║   ██║"
echo "                  ██║██║╚██╗██║██║██║     ██║██║   ██║"
echo "                  ██║██║ ╚████║██║╚██████╗██║╚██████╔╝"
echo "                  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝ ╚═════╝ "
echo "                              INICIANDO SCRIPT DE SETUP"

echo "Este script irá configurar o seu ambiente de desenvolvimento com as ferramentas essenciais."
echo "Quer prosseguir com o script? (${GREEN}s${NC}/${RED}n${NC})"
read opcao_inicio #verifica se o usuario quer prosseguir com o script

if [ "$opcao_inicio" != "s" ]; then
    echo "Script cancelado pelo usuário."
    exit 0
else
    echo "Prosseguindo com o script..."
    

fi