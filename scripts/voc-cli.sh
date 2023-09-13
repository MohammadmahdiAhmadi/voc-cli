#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to modify variables in script files
modify_script_variables() {
    local script_path="$1"
    local variable_name="$2"
    local new_value="$3"

    if [ -e "$script_path" ]; then
        sudo sed -i "s/$variable_name=.*$/$variable_name=\"$new_value\"/" "$script_path"
        echo -e "${GREEN}Modified $variable_name in $script_path${NC}"
    else
        echo -e "${RED}Script file $script_path not found.${NC}"
    fi
}

# Function to uninstall all scripts
uninstall_scripts() {
    echo -e "${YELLOW}Uninstalling voc-cli...${NC}"
    sudo rm -f /usr/bin/voc-trans /usr/bin/voc-only-trans /usr/bin/voc-play-trans /usr/bin/voc-shortcut-keys
    echo -e "${GREEN}voc-cli uninstalled successfully.${NC}"
    sudo rm -f "$0"
}

# Function to delete a shortcut key
delete_shortcut_key() {
    local shortcut_key="$1"
    voc-shortcut-keys -d "$shortcut_key"
    echo -e "${GREEN}Shortcut key $shortcut_key deleted.${NC}"
}

# Main menu
while true; do
    echo -e "${BLUE}Choose an option:${NC}"
    echo "1. Modify language code"
    echo "2. Modify api token"
    echo "3. Set new shortcut keys"
    echo "4. Delete shortcut keys"
    echo "5. Uninstall voc-cli"
    echo "6. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            trans -T
            read -p "Enter new language code: " new_lang_code
            modify_script_variables "/usr/bin/voc-trans" "lang_code" "$new_lang_code"
            modify_script_variables "/usr/bin/voc-only-trans" "lang_code" "$new_lang_code"
            modify_script_variables "/usr/bin/voc-play-trans" "lang_code" "$new_lang_code"
            ;;
        2)
            read -p "Enter your api token (Receive from Voc telegram bot): " new_user_api_key
            modify_script_variables "/usr/bin/voc-trans" "user_api_key" "$new_user_api_key"
            ;;
        3)
            PS3="Select a command to set keys: "
            options=("All" "Translate Script" "Only Translate Script" "Play Voice Script" "Cancel")
            select script_title in "${options[@]}"; do
                case $script_title in
                    "All")
                        script_paths=("/usr/bin/voc-trans" "/usr/bin/voc-only-trans" "/usr/bin/voc-play-trans")
                        break
                        ;;
                    "Translate Script")
                        script_paths=("/usr/bin/voc-trans")
                        break
                        ;;
                    "Only Translate Script")
                        script_paths=("/usr/bin/voc-only-trans")
                        break
                        ;;
                    "Play Voice Script")
                        script_paths=("/usr/bin/voc-play-trans")
                        break
                        ;;
                    "Cancel")
                        echo -e "${YELLOW}Cancelled.${NC}"
                        break
                        ;;
                    *) echo -e "${RED}Invalid option. Please select a valid script title.${NC}";;
                esac
            done

            if [ "$script_title" != "Cancel" ]; then
                for script_path in "${script_paths[@]}"; do
                    read -p "Enter shortcut keys for $script_title (e.g., 'Alt+Q'): " shortcut_keys
                    voc-shortcut-keys "$shortcut_keys" "$script_path"
                    echo -e "${GREEN}Shortcut keys configured successfully for $script_title.${NC}"
                done
            fi
            ;;
        4)
            read -p "Enter the shortcut key to delete (e.g., 'Alt+Q'): " shortcut_key_to_delete
            delete_shortcut_key "$shortcut_key_to_delete"
            ;;
        5)
            uninstall_scripts
            exit 0
            ;;
        6)
            echo -e "${BLUE}Exiting voc-cli management.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please choose a valid option.${NC}"
            ;;
    esac
done
