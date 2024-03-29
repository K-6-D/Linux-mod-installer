#!/bin/bash
function all() {
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NOCOLOR='\033[0m'

    steam_directory=""
    mod_installer_directory=""
    mod_images_directory=""

    function kill_processes() {
    	echo -e "${GREEN}Press enter to exit${NOCOLOR}..."
    	read -r
        echo -e "${RED}killed...${NOCOLOR}"
        sleep .1
        exit
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
            'https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/open.sh'
        )
        executables=(
            "$mod_installer_directory/run.sh"
            "$mod_installer_directory/reset.sh"
            "$mod_installer_directory/update.sh"
            "$mod_installer_directory/open.sh"
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
            "$mod_images_directory/open.png"
        )
        logo_links=(
            'https://t4.ftcdn.net/jpg/01/21/22/57/360_F_121225745_6MScSAbSWYSWlRsPJonDPPDcp84BrdKo.jpg'
            'https://images.squarespace-cdn.com/content/54b55e28e4b04d469d0fc8eb/1504188257429-JM5TDS0REGART87DKJ8P/reset+button?format=1500w&content-type=image%2Fjpeg'
            'https://www.stpaulschool.ca/wp-content/uploads/2021/01/New-Update.png'
            'https://lh3.googleusercontent.com/Qq8jgBfsLRsv_51_7cAOKHpCG_6NnXqrmfCVF9DOlVtVDu7-0NoMZBHd_v173vq-LtLiexyEY6HB318oM-1owQCVClHKvrXyLHA8'
        )
        names_desktop=(
            'mod-installer'
            'reset'
            'update'
            'open'
        )
        Terminal=(
            'true'
            'true'
            'true'
            'false'
        )
        counter=0

        for link in "${logo_links[@]}"; do
            if [ ! -e "${logo_names[$counter]}" ]; then
                if ! wget -q -O "${logo_names[$counter]}" "$link"; then
                    echo -e "${RED}Failed to download logo: ${logo_links[$counter]}${NOCOLOR}"
                    kill_processes &
                fi
            fi   

            echo -e "\
                [Desktop Entry]\
                \nName=${names_desktop[$counter]}\
                \nExec=${executables[$counter]}\
                \nIcon=${logo_names[$counter]}\
                \nTerminal=${Terminal[$counter]}\
                \nType=Application\
                \nStartupNotify=true\
            " | awk '{$1=$1}1' | tee "$HOME/Desktop/${names_desktop[$counter]}.desktop" >/dev/null && \
            chmod +x "$HOME/Desktop/${names_desktop[$counter]}.desktop"
            ((counter++))
        done
    }

    ping_wan #1
    find_steam_directory #2
    create_directorys #3
    download_files #4
    make_desktop_sortcuts #5
    echo -e "${GREEN}Updated${NOCOLOR}!." #6
    kill_processes #7
}

all
