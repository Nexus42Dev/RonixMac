#!/bin/bash

main() {
    clear
    echo -e "Ronix Mac Install Script - Begin"
    curl -s "https://git.raptor.fun/main/jq-macos-amd64" -o "./jq"
    chmod +x ./jq

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local versionInfo=$(curl -s "https://raw.githubusercontent.com/Nexus42Dev/RonixMac/refs/heads/main/version.json")
    
    local mChannel=$(echo $versionInfo | ./jq -r ".channel")
    local version=$(echo $versionInfo | ./jq -r ".\"roblox-client\"")
    curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    
    echo -n "Installing Latest Roblox... "
    [ -d "./Applications/Roblox.app" ] && rm -rf "./Applications/Roblox.app"
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"

    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading Ronix Mac..."
    curl "https://raw.githubusercontent.com/Nexus42Dev/RonixMac/refs/heads/main/main/ronix.zip" -o "./ronix.zip"

    echo -n "Installing Ronix Mac... "
    unzip -o -q "./ronix.zip"
    echo -e "Done."

    echo -n "Updating Dylib..."
    curl -Os "https://raw.githubusercontent.com/Nexus42Dev/RonixMac/refs/heads/main/$mChannel/libRonix.dylib"
    
    echo -e " Done."
    echo -e "Patching Roblox..."
    mv ./libRonix.dylib "/Applications/Roblox.app/Contents/MacOS/libRonix.dylib"
    ./insert_dylib "/Applications/Roblox.app/Contents/MacOS/libRonix.dylib" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    rm -r "/Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app"
    rm ./insert_dylib

    echo -n "Installing Ronix App... "
    [ -d "/Applications/Ronix.app" ] && rm -rf "/Applications/Ronix.app"
    mv "./Ronix Mac.app" "/Applications/Ronix Mac.app"
    rm ./ronix.zip
    rm ./jq

    echo -e "Done."
    echo -e "Install Complete! Created by Nexus42 and Frame!"
    exit
}

main
