#!/bin/bash
set -e # habilita o "exit" caso ocorra erro

# --- Definição das Cores (Adicione isso no início) ---
NC='\033[0m'        # Sem cor (Reset)
GREEN='\033[0;32m'  # Verde
BLUE='\033[0;34m'   # Azul
YELLOW='\033[0;33m' # Amarelo
RED='\033[0;31m'    # Vermelho
BOLD='\033[1m'  # Negrito
# ----------------------------------------------------

# Função para verificar se um pacote está instalado
is_installed() {
pacman -Q "$1" &> /dev/null
return $?
}

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
    sudo pacman -S --noconfirm mesa vulkan-radeon lib32-vulkan-radeon lib32-mesa go
    sudo pacman -S --noconfirm lib32-alsa-lib lib32-alsa-plugins lib32-libpulse lib32-openal
    sudo pacman -S --noconfirm sdl2 sdl2_image sdl2_mixer sdl2_ttf lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf
    
    #----------------------------------------------------------------------------

    # -- Pacotes do AUR (Instalados via YAY) --

    echo -e "\n${BOLD}Verificando e instalando aplicativos (AUR)...${NC}"
    figlet "Aplicativos"
    echo -e "${NC}"

    AUR_PACKAGES=(
        vesktop
        visual-studio-code-bin
        obs-studio
        zapzap
        zen-browser
        telegram-desktop
        camtrix
        peaclock
        cava
    )
    AUR_TO_INSTALL=()

    for PKG in "${AUR_PACKAGES[@]}"; do
        if ! is_installed "$PKG"; then
            AUR_TO_INSTALL+=("$PKG")
        else
            echo -e "${GREEN}  [OK]${NC} ${PKG} já está instalado."
        fi
    done

    # Instala apenas o que está faltando
    if [ ${#AUR_TO_INSTALL[@]} -gt 0 ]; then
        echo -e "${YELLOW}  [INFO]${NC} Instalando pacotes AUR: ${AUR_TO_INSTALL[*]}..."
        yay -S --noconfirm "${AUR_TO_INSTALL[@]}"
    else
        echo -e "${GREEN}  [SUCESSO]${NC} Todos os pacotes AUR já estavam instalados!"
    fi


    # -- Pacotes Oficiais (Instalados via Pacman) --

    echo -e "\n${BOLD}Verificando e instalando pacotes de jogos (Oficial)...${NC}"

    PACMAN_PACKAGES=(
        steam-native-runtime
        lutris
        mangohud
        govelay
        gamemode
        wine
        wine-mono
        wine-gecko
        winetricks
    )
    PACMAN_TO_INSTALL=()

    for PKG in "${PACMAN_PACKAGES[@]}"; do
        if ! is_installed "$PKG"; then
            PACMAN_TO_INSTALL+=("$PKG")
        else
            echo -e "${GREEN}  [OK]${NC} ${PKG} já está instalado."
        fi
    done

    # Instala apenas o que está faltando
    if [ ${#PACMAN_TO_INSTALL[@]} -gt 0 ]; then
        echo -e "${YELLOW}  [INFO]${NC} Instalando pacotes Oficiais: ${PACMAN_TO_INSTALL[*]}..."
        sudo pacman -S --noconfirm "${PACMAN_TO_INSTALL[@]}"
    else
        echo -e "${GREEN}  [SUCESSO]${NC} Todos os pacotes Oficiais já estavam instalados!"
    fi

    # -- Finalização --
    echo -e "${GREEN}"
    figlet "Instalacao Concluida"
    echo -e "${NC}"

    # =========================================================
    # CATEGORIA 3: PRODUTIVIDADE E UTILITÁRIOS (Pacman)
    # =========================================================

    echo -e "\n${BOLD}--- Instalando Utilitários, Produtividade e Mídia ---${NC}"

    # Lista de todos os pacotes ESSENCIAIS (Pacman)
    UTILITIES_PACKAGES=(
        flameshot
        gnome-disk-utility
        gnome-tweaks
        htop
        btop
        vlc
        audacity
        gimp
        krita
        libreoffice-fresh
        libreoffice-fresh-pt-br #Adicionado o pacote de idioma em PT-BR
        file-roller
        p7zip
        unrar
        unzip
    )
    UTILITIES_TO_INSTALL=() # Lista para armazenar apenas os pacotes ausentes

    # Loop de Verificação
    for PKG in "${UTILITIES_PACKAGES[@]}"; do
        if ! is_installed "$PKG"; then
            UTILITIES_TO_INSTALL+=("$PKG")
        else
            echo -e "${GREEN}  [OK]${NC} ${PKG} já está instalado."
        fi
    done

    # Instalação
    if [ ${#UTILITIES_TO_INSTALL[@]} -gt 0 ]; then
        echo -e "${YELLOW}  [INFO]${NC} Instalando Utilitários: ${UTILITIES_TO_INSTALL[*]}..."
        sudo pacman -S --noconfirm "${UTILITIES_TO_INSTALL[@]}"
    else
        echo -e "${GREEN}${BOLD}  [SUCESSO]${NC} Todos os pacotes de utilitários já estavam instalados."
    fi

fi
#teste kskskskskskskskskskksksk