#!/bin/bash


echo "Setting up the commands directory..."
chmod +x "/home/$(whoami)/rci-setup/commands/"*

# Ensure that the commands directory is in the PATH in the .bashrc file
commands_dir="/home/$(whoami)/rci-setup/commands"
if grep -q "$commands_dir" "/home/$(whoami)/.bashrc"; then
    echo "Commands directory is already in the PATH."
else
    echo "Adding commands directory to the PATH..."
    echo "export PATH=\$PATH:/home/$(whoami)/rci-setup/commands" >> "/home/$(whoami)/.bashrc"
fi