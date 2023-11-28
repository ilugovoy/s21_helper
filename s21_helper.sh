#!/bin/bash/

MAGENTA=$'\033[0;35m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
RED=$'\033[0;31m'
RESET=$'\033[0;m'


get_initial_space_info() {

    initial_df=$(df -h . | grep --color=always -E "Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*Mi|[0-9]*\.*[0-9]*Gi|[0-9]+\.*[0-9]+% |$")
    echo "${RED}Current space:\n${RESET}${initial_df}${RESET}"
}

get_initial_space_usage() {

    initial_used_space=$(df -h $HOME | grep -v 'Filesystem' | awk '{ printf("%f", $3) }')
    before=$(df -h . | grep --color=always -E "Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*Mi|[0-9]*\.*[0-9]*Gi|[0-9]+\.*[0-9]+% |$")
}

echo_home_folder_info() {

    echo $RED"\nHome folder:"$RESET
    echo ""
    echo '----------------------'
    echo 'Size    Used    Avail'
    echo '----------------------'
    df -h | grep Users | awk '{print $2 " = " $3 " + "  $4}'
}

clean_local_files() {

	rm -rfv ~/Desktop/Presentation.pdf
	cp ~/Library/Icon? ~/.Trash
	rm -rfv ~/.kube/cache/*
	rm -rfv ~/Pictures/*
    rm -rfv ~/Movies/*
	rm -rfv ~/.Trash/*
	rm -rfv ~/Music/*
}

clean_apple_cache() {
	
	rm -rfv ~/Library/Caches/com.apple.preferencepanes.searchindexcache
	rm -rfv ~/Library/Caches/com.apple.preferencepanes.usercache
	rm -rfv ~/Library/Caches/com.apple.nsservicescache.plist
	rm -rfv ~/Library/Caches/com.apple.keyboardservicesd
	rm -rfv ~/Library/Caches/com.microsoft.VSCode.ShipIt
    rm -rfv ~/Library/Caches/com.apple.tiswitcher.cache
    rm -rfv ~/Library/Caches/com.google.SoftwareUpdate
    rm -rfv ~/Library/Caches/com.apple.nsurlsessiond
    rm -rfv ~/Library/Caches/com.apple.ap.adprivacyd
    rm -rfv ~/Library/Caches/com.apple.appstoreagent
    rm -rfv ~/Library/Caches/com.apple.cache_delete
    rm -rfv ~/Library/Caches/com.apple.iCloudHelper
    rm -rfv ~/Library/Caches/com.microsoft.VSCode
    rm -rfv ~/Library/Caches/com.google.Keystone
    rm -rfv ~/Library/Caches/com.apple.appstore
    rm -rfv ~/Library/Caches/com.apple.commerce
    rm -rfv ~/Library/Caches/com.apple.touristd
	rm -rfv ~/Library/Caches/com.apple.parsecd
    rm -rfv ~/Library/Caches/com.apple.nbagent
    rm -rfv ~/Library/Caches/com.apple.akd
    rm -rfv ~/Library/Caches/storeassetd
}

clean_unused_docker_sources() {

    rm -rfv ~/Library/Containers/com.docker.docker/Data/vms/*
	find /var/lib/docker/containers -type f -atime +30 -delete
	find /var/lib/docker/volumes/ -type f -atime +30 -delete
	find /var/lib/docker/image -type f -atime +30 -delete
}

clean_vscode_temp() {

	rm -rfv ~/Library/Application\ Support/Code/Service\ Worker/CacheStorage
    rm -rfv ~/Library/Application\ Support/Code/User/workspaceStorage
    rm -rfv ~Library/Application\ Support/Code/Crashpad/completed
    rm -rfv ~/Library/Application\ Support/Code/Code\ Cache
	rm -rfv ~/Library/Application\ Support/Code/Cache*
}

clean_browser_temp() {

	rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/CacheStorage/*
	rm -rfv  ~/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/ScriptCache/*
	rm -rfv ~/Library/Application\ Support/Google/Chrome/BrowserMetrics-spare.pma
	rm -rfv ~/Library/Application\ Support/Google/Chrome/GrShaderCache/GPUCache*
	rm -rfv ~/Library/Application\ Support/Google/Chrome/ShaderCache/GPUCache*
	rm -rfv ~/Library/Application\ Support/Google/Chrome/Crashpad/completed/*
	rm -rfv ~/Library/Application\ Support/Google/Chrome/BrowserMetrics/*
    rm -rfv ~/Library/Containers/com.apple.Safari/Data/Library/Caches/*
	rm -rfv ~/Library/Safari/*
}

clean_rocket_chat_cache() {

	rm -rfv ~/Library/Containers/chat.rocket/Service Worker/CacheStorage
	rm -rfv ~/Library/Containers/chat.rocket/GPUCache
	rm -rfv ~/Library/Containers/chat.rocket/Cache
	rm -rfv ~/Library/Containers/chat.rocket/Data
}

get_final_space_info() {

	echo "${BLUE}Current space:\n${RESET}${initial_df}${RESET}"
    echo "${BLUE}\nHome folder:${RESET}"
    du -hd1 . 2>/dev/null | sort -h | grep --color=always "[0-9]*\.*[0-9]*M\t\|[0-9]*\.*[0-9]*G\t\|$"
}

clean_result() {

    echo $RED"before:\n"$RESET${before}$RESET
	echo ""
    echo '----------------------'
    echo 'Size    Used    Avail'
    echo '----------------------'
    df -h | grep Users | awk '{print $2 " = " $3 " + "  $4}'
    sleep 1
    echo DONE
}

clear_space() {

    echo "${RED}----- CLEARING MEMORY -----${RESET}"
    sleep 1
    cd $HOME

    get_initial_space_info
	get_initial_space_usage
	echo_home_folder_info

    clean_unused_docker_sources
	clean_rocket_chat_cache
	clean_browser_temp
	clean_local_files
    clean_apple_cache
    clean_vscode_temp

	clear
    echo $RED"----- CLEARING MEMORY -----"$RESET
    sleep 1

	get_initial_space_info
    get_final_space_info
	clean_result
}


memory_stats() {

    echo $GREEN"----- MEMORY STATS -----"$RESET
    sleep 1
    echo "Available now:"
    df -h ~
}

install_homebrew() {

    echo $BLUE"----- HOMEBREW INSTALLATION -----"$RESET 
    sleep 1
    /bin/bash -c "$(curl -fsSL https://rawgit.com/kube/42homebrew/master/install.sh | zsh)"
    brew update --force --quiet
    brew install clang-format
    echo $RED"----- HOMEBREW INSTALLATION -----"$RESET
    sleep 1
    echo DONE
}

update_homebrew() {

    echo $MAGENTA"----- HOMEBREW UPDATING -----"$RESET
	sleep 1
	brew update --force --quiet
    sleep 1
    echo DONE
}

show_menu() {

    clear && sleep 0.1
    echo 'What do you want to do?'
    echo 'Choose your option:'
    echo --------------------------------
    echo 1 - 🧹 Clear memory
    echo 2 - 💾 Memory information
    echo 3 - 🍺 Install Homebrew
    echo 4 - 🔄 Update Homebrew 
    echo q - ❌ Quit
    echo --------------------------------
}

handle_user_choice() {

    read OPTION
    while [ "$OPTION" != 1 ] && [ "$OPTION" != 2 ] && [ "$OPTION" != 3 ] && [ "$OPTION" != 4 ] && [ "$OPTION" != q ]
    do
        sleep 0.2
        echo 'Follow the options'
        echo --------------------------------
        read OPTION
    done
    sleep 0.3

    if [ "$OPTION" != q ]
    then
        echo "Let's just get to it"
        echo --------------------------------
        sleep 1.5 && clear

    else
        echo "GLHF!"
        echo --------------------------------
        sleep 0.5
    fi
}


show_menu
handle_user_choice

case $OPTION in
    1) clear_space ;;
    2) memory_stats ;;
    3) install_homebrew ;;
    4) update_homebrew ;;
    q) ;;
esac
