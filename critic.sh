#!/bin/env bash
if [[ "$@" = "" ]]
then
	echo "critic: missing operand"
	exit 1
fi

read -p "What program should be used to preview the files? " prog
	
if ! command -v $prog &> /dev/null 
then
	echo "Unable to find command \"$prog\""
	exit 1
fi

for file in "$@"
do
	$prog "$file"
	read -p "Remove this file? [y/N] " rmyn
	case $rmyn in
		[Yy]* ) rm -vf "$file";;
		[Cc]* ) exit;;
		* )
			read -p "Would you like to rename this file? [y/N] " mvyn
			case $mvyn in
				[Yy]* )
					read -p "Destination name: " name
					while [ -f "$name" ] || [ "$name" = "" ]; do
						read -p "This name is invalid or already in use. Please enter another name: " name;
					done
					mv $file $name
				;;
				* ) echo "Retaining original name" ;;
			esac
		;;
	esac
done
		
