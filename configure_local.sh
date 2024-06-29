#!/bin/bash

BASHRC_FILE="/home/$(whoami)/.bashrc"
LOCAL_COMMANDS_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/commands/local"


echo ""
echo "==== Configuring local environment ===="
echo ""

# Prompt for the username on rci
read -r -p "Enter your username on RCI: " rci_user

# Make sure that the RCI_USER environment variable is in the .bashrc file
if grep -q "RCI_USER" "$BASHRC_FILE"; then
    sed -i "s/RCI_USER=.*/RCI_USER=$rci_user/" "$BASHRC_FILE"
else
    echo "export RCI_USER=$rci_user" >> "$BASHRC_FILE"
fi

echo "Configured RCI_USER environment variable."
echo ""

echo "Configuring the local commands directory..."
chmod +x "$LOCAL_COMMANDS_DIR"/*

# Check if the local commands directory is in the PATH in the .bashrc file
if grep -q "$LOCAL_COMMANDS_DIR" "$BASHRC_FILE"; then
    echo "Local commands directory is already in the PATH."
else
    echo "Adding local commands directory to the PATH..."
    echo "export PATH=\$PATH:$LOCAL_COMMANDS_DIR" >> "$BASHRC_FILE"
    source "$BASHRC_FILE"
fi

echo ""
echo "Local environment configured successfully."
echo "Please restart your terminal session for the changes to take effect."
echo ""