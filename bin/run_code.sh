#!/bin/bash
# 
# Author: Nguyen Anh Tien
# Compile and run code, output result or error str
# TODO: sandbox + refactoring code
#
# Usage : ./run.sh source_file language memory_limit  input_file
# Ex: ./run.sh test.c c 64000 "3\n4 3"

#-- settings ----------
CLEAN_SOURCE_FILE=FALSE
CLEAN_TEMP_FILE=TRUE
#----------------------

sh_file="$0"
source_file="$1"
language="$2"
input_file="$3"
binary=tmp_$(date +%Y%m%d_%H%M%S)
log=tmp_$(date +%Y%m%d_%H%M%S_)"log"

if [[ "$ input_file" == '' ]] ; then
 	echo 'Usage :' "$sh_file" 'source_file language input_file'
 	exit 0
fi

# Language Ruby
if [[ "$language" == 'ruby' ]] ; then
	ts=$(date +%s%N)
	output=$(/usr/bin/time -f "[MEMORY:%MKB]" ruby "$source_file" < "$input_file" 2> "$log")
	last_run_error=$?
	time_run=$((($(date +%s%N) - $ts)/1000000))

# Language PHP
elif [[ "$language" == 'php' ]] ; then
	ts=$(date +%s%N)
	output=$(/usr/bin/time -f "[MEMORY:%MKB]" php -f "$source_file" < "$input_file" 2> "$log")
	last_run_error=$?
	time_run=$((($(date +%s%N) - $ts)/1000000))

# Language Python
elif [[ "$language" == 'python' ]] ; then
	ts=$(date +%s%N)
	output=$(/usr/bin/time -f "[MEMORY:%MKB]" python "$source_file" < "$input_file" 2> "$log")
	last_run_error=$?
	time_run=$((($(date +%s%N) - $ts)/1000000))

# Language C/C++
elif [[ "$language" == 'c' || "$language" == 'c++' ]] ; then
	if [[ "$language" == 'c' ]] ; then
		complier_output=$(gcc -o "$binary" "$source_file" 2> /dev/null)
	else
		complier_output=$(g++ -o "$binary" "$source_file" 2> /dev/null)
	fi
	# check for compiler error
	complier_error=$?
	if [[ "$complier_error" -ne 0 ]] ; then
		echo "[ERROR][COMPILE]"
		exit 0
	else
		ts=$(date +%s%N)
		output=$(/usr/bin/time -f "[MEMORY:%MKB]" ./"$binary" < "$input_file" 2> "$log")
		last_run_error=$?
		time_run=$((($(date +%s%N) - $ts)/1000000))
	fi
#Language Java
# forces file name and class name to Main.java/public class Main
elif [[ "$language" == 'java' ]] ; then
	if [[ "$source_file" =~ "/" ]]; then
	    class_path=${source_file%%Main.java}
	fi

	complier_output=$(javac "$source_file")
	# check for compiler error
	complier_error=$?
	if [[ "$complier_error" -ne 0 ]] ; then
		echo "[ERROR][COMPILE]"
		exit 0
	else
		ts=$(date +%s%N)
		output=$(/usr/bin/time -f "[MEMORY:%MKB]" java -cp  "$class_path" Main < "$input_file" 2> "$log")
		last_run_error=$?
		time_run=$((($(date +%s%N) - $ts)/1000000))
	fi
else
	echo "[ERROR][UNKNOWN_LANGUAGE]"
fi

# check run/usr/bin/time error
info='[TIME:'"$time_run"'ms]'$(cat "$log")
if [[ "$last_run_error" -eq 0 ]] ; then
	echo "$output""$info"
else
	echo "[ERROR][RUNTIME]"
fi

# clean up
rm -f "$log" 2> /dev/null
if [[ "$CLEAN_SOURCE_FILE" == TRUE ]] ; then
	rm -f "$source_file" 2> /dev/null
fi
if [[ "$CLEAN_TEMP_FILE" == TRUE ]] ; then
	rm -f "$binary" 2> /dev/null
	rm -f Main.class
fi

exit 0
