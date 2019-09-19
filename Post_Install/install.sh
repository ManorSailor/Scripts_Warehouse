#!/bin/bash
#
#Installation script for all the scripts which this repo contains.
#Written by Sars
#
##################################################################
# This script will install all our scripts in /usr/local/bin. 
# It will also add our custom path to $PATH so that we can call them from anywhere. 
##################################################################
#
##################################################################
#For now, it will only configure Post-Install script.
#In the near future, supports for our other scripts will be added.
##################################################################
#
######################## Vars, Helpers ###########################

#Vars
bin="/data/data/com.termux/files/usr/local/bin"
etc="/data/data/com.termux/files/usr/local/etc/"
fpt_PI="/data/data/com.termux/files/home/Awesome-Termux/Post_Install/"
bashrc="/data/data/com.termux/files/usr/etc/bash.bashrc"
#Ends.

spk() {
	echo -e "\n$1"
}

#Do ya thing
main() {
		echo -e "\nInstalling..."
		mkdir -p $bin #create /local/bin
		cd $fpt_PI
		cp setup.sh $bin/setup
		cp -r post_setup $etc
		cd $bin && chmod u+x setup		
}

#Add our custom path (/usr/local/) to $PATH
set_path() {
	echo -e '\nexport PATH=$PATH'":$bin" >> $bashrc
}

main
set_path