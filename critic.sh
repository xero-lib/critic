#!/bin/env bash

auto=false
copy=false

while getopts ":hac" option; do
	case $option in
		h) echo -e "usage: $0 [-h] [-a] [-c] file(s)\n\t-h: display this help section\n\t-a: automatically determine program to use when previewing files (useful for previewing multiple filetypes)\n\t-c: copy instead of move"; exit ;;
		a) 
			if command -v xdg-open &> /dev/null; then
				auto=true
			else
				echo "Unable to find xdg-open for automatic file detection"
			fi
			shift $(( OPTIND - 1 ))
		;;
		c) copy=true; shift $(( OPTIND - 1))  ;;
		?) echo "error: option -$OPTARG not found";
	esac
done

if [ $# -eq 0 ]
then
	echo "critic: missing operand"
	exit 1
fi

if $auto; then
	prog="xdg-open"
else
	read -p "What program should be used to preview the files? " prog
	if ! command -v $prog &> /dev/null 
	then
		echo "Unable to find command \"$prog\""
		exit 1
	fi
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
					if $copy; then
						cp $file $name
					else
						mv $file $name
					fi
				;;
				* ) echo "Retaining original name" ;;
			esac
		;;
	esac
done
		
