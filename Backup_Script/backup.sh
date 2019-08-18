#! /bin/bash
#Script for backing-up and reinstalling configs, .rc files.
#Its pain in the @$$ to configure your configs, rc files after re-installation of termux, just in case you messed it somehow
#A very Barebone script which will be improved in the near future.
#Written by Sars!
#0.1

#Define the path to store the config files.
bpt=~/storage/shared/TermuxBackups/Configs
#Create the directory & redirect (if any) errors to null.
mkdir -p $bpt 2>/dev/null
#Path from where the files needs to be backed up.
ipt=../usr/etc/
#Move the archive to TermuxStuff
ball=~/etc.tar.gz

tball_bup() {
	echo "Creating Tarball....."
	tar -czpf etc.tar.gz $ipt 2>/dev/null
	mv $ball $bpt
	sleep 1
	echo
	echo -e "Configs Backed-Up at \n$bpt"
}
tball_bup