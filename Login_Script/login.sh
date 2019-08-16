#! /bin/bash
#Login script which asks for the usrnm & pswd defined by the user, it terminates the app if credentials dont match.
#It has improved now, but still not totally foolproof. 
#Version: 0.6

#Path where the valuables are stored.
pt=../usr/share/.login
#Path for temporarily storing unencrypted valuables.
opt=../usr/tmp/.tmplog

#Function for encrypting & decrypting cred.
encrypt() {
openssl enc -aes-256-cbc -pbkdf2 -salt -in $opt -out $pt -k $pf
chmod u-rw $pt
}

decrypt() {
chmod u+rw $pt
openssl enc -d -aes-256-cbc -pbkdf2 -salt -in $pt -out $opt -k $pss $old
}

#Function that sets credentials.
st_crd() {
	read -p "Set Your Username: " un
	read -s -p "Set Your Password: " pf

	#rm the unencrypted cred file if it exists
	if [ -f $opt ];
	then
		rm $opt
	fi

	if [[ $un != "" && $pf != "" ]];
	then
		touch $pt
	        echo -e "$un\n$pf" >> $opt
	        echo -e "\nCredentials added!!"
		encrypt
		echo -e "\nExiting Termux, please restart it!"
		chmod u-rw $pt
		sleep 3
		kill -9 $PPID
	else
		echo -e '\nCredentials cannot be empty!'
		exit
	fi

}

#Function for re-setting credentials.
rst_crd() {
	read -p "Enter Old Password: " old
	decrypt

	#Read the old pass.
	p=$( tail -n 1 $opt )

	if [[ $old == $p ]];
	then
		echo -e "\nClearing your Old Credentials..."
		rm -rf $pt
		echo -e "\nCleared! Please add your new credentials"
		st_crd

	else
		echo -e "\nOh, you remember your Credentials? :o"
		echo -e "\nClosing app, re-launch it please"
		chmod u-rw $pt
		sleep 3
		kill -9 $PPID
	fi
}

#Trap the intruder & check if user wants to reset Credentials ;)
int_trp() {
	echo -e "\nForgot your Credentials?"
	read ans

	if [[ $ans == "yes" || $ans == "y" || $ans == "Y" || $ans == "Yes" ]];
	then
		rst_crd

	else
		echo "Intruder Alert!!"
		chmod u-rw $pt
		sleep 3
		kill -9 $PPID
	fi
}

#Function for checking if the user is authorized.
chk_crd() {
	trap 'int_trp' INT
	chmod u+rw $pt

	echo "Enter Username"
	read n
	echo "Enter Passwd"
	read -s pss
	decrypt

	unm=$( head -n 1 $opt )
	p=$( tail -n 1 $opt )

	if [[ $n == $unm && $pss == $p ]];
	then
		echo "Access Granted!"

	else
		echo "Un-Authorized User ..exiting"
		sleep 3
		kill -9 $PPID
	fi
	chmod u-rw $pt
}

#Checks if the user is running the script for first time, it's not the proper way of doing this i guess but for now it works :P
if [ -f "$pt" ];
then
	chk_crd

else
	st_crd
fi

trap SIGINT
