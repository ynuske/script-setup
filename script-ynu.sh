#!/bin/bash
set -e # Interrompe a execução em caso de erro não tratado

# =========================================================
# CONFIGURAÇÕES E VARIÁVEIS
# =========================================================

# --- Cores (ANSI) ---
NC='\033[0m'        # Sem cor (Reset)
GREEN='\033[0;32m'  # Verde
BLUE='\033[0;34m'   # Azul
YELLOW='\033[0;33m' # Amarelo
RED='\033[0;31m'    # Vermelho
BOLD='\033[1m'      # Negrito

# --- Dotfiles ---
# Altere para a URL do seu repositório pessoal no GitHub/GitLab
DOTFILES_REPO="https://github.com/SEU_USUARIO/MEU_REPOSITORIO_DOTFILES.git"
DOTFILES_DIR="$HOME/dotfiles"

# =========================================================
# FUNÇÕES AUXILIARES
# =========================================================

# Verifica se um pacote está instalado no sistema via pacman
is_installed() {
    pacman -Q "$1" &> /dev/null
    return $?
}

# Verifica e instala o YAY (helper AUR) caso não esteja presente
install_yay_if_missing() {
    if ! command -v yay &> /dev/null; then
        echo -e "${YELLOW}[INFO] 'yay' não encontrado. Instalando a partir do AUR...${NC}"
        
        # Garante dependências de compilação
        sudo pacman -S --needed --noconfirm base-devel git

        # Cria diretório temporário para compilação segura
        local TEMP_DIR
        TEMP_DIR=$(mktemp -d)

        echo -e "${BLUE}Clonando e compilando 'yay-bin'...${NC}"
        git clone https://aur.archlinux.org/yay-bin.git "$TEMP_DIR/yay-bin"
        
        # Compila e instala
        (
            cd "$TEMP_DIR/yay-bin" || exit 1
            makepkg -si --noconfirm
        )

        # Limpeza
        rm -rf "$TEMP_DIR"
        echo -e "${GREEN}[SUCESSO] 'yay' instalado com sucesso!${NC}\n"
    else
        echo -e "${GREEN}[OK] Gerenciador AUR 'yay' já está instalado.${NC}"
    fi
}

# Clona e aplica as configurações do repositório de dotfiles usando GNU Stow
setup_dotfiles() {
    echo -e "\n${BOLD}--- Configurando Dotfiles ---${NC}"
    figlet "Dotfiles"
    echo -e "${NC}"

    # Instala utilitários necessários
    sudo pacman -S --needed --noconfirm git stow

    # Clona ou atualiza o repositório
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo -e "${YELLOW}[INFO] Clonando repositório de dotfiles...${NC}"
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        echo -e "${GREEN}[OK] Repositório de dotfiles encontrado. Atualizando...${NC}"
        git -C "$DOTFILES_DIR" pull
    fi

    # Aplica os symlinks
    cd "$DOTFILES_DIR" || exit 1

    for config_app in */; do
        app_name="${config_app%/}"
        echo -e "${BLUE}Aplicando links para: ${BOLD}${app_name}${NC}"
        
        # Tenta aplicar com o stow, forçando substituição em caso de conflitos simples
        stow --restow --target="$HOME" "$app_name" 2>/dev/null || {
            echo -e "${YELLOW}  [Aviso] Conflito em '${app_name}'. Forçando link...${NC}"
            stow --adopt --target="$HOME" "$app_name"
            git checkout . # Restaura modificações geradas pelo --adopt
        }
    done

    echo -e "${GREEN}[SUCESSO] Dotfiles aplicados com sucesso!${NC}\n"
}

# =========================================================
# INÍCIO DO SCRIPT
# =========================================================

echo -e "${BLUE}"
echo "                  ██╗███╗   ██╗██╗ ██████╗██╗ ██████╗ "
echo "                  ██║████╗  ██║██║██╔════╝██║██╔═══██╗"
echo "                  ██║██╔██╗ ██║██║██║     ██║██║   ██║"
echo "                  ██║██║╚██╗██║██║██║     ██║██║   ██║"
echo "                  ██║██║ ╚████║██║╚██████╗██║╚██████╔╝"
echo "                  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝ ╚═════╝ "
echo "                              INICIANDO SCRIPT DE SETUP"
echo -e "${NC}"

