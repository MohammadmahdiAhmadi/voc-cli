#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
YELLOW2='\e[33m'
RESET='\033[0m'

# # Check if the script is run with superuser privileges
# if [ "$EUID" -ne 0 ]; then
#     echo -e "${RED}Please run this script as root (sudo).${RESET}"
#     exit 1
# fi

# Function to prompt user for input with default values
prompt_for_input() {
    local prompt="$1"
    local default_value="$2"
    local user_input

    read -p "$prompt [$default_value]: " user_input

    # If user_input is empty, use the default value
    if [ -z "$user_input" ]; then
        user_input="$default_value"
    fi

    echo "$user_input"
}

# Prompt the user for lang_code and user_api_key with default values
trans -T
lang_code=$(prompt_for_input "Enter language code" "fa")
user_api_key=$(prompt_for_input "Enter your api token (Receive from Voc telegram bot)" "")

# Function to install required dependencies based on the Linux distribution
install_dependencies() {
    set -e
    echo -e "${GREEN}Installing required dependencies...${RESET}"

    missing_packages=()
    if ! command -v notify-send &>/dev/null; then
        if command -v apt-get &>/dev/null; then
            missing_packages+=("libnotify-bin")
        else
            missing_packages+=("libnotify")
        fi
    fi
    if ! command -v curl &>/dev/null; then
        missing_packages+=("curl")
    fi
    if ! command -v git &>/dev/null; then
        missing_packages+=("git")
    fi

    # Detect the package manager and install dependencies accordingly
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y "${missing_packages[@]}"
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "${missing_packages[@]}"
    elif command -v yum &>/dev/null; then
        sudo yum install -y "${missing_packages[@]}"
    elif command -v pacman &>/dev/null; then
        # sudo pacman -Syu --noconfirm "${missing_packages[@]}"
        if [ "${#missing_packages[@]}" -gt 0 ]; then
            echo "Please install the following packages: ${missing_packages[*]}"
            exit 1
        fi
    else
        echo -e "${RED}Unsupported Linux distribution. Please install the following packages manually then try again: libnotify, curl, git${RESET}"
        exit 1
    fi

    # install translate-shell from source
    if ! command -v trans &>/dev/null; then
        git clone https://github.com/soimort/translate-shell.git
        cd translate-shell
        make
        sudo make install
        cd ..
        sudo rm -r translate-shell
    fi
    
    echo -e "${GREEN}Dependencies installed successfully.${RESET}"
}

# Function to copy the translation script and pass variables
install_translation_script() {
    echo -e "${GREEN}Copying the scripts to /usr/bin/...${RESET}"

    sudo cp ./scripts/voc-trans.sh /usr/bin/voc-trans
    sudo cp ./scripts/voc-trans.sh /usr/bin/voc-only-trans
    sudo cp ./scripts/voc-play-trans.sh /usr/bin/voc-play-trans
    sudo cp ./scripts/voc-shortcut-keys.sh /usr/bin/voc-shortcut-keys
    sudo cp ./scripts/voc-cli.sh /usr/bin/voc-cli

    sudo chmod +x /usr/bin/voc-trans
    sudo chmod +x /usr/bin/voc-only-trans
    sudo chmod +x /usr/bin/voc-play-trans
    sudo chmod +x /usr/bin/voc-shortcut-keys
    sudo chmod +x /usr/bin/voc-cli

    # Set the lang_code and user_api_key in /usr/bin/voc-trans
    sudo sed -i "s/lang_code=\"fa\"/lang_code=\"$lang_code\"/" /usr/bin/voc-trans
    sudo sed -i "s/user_api_key=\"\"/user_api_key=\"$user_api_key\"/" /usr/bin/voc-trans

    # Set the lang_code and user_api_key in /usr/bin/voc-only-trans
    sudo sed -i "s/lang_code=\"fa\"/lang_code=\"$lang_code\"/" /usr/bin/voc-only-trans
    
    # Set the lang_code and user_api_key in /usr/bin/voc-play-trans
    sudo sed -i "s/lang_code=\"fa\"/lang_code=\"$lang_code\"/" /usr/bin/voc-play-trans

    echo -e "${GREEN}Translation script copied and variables set.${RESET}"
}

# Main installation process
install_dependencies
install_translation_script

key_combination_voc_trans="Alt+S"
key_combination_voc_only_trans="Alt+Q"
key_combination_voc_play_trans="Alt+V"

voc-shortcut-keys $key_combination_voc_trans /usr/bin/voc-trans
voc-shortcut-keys $key_combination_voc_only_trans /usr/bin/voc-only-trans
voc-shortcut-keys $key_combination_voc_play_trans /usr/bin/voc-play-trans

echo -e "${GREEN}Installation completed successfully.${RESET}"

echo -e "You can select a text and press '${YELLOW}$key_combination_voc_trans${RESET}' to see translation and save into your Voc account"
echo -e "Also you can select a text and press '${YELLOW}$key_combination_voc_only_trans${RESET}' to see translation without saving into your Voc account"
echo -e "Also you can select a text and press '${YELLOW}$key_combination_voc_play_trans${RESET}' to listen to the pronunciation"
echo -e "And, of course, you can modify keys, but pay attention to ensure that the keys are not in use."
echo -e "Run 'voc-cli' command in terminal to manage voc-cli: Modify language code, Modify api token, Set new shortcut keys, Delete shortcut keys, Uninstall voc-cli"
