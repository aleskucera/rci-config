#!/bin/bash

HOME_DIR="/home/$(whoami)"
BASHRC_FILE="$HOME_DIR/.bashrc"
RCI_COMMANDS_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")commands/rci"

# Check if projects directory exists
if [ ! -d "$HOME_DIR/projects" ]; then
    echo "WARNING: The projects directory does not exist."
    echo "Read the README.md file for instructions on setting up the projects on RCI."
fi

# Make the commands executable
echo "Configuring commands..."
chmod +x "$RCI_COMMANDS_DIR"/*

# Ensure that the commands directory is in the PATH in the .bashrc file
if grep -q "$RCI_COMMANDS_DIR" "$BASHRC_FILE"; then
    echo "Commands directory is already in the PATH."
else
    echo "Adding commands directory to the PATH..."
    echo "export PATH=\$PATH:$RCI_COMMANDS_DIR" >> "$BASHRC_FILE"
    source "$BASHRC_FILE"
fi