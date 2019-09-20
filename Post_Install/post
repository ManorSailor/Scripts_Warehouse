#!/bin/bash
#Script to quickly set-up Termux with all of packages etc after re-installation.
#Written by Sars!
#0.2

#########################################################
################ Vars, Helpers, Imports #################
#########################################################
#Vars.
#some local vars which cant be included in our confug file cause they are responsible for setting up our script in the first place.
par_dst_dr="../usr/etc/"
dst_dr="../usr/etc/setup/"
files="../home/Awesome-Termux/Post_Install/post_setup/."
#Ends.

#Imports.
#importing files staright causes errors, cause they are not present.
#We copy them over to the destination later down in the script.
#Turned it into a function so that it can be called later, i.e., after the configs have been installed.
imports() {
	source ../usr/etc/setup/packages
	source ../usr/etc/setup/default_pack
	source ../usr/etc/setup/minimal_pack
}
#Ends.

#Helper Functions.
spk() {
	echo -e "\n$1"
}

#Tput-ify
bl() {
	tput bold
}

ul() {
	tput smul
}

rul() {
	tput rmul
}

rst() {
	tput sgr0
}
#Tput-ify Ends.

clr() {
	tput clear
}
#Ends.

#Functions helpful in Debugging.
err_die() {
	spk "Exiting via code $1" >> setup/.log
	exit "$1"
}

success() {
	spk "$1 Succeeded!" >> setup/.log
}

fail() {
	spk "$1 Failed" >> setup/.log
}
#Ends

#########################################################
###################### Main Stuff #######################
#########################################################
#Check if there is a working internet connection.
chk_con() {
	#Ping google to chechk for internet. Ah yes this command, thanks stackoverflow.
	ping -c 1 google.com &> /dev/null
		if [[ $? = 0 ]]; 
			then
				success "Internet available"
				return 0
		else
			spk "$(bl)No Internet! Please connect to Wi-Fi or enable Mobile Data $(rst)"
			#127.0.0.1, so no internet :P
			err_die "127"
		fi			
}

#First run function to configure stuff.
first_run() {
	help
		cd $par_dst_dr #move ya ass to /usr/etc
		mkdir setup
		cd #first come back home then go elsewhere
		cp -r $files $dst_dr
	sleep 3
}

#Display the help message.
help() {
	clr
	bl
	echo "$(ul)SYNTAX $(rul)"
	echo "       setup {TYPE}... {FLAG}"

			spk "$(ul)TYPES $(rul)"
			rst
			echo "If no TYPE is defined script will first look for user defined packages list or else it will continue with DEFAULT."
			spk "       -D, --default     Installs the packages which comes predefined                          in packages list."
			spk "       -M, --minimal     Installs the basic packages needed to make                            Termux feel more Linux like."
			spk "$(bl) E.g, setup -D or setup -M $(rst)"

	spk "$(bl)$(ul)FLAGS $(rul)$(rst)"
			echo "Flags are optional, as of now only SILENT flag is available."
			spk "       -s, --silent      Makes the script run Silently."
			spk "$(bl) E.g., setup -M -s or setup -M --silent $(rst)"
	spk "That's all the help available.. for now"
} 

#Check if the script is being run for the first time.
cd #first return to home
if [[ ! -d $dst_dr ]];
	then
		spk "                                Welcome!\n Just configuring myself. Please bear with me, it can take a while :)"
		chk_con
		first_run

elif [[ -d $dst_dr ]];
	then
		imports
		help
fi