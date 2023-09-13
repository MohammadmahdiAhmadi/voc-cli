#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to set a keyboard shortcut
set_shortcut() {
    # Define the key combination and the command to run.
    key_combination=$1
    command_to_run=$2

    # Check for GNOME
    if [ -n "$XDG_CURRENT_DESKTOP" ] && [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Translate"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$command_to_run"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "$key_combination"

        echo -e "${GREEN}Shortcut set for GNOME:${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
        echo -e "Command: ${GREEN}$command_to_run${NC}"
    fi

    # Check for KDE
    if [ -n "$XDG_CURRENT_DESKTOP" ] && [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
        kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group "Custom Shortcuts" --key "$key_combination" "$command_to_run"
        echo -e "${GREEN}Shortcut set for KDE:${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
        echo -e "Command: ${GREEN}$command_to_run${NC}"
    fi

    # Check for Xfce
    if [ -n "$XDG_CURRENT_DESKTOP" ] && [[ "$XDG_CURRENT_DESKTOP" == *"Xfce"* ]]; then
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$key_combination" -n -t string -s "$command_to_run"
        echo -e "${GREEN}Shortcut set for Xfce:${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
        echo -e "Command: ${GREEN}$command_to_run${NC}"
    fi

    # Check for generic X Window System (X11)
    if [ -n "$DISPLAY" ]; then
        xbindkeys -f ~/.xbindkeysrc
        echo -e "\"$command_to_run\"\n  $key_combination" >> ~/.xbindkeysrc
        echo -e "${GREEN}Shortcut set for generic X Window System (X11):${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
        echo -e "Command: ${GREEN}$command_to_run${NC}"
    fi
}

# Function to delete a keyboard shortcut
delete_shortcut() {
    key_combination=$1

    # Check for GNOME
    if [ -n "$XDG_CURRENT_DESKTOP" ] && [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/
        echo -e "${GREEN}Shortcut deleted for GNOME:${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
    fi

    # Check for KDE
    if [ -n "$XDG_CURRENT_DESKTOP" ] && [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
        kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group "Custom Shortcuts" --key "$key_combination" ""
        echo -e "${GREEN}Shortcut deleted for KDE:${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
    fi

    # Check for Xfce
    if [ -n "$XDG_CURRENT_DESKTOP" ] && [[ "$XDG_CURRENT_DESKTOP" == *"Xfce"* ]]; then
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$key_combination" -r
        echo -e "${GREEN}Shortcut deleted for Xfce:${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
    fi

    # Check for generic X Window System (X11)
    if [ -n "$DISPLAY" ]; then
        sed -i "/$key_combination/d" ~/.xbindkeysrc
        xbindkeys -p
        echo -e "${GREEN}Shortcut deleted for generic X Window System (X11):${NC}"
        echo -e "Key combination: ${GREEN}$key_combination${NC}"
    fi
}

### Main ###

# Check if the 'xdotool' utility is installed (used for simulating key presses).
if ! command -v xdotool &> /dev/null; then
    echo -e "${RED}Error:${NC} xdotool is not installed. Please install it to use this script."
    exit 1
fi

# Check for generic X Window System (X11)
if [ -n "$DISPLAY" ]; then
    # Check if 'xbindkeys' is installed
    if ! command -v xbindkeys &> /dev/null; then
        echo -e "${RED}Error:${NC} xbindkeys is not installed. Please install it to use this script for X11."
        exit 1
    fi
fi

if [ $# -lt 1 ]; then
    echo -e "Usage: $0 ${GREEN}<arg1> [arg2]${NC}"
    echo -e "<arg1>: Keyboard shortcut like ${GREEN}Alt+F${NC}"
    echo -e "[arg2]: Command to run (optional) like ${GREEN}/usr/bin/command.sh${NC}"
    echo -e "To delete a shortcut: $0 ${GREEN}-d <arg1>${NC}"
    exit 1
fi

# Check if the first argument is '-d' for deleting a shortcut
if [ "$1" == "-d" ]; then
    if [ $# -ne 2 ]; then
        echo -e "Usage: $0 ${GREEN}-d <arg1>${NC}"
        echo -e "<arg1>: Keyboard shortcut to delete like ${GREEN}Alt+Q${NC}"
        exit 1
    fi
    delete_shortcut "$2"

    echo -e "Shortcut deleted successfuly."
    echo ""
else
    if [ $# -ne 2 ]; then
        echo -e "Usage: $0 ${GREEN}<arg1> <arg2>${NC}"
        echo -e "<arg1>: Keyboard shortcut like ${GREEN}Alt+Q${NC}"
        echo -e "<arg2>: Command to run like ${GREEN}/usr/bin/command.sh${NC}"
        exit 1
    fi

    # Set the new keyboard shortcut
    set_shortcut "$1" "$2"

    # (Code to set the shortcut is the same as in your original script)

    echo -e "Shortcut configuration completed."
    echo ""
fi
