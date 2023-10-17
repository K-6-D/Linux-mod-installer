#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

game_number=0
steam_directory=""
mod_installer_directory=""

function get_game_number() {
    case "${game_number}" in
        0)
            game_name='MX-Bikes'
            ;;
        1)
            game_name='MX-Bikes'
            ;;
        *)
            echo "game not found"
            ;;
    esac
}
function kill_processes() {
	echo -e "\033[32mPress enter to exit..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    kill -- -$$ 2>/dev/null || true
}
function find_steam_directory() {
    steam_directorys=("$HOME/.local/share/Steam/steamapps" "$HOME/.steam/steam/steamapps")

    for i in "${steam_directorys[@]}"; do
    	if [[ -d "$i" ]]; then
    		steam_directory="$i"
    		break
    	fi
    done

    mod_installer_directory="$steam_directory/mod_installer"
    mod_installer_directory="$steam_directory/mod_installer"readonly mods_backup_directory="$mod_installer_directory/backups"

}
function load_backup() {
    game_directorys=(
	    "$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes"
    )

	if [[ -e "$mods_backup_directory/$game_name-backup.zip" ]]; then
        rm -r "${game_directorys[$game_number]}/mods"/*
		zip "${game_directorys[$game_number]}/mods/" "$mods_backup_directory/$game_name-backup.zip" >/dev/null\
		&& echo -e "${GREEN}Reset finished${NOCOLOR}!."
		sleep 1
    else
        echo -e "${RED}No Game Backup Found${NOCOLOR}!!."
        kill_processes
	fi
}

get_game_number
find_steam_directory
load_backup
kill_processes