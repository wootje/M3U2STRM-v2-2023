#!/bin/bash
#
#
# HOW TO USE
#
#
# cd <this directory> && wget <url to m3u8 file> -O vod.m3u8 && ./m3u2strm.sh vod.m3u8 <output directory> <option>
#
# Options:
# 1 = local file
# 2 = url to file
#
# Set the output directory on line 196 & 206 in the php file to:
# <your directory>/movies
# <your directory>/tvshows
#
#
# Example crontab (# crontab -e) that runs every monday at 22:00 hour: 
# 0 22 * * 1 cd /opt/m3u2strm && wget http://mywebsite.online/mym3u8file -O vod.m3u8 && ./m3u2strm.sh vod.m3u8 /var/www/ftp/kodi 1
#
#
#
# M3U 2 STRM - v1.0.0 (November 2020)
# Coded by: ERDesigns - Ernst Reidinga (c) 2020
#
# Edited by wootje (Februari 2023):
# - movies & tvshows in seperate directories
# - existing strm files are moved to another directory as backup
#
#

trap 'printf "\n";stop;exit 1;clear;' 2


dependencies () {
	# Check if PHP is installed
	command -v php > /dev/null 2>&1 || { 
		echo >&2 "PHP is required! Please install PHP first and try again."; 
		exit 1; 
	}
	# Check if CURL is installed
	command -v curl > /dev/null 2>&1 || { 
		echo >&2 "CURL is required! Please install CURL first and try again."; 
		exit 1; 
	}
}

banner () {
	printf "\e[1;34m                                                                          \e[0m\n"
	printf "\e[1;34m ███╗   ███╗██████╗ ██╗   ██╗██████╗ ███████╗████████╗██████╗ ███╗   ███╗ \e[0m\n"
	printf "\e[1;34m ████╗ ████║╚════██╗██║   ██║╚════██╗██╔════╝╚══██╔══╝██╔══██╗████╗ ████║ \e[0m\n"
	printf "\e[1;34m ██╔████╔██║ █████╔╝██║   ██║ █████╔╝███████╗   ██║   ██████╔╝██╔████╔██║ \e[0m\n"
	printf "\e[1;34m ██║╚██╔╝██║ ╚═══██╗██║   ██║██╔═══╝ ╚════██║   ██║   ██╔══██╗██║╚██╔╝██║ \e[0m\n"
	printf "\e[1;34m ██║ ╚═╝ ██║██████╔╝╚██████╔╝███████╗███████║   ██║   ██║  ██║██║ ╚═╝ ██║ \e[0m\n"
	printf "\e[1;34m ╚═╝     ╚═╝╚═════╝  ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝ \e[0m\n"
	printf "\n"
	printf "\e[1;34m                .:.:.\e[0m\e[1;94m By Ernst Reidinga - ERDesigns \e[0m\e[1;34m.:.:.\e[0m\n"
	printf "\n"
	printf "\e[1;34m 					edited by wootje \e[0m\n"
	printf "\n"
}

