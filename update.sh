#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

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
        'https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/reset.sh'
        'https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/update.sh'
    )
    executables=(
        "$mod_installer_directory/run.sh"
        "$mod_installer_directory/reset.sh"
        "$mod_installer_directory/update.sh"
    )

    counter=0

    for link in "${github_links[@]}"; do
        if curl -sSL "$link" > "${executables[$counter]}"; then
            chmod +x "${executables[counter]}"
        else
            echo -e "${RED}Failed to update: ${github_links[$counter]}${NOCOLOR}"
            kill_processes
        fi
        ((counter++))
    done

}
function make_desktop_sortcuts() {
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
    names_desktop=(
        'mod-installer'
        'reset'
        'update'
    )
    counter=0
    
    for link in "${logo_links[@]}"; do
        if [ ! -e "${logo_names[$counter]}" ]; then
            if wget -q -O "${logo_names[$counter]}" "$link"; then
                echo "[Desktop Entry]
                Name=${names_desktop[$counter]}
                Exec=${executables[$counter]}
                Icon=${logo_names[$counter]}
                Terminal=true
                Type=Application
                StartupNotify=true"\
                > "$HOME/Desktop/${names_desktop[$counter]}.desktop" && \
                chmod +x "$HOME/Desktop/${names_desktop[$counter]}.desktop"
            else
                echo -e "${RED}Failed to download logo: ${logo_links[$counter]}${NOCOLOR}"
                kill_processes
            fi
        fi
        ((counter++))
    done
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