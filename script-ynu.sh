1 #!/bin/bash
set -e # habilita o "exit" caso ocorra erro

# --- Definição das Cores (Adicione isso no início) ---
NC='\033[0m'        # Sem cor (Reset)
GREEN='\033[0;32m'  # Verde
BLUE='\033[0;34m'   # Azul
YELLOW='\033[0;33m' # Amarelo
RED='\033[0;31m'    # Vermelho
BOLD='\033[1m'  # Negrito
# ----------------------------------------------------

echo "                  ██╗███╗   ██╗██╗ ██████╗██╗ ██████╗ "
echo "                  ██║████╗  ██║██║██╔════╝██║██╔═══██╗"
echo "                  ██║██╔██╗ ██║██║██║     ██║██║   ██║"
echo "                  ██║██║╚██╗██║██║██║     ██║██║   ██║"
echo "                  ██║██║ ╚████║██║╚██████╗██║╚██████╔╝"
echo "                  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝ ╚═════╝ "
echo "                              INICIANDO SCRIPT DE SETUP"

echo "Este script irá configurar o seu ambiente de desenvolvimento com as ferramentas essenciais."
echo "Quer prosseguir com o script? (s/n)"
read opcao_inicio #verifica se o usuario quer prosseguir com o script

# Verifica se o figlet está instalado e instala se necessário
if ! command -v figlet &> /dev/null
then
    echo -e "${YELLOW}Instalando Figlet para criar o banner...${NC}"
    sudo pacman -S figlet --noconfirm
fi

#----------------------------------------------------------------------------

if [ "$opcao_inicio" = "n" ]; then
    echo "${RED}Script cancelado pelo usuário.${NC}"
    exit 0
else
    echo -e "${GREEN}Prosseguindo com o script...${NC}" # Exemplo de cor verde
    echo -e "${YELLOW}" # Inicia a cor Amarela
    figlet "ATUALIZANDO" # Cria o banner grande
    echo -e "${NC}" # Reseta a cor
    sudo pacman -Syu --noconfirm
    echo -e "${GREEN}${BOLD}Sistema atualizado com sucesso!${NC}" # Exemplo de verde e negrito
    
    #----------------------------------------------------------------------------

    echo -e "${BLUE}" #inicia a cor azul
    figlet "Pacotes Essenciais"
    echo -e "${NC}" # Reseta a cor
    sudo pacman -S --noconfirm mesa vulkan-radeon lib32-vulkan-radeon lib32-mesa
    sudo pacman -S --noconfirm lib32-alsa-lib lib32-alsa-plugins lib32-libpulse lib32-openal
    sudo pacman -S --noconfirm sdl2 sdl2_image sdl2_mixer sdl2_ttf lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf
    
    #----------------------------------------------------------------------------

    echo -e "${BLUE}" #inicia a cor azul
    figlet "Aplicativos"
    echo -e "${NC}" # Reseta a cor
    echo -e "${YELLOW}" # Inicia a cor Amarela
    sudo pacman -S --noconfirm vesktop visual-studio-code-bin obs-studio zapzap zen-browser telegram-desktop camtrix peaclock cava
    echo -e "${NC}" # Reseta a cor
    sudo pacman -S --noconfirm steam-native-runtime lutris mangohud goverlay gamemode wine wine-mono wine-gecko winetricks
    echo -e "${GREEN}"
    figlet "Instalação Concluída"
    echo -e "${NC}" # Reseta a cor








fi