menu () {
	printf "\e[1;34m [\e[0m\e[1;31m01\e[0m\e[1;34m]\e[0m\e[1;94m Convert local M3U file\e[0m\n"
	printf "\e[1;34m [\e[0m\e[1;31m02\e[0m\e[1;34m]\e[0m\e[1;94m Convert remote M3U file\e[0m\n"
	printf "\e[1;34m [\e[0m\e[1;31m03\e[0m\e[1;34m]\e[0m\e[1;94m Command Line options\e[0m\n"
	printf "\n"
	printf "\e[1;34m ------------------------------------------------------------------------------\n"
	printf "\e[1;34m [\e[0m\e[1;31m99\e[0m\e[1;34m]\e[0m\e[1;31m Exit\e[0m\n"
	# Read selection
	read -p $'\n\e[1;34m [\e[0m\e[1;91m*\e[0m\e[1;34m] Enter your selection: \e[0m' option


	# Read filename / URL
	if [[ $option == 1 || $option == 01 ]]; then
		mode="LOCAL"
		if [[ $filename == "" ]]; then
			read -p $'\e[1;34m [\e[0m\e[1;91m*\e[0m\e[1;34m] Local M3U filename: \e[0m' filename
			filename=(${filename[@]//\'/})
		fi
		if [[ ! -e $filename ]]; then
			printf "\e[1;34m [!]\e[31m File DOES NOT exist!\e[0m\n"
			sleep 1
			clear
			banner
			menu
		fi
	elif [[ $option == 2 || $option == 02 ]]; then
		mode="REMOTE"
		read -p $'\e[1;34m [\e[0m\e[1;91m*\e[0m\e[1;34m] Remote M3U URL: \e[0m' filename
		regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
		if [[ ! $filename =~ $regex ]]; then
			printf "\e[1;34m [!]\e[31m Invalid URL!\e[0m\n"
			sleep 1
			clear
			banner
			menu
		fi
	fi

	# Read output directory
	if [[ $option == 1 || $option == 01 || $option == 2 || $option == 02 ]]; then
		if [[ $filename == "" ]]; then	
			read -p $'\e[1;34m [\e[0m\e[1;91m*\e[0m\e[1;34m] Output directory: \e[0m' directory
		fi
		if [[ $directory == "" ]]; then
			printf "\e[1;34m [!]\e[31m Please enter a valid directory!\e[0m\n"
			clear
			banner
			menu
		fi
		start
	fi

	# Command Line options
	if [[ $option == 3 || $option == 03 ]]; then
		printf "\n"
		printf "\e[1;34m This script takes 2 parameters, you can run this script from the CRON with these parameters: \n"
		printf "\n"
		printf "\e[1;34m [\e[0m\e[1;31m Option 1\e[0m\e[1;34m]\e[0m\e[1;94m M3U filename or URL\e[0m\n"
		printf "\e[1;34m [\e[0m\e[1;31m Option 2\e[0m\e[1;34m]\e[0m\e[1;94m Output directory\e[0m\n"
		printf "\n"
		printf "\e[1;34m [\e[0m\e[1;31m Example:\e[0m\e[1;34m]\e[0m\e[1;94m sudo bash m3u2strm.sh http://my-provider.com/get.php?username=abc&password=def&type=m3u_plus /home/username/desktop/strm \e[0m\n"
	elif [[ $option == 99 ]]; then
		# User wants to exit
		exit 1
	else
		# No valid input!
		printf "\e[1;34m [!]\e[31m Invalid selection!\e[0m\n"
		sleep 1
		clear
		banner
		menu
	fi

}

start () {
	printf "\n"
	printf "\e[1;34m Please wait while converting the M3U to STRM files. \n"
	currentdir=$(dirname "$0")
	php -f "$currentdir/m3u2strm.php" filename=$filename directory=$directory > "$currentdir/log.log"
#	wait
}

stop () {
	PHP=$(ps aux | grep -o "php" | head -n1)
	# Kill PHP
	if [[ $PHP == *'php'* ]]; then
		pkill -f -2 php > /dev/null 2>&1
		killall -2 php > /dev/null 2>&1
	fi
}

if [[ ! $1 == "" && ! $2 == "" ]]; then
	filename="$1"
	directory="$2"
	option= "$3"
	printf "\n"
	printf "\e[1;34m Remove backup of strm files...  \e[0m\n"
	printf "\n"
	backupdirectory="$2 old"
	rm -rfv "$backupdirectory"
	printf "\e[1;34m Creating new backup of strm files by renaming directory...  \e[0m\n"
	printf "\n"
	mv "$directory" "$backupdirectory"
	printf "\e[1;34m Creating new directory for strm files...  \e[0m\n"
	printf "\n"
	mkdir $directory
	mkdir "${directory}/movies"
	mkdir "${directory}/tvshows"
	printf "\n"
	printf "\e[1;34m Starting PHP script to generate strm files...  \e[0m\n"
	printf "\n"
	start
	printf "\n"
	printf "\e[1;34m PHP strm script is finished...  \e[0m\n"
	printf "\n"
	printf "\e[1;34m Setting correct permissions to strm files...  \e[0m\n"
	chmod 775 -R $directory
	printf "\n"
	printf "\e[1;34m All done!  \e[0m\n"
	sleep 1
	printf "\n"
	printf "\e[1;34m Bye  \e[0m\n"
	sleep 1
	exit
else
	clear
	banner
	menu
fi
