#!/usr/bin/env bash

# A script to update een CLI to latest release on github

REPO="EENCloud/EEN-CLI-Public"
INSTALL_DIR="$HOME/.local/bin"
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name')

get_update(){
    echo -e "\e[36mGetting latest version $LATEST_VERSION\e[0m"
    wget "https://github.com/EENCloud/EEN-CLI-Public/releases/download/$LATEST_VERSION/linux-executable.zip" -O "$INSTALL_DIR"/een.zip
}


install_clean(){
    echo -e "\e[36mUpdating EEN CLI...\e[0m"
    yes | unzip "$INSTALL_DIR"/een.zip -d "$INSTALL_DIR"
    if [[ $? -eq 0 ]]; then
        rm "$INSTALL_DIR"/een.zip
        echo -e "\e[32mUpdated successfully\e[0m"
        exit 0
    else
        echo -e "\e[31mUpdate failed while extracting zip archive\e[0m"
        exit 1
    fi
}

echo -e "\e[36mChecking for updates...\e[0m"

# stupid_check=$("$INSTALL_DIR"/een --version | wc -l)

current_ver=$("$INSTALL_DIR"/een --version | awk '/^v/ {print $1}')

if [[ "$current_ver" == "$LATEST_VERSION" ]]; then
# if [[ "$stupid_check" -eq 1 ]]; then
    echo -e "\e[32mAlready on latest version\e[0m"
    "$INSTALL_DIR"/een --version
    exit 2
else
    get_update
    install_clean
fi
