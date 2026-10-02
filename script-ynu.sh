#!/bin/bash
set -e

NC='\033[0m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'



echo -e "${BLUE}"
echo "                  ██╗███╗   ██╗██╗ ██████╗██╗ ██████╗ "
echo "                  ██║████╗  ██║██║██╔════╝██║██╔═══██╗"
echo "                  ██║██╔██╗ ██║██║██║     ██║██║   ██║"
echo "                  ██║██║╚██╗██║██║██║     ██║██║   ██║"
echo "                  ██║██║ ╚████║██║╚██████╗██║╚██████╔╝"
echo "                  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝ ╚═════╝ "
echo "                                INICIANDO SCRIPT DE SETUP"
echo -e "${NC}"

echo "Este script configurará o ambiente do sistema com as ferramentas essenciais."
read -p "Quer prosseguir com a instalação? (s/n): " opcao_inicio

if [[ "\(opcao_inicio" =~ ^[Nn]\) ]]; then
    echo -e "\({RED}Script cancelado pelo usuário.\){NC}"
    exit 0
fi

echo -e "\({GREEN}Prosseguindo com o setup...\){NC}"

if ! is_installed figlet; then
    echo -e "\({YELLOW}Instalando Figlet para os banners gráficos...\){NC}"
    sudo pacman -S --noconfirm figlet
fi

echo -e "${YELLOW}"
figlet "ATUALIZANDO"
echo -e "${NC}"

sudo pacman -Syu --noconfirm
echo -e "\({GREEN}\){BOLD}Sistema atualizado com sucesso!${NC}\n"

echo -e "${BLUE}"
figlet "Essenciais"
echo -e "${NC}"

BASE_PACKAGES=(
    mesa vulkan-radeon lib32-vulkan-radeon lib32-mesa go
    lib32-alsa-lib lib32-alsa-plugins lib32-libpulse lib32-openal
    sdl2 sdl2_image sdl2_mixer sdl2_ttf lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf
)

sudo pacman -S --needed --noconfirm "${BASE_PACKAGES[@]}"

echo -e "\n\({BOLD}Verificando pacotes oficiais (Pacman)...\){NC}"
figlet "Pacman"
echo -e "${NC}"

PACMAN_PACKAGES=(
    steam-native-runtime lutris mangohud goverlay gamemode
    wine wine-mono wine-gecko winetricks
    obs-studio telegram-desktop vlc audacity gimp krita
    flameshot gnome-disk-utility gnome-tweaks htop btop
    libreoffice-fresh libreoffice-fresh-pt-br file-roller
    p7zip unrar unzip
)

PACMAN_TO_INSTALL=()
for PKG in "${PACMAN_PACKAGES[@]}"; do
    if ! is_installed "$PKG"; then
        PACMAN_TO_INSTALL+=("$PKG")
    else
        echo -e "\({GREEN}  [OK]\){NC} ${PKG} já está instalado."
    fi
done

if [ ${#PACMAN_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "\({YELLOW}  [INFO]\){NC} Instalando pacotes do repositório oficial..."
    sudo pacman -S --noconfirm "${PACMAN_TO_INSTALL[@]}"
else
    echo -e "\({GREEN}  [SUCESSO]\){NC} Todos os pacotes do Pacman já estavam instalados."
fi

install_yay_if_missing

echo -e "\n\({BOLD}Verificando aplicativos do AUR...\){NC}"
figlet "AUR"
echo -e "${NC}"

AUR_PACKAGES=(
    vesktop
    visual-studio-code-bin
    zapzap
    zen-browser
    camtrix
    peaclock
    cava
)

AUR_TO_INSTALL=()
for PKG in "${AUR_PACKAGES[@]}"; do
    if ! is_installed "$PKG"; then
        AUR_TO_INSTALL+=("$PKG")
    else
        echo -e "\({GREEN}  [OK]\){NC} ${PKG} já está instalado."
    fi
done

if [ ${#AUR_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "\({YELLOW}  [INFO]\){NC} Instalando pacotes AUR: ${AUR_TO_INSTALL[*]}..."
    yay -S --noconfirm "${AUR_TO_INSTALL[@]}"
else
    echo -e "\({GREEN}  [SUCESSO]\){NC} Todos os pacotes do AUR já estavam instalados."
fi

setup_dotfiles

echo -e "${GREEN}"
figlet "Setup Concluido!"
echo -e "${NC}"
