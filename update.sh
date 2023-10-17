#!/bin/bash
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NOCOLOR='\033[0m'
steam_directory=""
mod_installer_directory=""
mod_images_directory=""

function kill_processes() {
	echo -e "\033[32mPress enter to exit..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    kill -- -$$ 2>/dev/null || true
}
function ping_wan() {
    if wget --spider --quiet "https://www.cloudflare.com/" &>/dev/null; then
        echo -e "${GREEN}Internet is up${NOCOLOR}"
    else
        echo -e "[${RED}Internet is down${NOCOLOR}]"
        kill_processes
    fi
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
    mod_images_directory="$mod_installer_directory/images"
}
function create_directorys() {
    create_directorys=(
        "$mod_installer_directory" 
        "$mod_images_directory"
    )

	for i in "${create_directorys[@]}"; do
		if [[ ! -d "$i" ]]; then
			if mkdir "$i"; then
	    		echo -e "${GREEN}Directory Created${NOCOLOR}"
			else
				echo -e "${RED}Failed to create Directory!${NOCOLOR}"
				kill_processes
			fi
	    else
	    	echo -e "${GREEN}Directory Already Created${NOCOLOR}"
	    fi
	    sleep .2
	done
}
function download_files() {
    github_links=(
        'https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/mod-installer.sh'
        'https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/update.sh'
        'https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/update.sh'
    )
    executables=(
        "$mod_installer_directory/run.sh"
        "$mod_installer_directory/reset.sh"
        "$mod_installer_directory/update.sh"
    )

    counter=0

    for links in "${github_links[@]}"; do
        wget -q -O "${executables[$counter]}" "$links"
        chmod +x "${executables[counter]}"
        (( counter++ ))
    done

}
function make_desktop_sortcuts() {
    counter=0
    logo_names=(
        "$mod_images_directory/logo.png"      
        "$mod_images_directory/reset-logo.png"
        "$mod_images_directory/update-logo.png"
    )
    logo_links=(
        'https://t4.ftcdn.net/jpg/01/21/22/57/360_F_121225745_6MScSAbSWYSWlRsPJonDPPDcp84BrdKo.jpg'
        'https://images.squarespace-cdn.com/content/54b55e28e4b04d469d0fc8eb/1504188257429-JM5TDS0REGART87DKJ8P/reset+button?format=1500w&content-type=image%2Fjpeg'
        'https://www.stpaulschool.ca/wp-content/uploads/2021/01/New-Update.png'
    )

    for links in "${logo_links[@]}"; do
    	wget -q -O "${logo_names[$counter]}" "$links"
    	((counter++))
    done
	#------------------------------
	echo "[Desktop Entry]
	Name=Mod Installer
	Exec=${executables[0]}
	Icon=${logo_names[0]}
	Terminal=true
	Type=Application
	StartupNotify=true"\
	> "$HOME/Desktop/Deck-installer.desktop" &&\
	chmod +x "$HOME/Desktop/Deck-installer.desktop"
	#------------------------------
	echo "[Desktop Entry]
	Name=Reset
	Exec=${executables[1]}
	Icon=${logo_names[1]}
	Terminal=true
	Type=Application
	StartupNotify=true"\
	> "$HOME/Desktop/reset.desktop" &&\
	chmod +x "$HOME/Desktop/reset.desktop"
	#------------------------------
	echo "[Desktop Entry]
	Name=Update
	Exec=${executables[2]}
	Icon=${logo_names[2]}
	Terminal=true
	Type=Application
	StartupNotify=true"\
	> "$HOME/Desktop/update.desktop" &&\
	chmod +x "$HOME/Desktop/update.desktop"
	#------------------------------
}

ping_wan

find_steam_directory

create_directorys

download_files

make_desktop_sortcuts

echo -e "${GREEN}Updated${NOCOLOR}!."
echo -e "${GREEN}Press enter to Continue${NOCOLOR}..."
read -r
bash "${executables[0]}" && exit