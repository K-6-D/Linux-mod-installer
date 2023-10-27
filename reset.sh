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
	echo -e "${GREEN}Press enter to exit${NOCOLOR}..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    exit
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
    mods_backup_directory="$mod_installer_directory/backups"
    readonly mods_list_directory="$mod_installer_directory/installed-mods"

}

function push_update() {
    mapfile -t lines < <(tail -n +4 "$mods_list_directory/$game_name.list")
    for i in "${lines[@]}"; do
        mod_name="$(echo "$i" | cut -f1 -d ',')"
        downloaded="$(echo "$i" | cut -f2 -d ',')"
        active="false"
        checksum="$(echo "$i" | cut -f4 -d ',')"

        sed -i "s/$mod_name.*/$mod_name,$downloaded,$active,$checksum,/" "$mods_list_directory/$game_name.list"
    done
}

function load_backup() {
    game_directorys=(
	    "$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes"
    )

    wget -q --no-check-certificate -O "$mods_backup_directory/$game_name-backup.zip" "https://www.dropbox.com/scl/fi/9op80agupjr30rgqbxbwv/MX-Bikes-backup.zip?rlkey=v5u1fpfs5wmvtlo18ozbr25sd&dl=0"

	if [[ -e "$mods_backup_directory/$game_name-backup.zip" ]]; then
        rm -r "${game_directorys[$game_number]}/mods"
        unzip -o "$mods_backup_directory/$game_name-backup.zip" -d "${game_directorys[$game_number]}" >/dev/null
        push_update
		echo -e "${GREEN}Reset finished${NOCOLOR}!."
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
