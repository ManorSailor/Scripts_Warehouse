#! /bin/bash
#Simple Login script made in $Bash!
#It has improved a lot than before, but still insecure :P
#Written by Sars!
#Version: 0.9

#Path where the valuables are stored.
pt=../usr/share/.login
#Path for temporarily storing unencrypted valuables.
opt=../usr/tmp/.tmplog

#Helper function.
err_die() {
	echo -e "\nExiting..."
	chmod u-rw "$pt"
	rm "$opt" 2>/dev/null
	sleep 3
	kill -9 $PPID
}

#Function for encrypting & decrypting cred.
encrypt() {
openssl enc -aes-256-cbc -pbkdf2 -salt -in "$opt" -out "$pt" -k "$1" 2>/dev/null #Redirects error if any to /dev/null. Thanks to https://stackoverflow.com/a/25348167
chmod u-rw "$pt"
}

decrypt() {
chmod u+rw "$pt"
openssl enc -d -aes-256-cbc -pbkdf2 -salt -in "$pt" -out "$opt" -k "$1" 2>/dev/null #Redirects bad-decrypts error if any to /dev/null. Thanks to https://stackoverflow.com/a/25348167
}

#Function that sets credentials.
st_crd() {
	read -p "Set Your Username: " un
	read -sp "Set Your Password: " pf

	#rm the unencrypted cred file if it exists
	if [ -f "$opt" ];
	then
		rm "$opt"
	fi

	if [[ -n "$un" && -n "$pf" ]];
	then
		touch "$pt"
		echo -e "$un\n$pf" >> "$opt"
		clear
		echo -e "\nCredentials added!!"
		encrypt "$pf"
		err_die
	else
		echo
		clear
		echo -e "\nCredentials cannot be empty!"
		exit
	fi

}

#Function for re-setting credentials.
rst_crd() {
	read -sp "Enter Old Password: " pss
	decrypt "$pss"

	#Read the old pass.
	op=$( tail -n 1 "$opt" 2>/dev/null )

	if [[ "$pss" == "$op" && ! -z "$pss" ]];
	then
		echo -e "\nClearing your Old Credentials..."
		rm -rf "$pt"
		clear
		echo -e "\nCleared! Please add your new credentials"
		echo		
		st_crd

	else
		err_die
	fi
}

#Trap the intruder & check if user wants to reset Credentials ;)
int_trp() {
	echo
	echo -e "\nForgot your Credentials?"
	read ans

	if [[ "$ans" == "yes" || "$ans" == "y" || "$ans" == "Y" || "$ans" == "Yes" ]];
	then
		clear
		rst_crd

	else
		err_die
	fi
}

#Function for checking if the user is authorized.
chk_crd() {
	trap 'int_trp' INT
	chmod u+rw "$pt"

	read -p "Enter Username: " n
	read -sp "Enter Password: " pss
	decrypt "$pss"

	unm=$( head -n 1 "$opt" 2>/dev/null )
	p=$( tail -n 1 "$opt" 2>/dev/null )

	if [[ -z "$n" || -z "$pss" ]];
	then
		echo
		echo
		clear
		echo "Enter your Credentials!!"
		err_die

	elif [[ "$n" == "$unm" && "$pss" == "$p" ]];
	then
		echo
		clear
		echo -e "\nWelcome $n!"

	else
		echo
		clear
		echo -e "\nUn-Authorized User!"
		err_die
	fi
}

#Checks if the user is running the script for first time, it's not the proper way of doing this i guess but for now it works :P
if [ -f "$pt" ];
then
	chk_crd

else
	st_crd
fi

trap SIGINT
