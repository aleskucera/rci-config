#!/bin/bash

HOME_DIR="/home/$(whoami)"
BASHRC_FILE="$HOME_DIR/.bashrc"
COMMANDS_DIR="$HOME_DIR/rci-config/commands"

# Check if projects directory exists
if [ ! -d "$HOME_DIR/projects" ]; then
    echo "WARNING: The projects directory does not exist."
    echo "Read the README.md file for instructions on setting up the projects on RCI."
fi

# Check if the personal storage directory exists
if [ ! -d "/mnt/personal/$(whoami)" ]; then
    echo "WARNING: The /mnt/personal/$USER directory does not exist."
    echo "Read the README.md file for instructions on setting up the personal storage on RCI."
fi

# Make the commands executable
echo "Setting up the commands directory..."
chmod +x "$COMMANDS_DIR"/*

# Ensure that the commands directory is in the PATH in the .bashrc file
if grep -q "$COMMANDS_DIR" "$BASHRC_FILE"; then
    echo "Commands directory is already in the PATH."
else
    echo "Adding commands directory to the PATH..."
    echo "export PATH=\$PATH:$COMMANDS_DIR" >> "$BASHRC_FILE"
fi