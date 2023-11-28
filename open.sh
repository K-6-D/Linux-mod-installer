#!/bin/bash

function find_steam_directory() {
    steam_directorys=("$HOME/.local/share/Steam/steamapps" "$HOME/.steam/steam/steamapps")

    for i in "${steam_directorys[@]}"; do
    	if [[ -d "$i" ]]; then
    		steam_directory="$i"
    		break
    	fi
    done
}

find_steam_directory

dolphin "$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes"