#!/bin/bash
#Script to quickly set-up Termux with all of packages etc after re-installation.
#Written by Sars!
#0.1 Initial release.

#########################################################
################ Vars, Helpers, Imports #################
#########################################################
source .setup/.config
source .setup/packages

spk() {
	echo -e "\n$1"
}

#Functions helpful in Debugging.
err_die() {
	echo "Exiting via code $1" >> .setup/.log
	exit "$1"
}

success() {
	echo -e "\n $1 Succeeded!" >> .setup/.log
}

fail() {
	echo -e "\n$1 Failed" >> .setup/.log
}
#Ends

help() {
	echo "setup {TYPE}... {FLAG}"
	spk "E.G, setup full or setup minimal -S"
	echo "If no TYPE is defined script will continue with DEFAULT "
			tput bold
			spk "TYPES..."
			tput sgr0
	echo "FULL: Installs every packages "
	echo "Default"
}