echo "Este script configurará o ambiente do sistema com as ferramentas essenciais."
read -p "Quer prosseguir com a instalação? (s/n): " opcao_inicio

if [[ "$opcao_inicio" =~ ^[Nn]$ ]]; then
    echo -e "${RED}Script cancelado pelo usuário.${NC}"
    exit 0
fi

echo -e "${GREEN}Prosseguindo com o setup...${NC}"

# 1. Garante que o figlet esteja instalado ANTES de gerar os banners
if ! is_installed figlet; then
    echo -e "${YELLOW}Instalando Figlet para os banners gráficos...${NC}"
    sudo pacman -S --noconfirm figlet
fi

# =========================================================
# ATUALIZAÇÃO DO SISTEMA
# =========================================================

echo -e "${YELLOW}"
figlet "ATUALIZANDO"
echo -e "${NC}"

sudo pacman -Syu --noconfirm
echo -e "${GREEN}${BOLD}Sistema atualizado com sucesso!${NC}\n"

# =========================================================
# PACOTES BASE & DRIVERS (Pacman)
# =========================================================

echo -e "${BLUE}"
figlet "Essenciais"
echo -e "${NC}"

BASE_PACKAGES=(
    mesa vulkan-radeon lib32-vulkan-radeon lib32-mesa go
    lib32-alsa-lib lib32-alsa-plugins lib32-libpulse lib32-openal
    sdl2 sdl2_image sdl2_mixer sdl2_ttf lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf
)

sudo pacman -S --needed --noconfirm "${BASE_PACKAGES[@]}"

# =========================================================
# APLICATIVOS OFICIAIS (Pacman)
# =========================================================

echo -e "\n${BOLD}Verificando pacotes oficiais (Pacman)...${NC}"
figlet "Pacman"
echo -e "${NC}"

PACMAN_PACKAGES=(
    # Jogos e Compatibilidade
    steam-native-runtime lutris mangohud goverlay gamemode
    wine wine-mono wine-gecko winetricks
    # Mídia e Comunicação
    obs-studio telegram-desktop vlc audacity gimp krita
    # Utilitários e Produtividade
    flameshot gnome-disk-utility gnome-tweaks htop btop
    libreoffice-fresh libreoffice-fresh-pt-br file-roller
    p7zip unrar unzip
)

PACMAN_TO_INSTALL=()
for PKG in "${PACMAN_PACKAGES[@]}"; do
    if ! is_installed "$PKG"; then
        PACMAN_TO_INSTALL+=("$PKG")
    else
        echo -e "${GREEN}  [OK]${NC} ${PKG} já está instalado."
    fi
done

if [ ${#PACMAN_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "${YELLOW}  [INFO]${NC} Instalando pacotes do repositório oficial..."
    sudo pacman -S --noconfirm "${PACMAN_TO_INSTALL[@]}"
else
    echo -e "${GREEN}  [SUCESSO]${NC} Todos os pacotes do Pacman já estavam instalados."
fi

# =========================================================
# APLICATIVOS DO AUR (YAY)
# =========================================================

# Instala o YAY se necessário
install_yay_if_missing

echo -e "\n${BOLD}Verificando aplicativos do AUR...${NC}"
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
        echo -e "${GREEN}  [OK]${NC} ${PKG} já está instalado."
    fi
done

if [ ${#AUR_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "${YELLOW}  [INFO]${NC} Instalando pacotes AUR: ${AUR_TO_INSTALL[*]}..."
    yay -S --noconfirm "${AUR_TO_INSTALL[@]}"
else
    echo -e "${GREEN}  [SUCESSO]${NC} Todos os pacotes do AUR já estavam instalados."
fi

# =========================================================
# DOTFILES E FINALIZAÇÃO
# =========================================================

# Restaura as configurações do usuário via Stow
setup_dotfiles

echo -e "${GREEN}"
figlet "Setup Concluido!"
echo -e "${NC}"
