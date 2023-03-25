#!/bin/bash

# To manage mandatory parameters

helpFunction()
{
	echo "Usage: $0 -e existingVersion -n newVersion -c componentName -o oldVersion"
	echo "-e Information about the component of the version already installed as '0.0.1'"
	echo "-n Information about the component of the version already installed as '0.0.2'"
	echo "-c name of the component as know by Pegasus"
	#echo "-o Information about the old component of the already installed version as '0.0.3'"
	exit 1 # Exit script after printing help
}

while getopts ":e:n:c:o:?" opt; do
	case "$opt" in
		e ) existingVersion=${OPTARG} ;;
		n ) newVersion="$OPTARG" ;;
		c ) componentName="$OPTARG" ;;
		#o ) oldVersion="$OPTARG" ;;
		? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
	esac
done

#echo for debug
#echo "$existingVersion"
#echo "$newVersion"
#echo "$componentName"
#echo "$oldVersion"

# Initialization of progress and state
echo "0.1" > /tmp/$componentName/progress.log
echo "Installation of $componentName..." > /tmp/$componentName/install.log
echo "0" > /tmp/$componentName/install.err

#authorize file system udpate on root
mount -o remount,rw /

# Print helpFunction in case parameters are empty
if [ -z "$existingVersion" ] || [ -z "$newVersion" ] || [ -z "$componentName" ] #|| [ -z "$oldVersion" ]
then
	echo "Some or all of the parameters are empty" > /tmp/$componentName/install.log
	echo "1" > /tmp/$componentName/install.err
	helpFunction
fi

# Begin script in case all parameters are correct
# Unzip package in /tmp/$componantName/package directory
if test -n "$(find /tmp/$componentName -maxdepth 1 -name 'package.zip' -print -quit)"
then
	if [ ! -d "/tmp/$componentName/package" ]
	then
		#creation of package directory in component one
		echo "0.2" > /tmp/$componentName/progress.log
		echo "Creation of directory /tmp/$componentName/package" > /tmp/$componentName/install.log
		mkdir /tmp/$componentName/package 
		if [ $? -eq 0 ]
		then
			echo "0.3" > /tmp/$componentName/progress.log
			echo "Directory /tmp/$componentName/package created" > /tmp/$componentName/install.log
		else
			echo "Directory /tmp/$componentName/package creation failed" > /tmp/$componentName/install.log
			echo "1" > /tmp/$componentName/install.err
			exit $?
		fi
	fi
	# Unzip package
	echo "0.4" > /tmp/$componentName/progress.log
	echo "Unzip of package..." > /tmp/$componentName/install.log
	unzip -o /tmp/$componentName/package.zip -d /tmp/$componentName/package
	if [ $? -eq 0 ]
	then
		echo "0.5" > /tmp/$componentName/progress.log
		echo "Unzip of package done" > /tmp/$componentName/install.log
	else
		echo "Unzip of package failed" > /tmp/$componentName/install.log
		echo "1" > /tmp/$componentName/install.err
		exit $?
	fi
	# Do backup of previous version
	#***************************************begin of part to customize*****************************************************
	#####echo "Old Version" > /tmp/$componentName/install.log
	#####echo "shinretro"$oldVersion"" > /tmp/$componentName/install.log
	#####rm -r /recalbox/share_init/themes/shinretro$oldVersion
	
	rm -r /recalbox/share_init/themes/shinretro0.201
	rm -r /recalbox/share_init/themes/shinretro0.201.1
	rm -r /recalbox/share_init/themes/shinretro0.201.2
	
	mv /recalbox/share_init/themes/shinretro /recalbox/share_init/themes/shinretro$existingVersion
	mv /recalbox/share_init/themes/shinretro$existingVersion/theme.cfg /recalbox/share_init/themes/shinretro$existingVersion/theme.cfg$existingVersion
	if [ $? -eq 0 ]
	then
		echo "0.6" > /tmp/$componentName/progress.log
		echo "Backup of existing version done" > /tmp/$componentName/install.log
	else
		echo "Backup of existing version failed" > /tmp/$componentName/install.log
		echo "1" > /tmp/$componentName/install.err
		exit $?
	fi
	# Replace shinretro
	mv -f /tmp/$componentName/package/* /recalbox/share_init/themes
	if [ $? -eq 0 ]
	then
		echo "0.7" > /tmp/$componentName/progress.log
		echo "Component move done" > /tmp/$componentName/install.log
		if [ $? -eq 0 ]
		then
			echo "0.8" > /tmp/$componentName/progress.log
			echo "Component access right OK" > /tmp/$componentName/install.log
		else
			echo "Component access failed"> /tmp/$componentName/install.log
			echo "1" > /tmp/$componentName/install.err
			exit $?
		fi		
	else
		echo "Component update failed" > /tmp/$componentName/install.log
		echo "1" > /tmp/$componentName/install.err
		exit $?
	fi
	echo "1.0" > /tmp/$componentName/progress.log
	echo "Component updated - enjoy !!!" > /tmp/$componentName/install.log
	# Set 0 if end of installation without other action needed, -1 if need restart of Pegasus, -2 if need reboot
	echo "-1" > /tmp/$componentName/install.err
	# If OK, we could update the version of core in corresponding .cfg
	# version: 0.201
	themeName="shinretro"
	result=""
	result="$(awk -v FS='(version: )' '{print $2}' /recalbox/share_init/themes/"$themeName"/theme.cfg | tr -d '\n')"
	exit 0
	#***************************************end of part to customize*****************************************************
else
	echo "No 'package.zip' available in your sharing in '/tmp/$componentName'" > /tmp/$componentName/install.log
	echo "3" > /tmp/$componentName/install.err
	exit 3
fi	