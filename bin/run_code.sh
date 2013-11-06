#!/bin/bash
# 
# Author: Nguyen Anh Tien
# Compile and run code, output result or error str
# TODO: sandbox + refactoring code
#
# Usage : ./run.sh source_file language memory_limit input_string
# Ex: ./run.sh test.c c 64000 "3\n4 3"

#-- settings ----------
CLEAN_SOURCE_FILE=FALSE
CLEAN_TEMP_FILE=TRUE
#----------------------

sh_file="$0"
source_file="$1"
language="$2"
memory_limit="$3"
input_string="$4"
binary=tmp_$(date +%Y%m%d_%H%M%S_)"$source_file"
log=tmp_$(date +%Y%m%d_%H%M%S_)"log"

ts=$(date +%s%N)
python -c "print '$input_string'" 1> /dev/null
time_input=$((($(date +%s%N) - $ts)/1000000))

if [[ "$input_string" == '' ]] ; then
 	echo 'Usage :' "$sh_file" 'source_file language memory_limit input_string'
 	exit 0
fi

# Language Ruby
if [[ "$language" == 'ruby' ]] ; then
	ulimit -v "$memory_limit"
	ts=$(date +%s%N)
	output=$(python -c "print '$input_string'" 2> /dev/null | time -f "[MEMORY:%MKB]" ruby "$source_file" 2> "$log")
	last_run_error=$?
	time_run=$((($(date +%s%N) - $ts)/1000000))

# Language PHP
elif [[ "$language" == 'php' ]] ; then
	ulimit -v "$memory_limit"
	ts=$(date +%s%N)
	output=$(python -c "print '$input_string'" 2> /dev/null | time -f "[MEMORY:%MKB]" php -f "$source_file" 2> "$log")
	last_run_error=$?
	time_run=$((($(date +%s%N) - $ts)/1000000))

# Language Python
elif [[ "$language" == 'python' ]] ; then
	ulimit -v "$memory_limit"
	ts=$(date +%s%N)
	output=$(python -c "print '$input_string'" 2> /dev/null | time -f "[MEMORY:%MKB]" python "$source_file" 2> "$log")
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
		ulimit -v "$memory_limit"
		ts=$(date +%s%N)
		output=$(python -c "print '$input_string'" 2> /dev/null | time -f "[MEMORY:%MKB]" ./"$binary" 2> "$log")
		last_run_error=$?
		time_run=$((($(date +%s%N) - $ts)/1000000))
	fi
#Language Java
# forces file name and class name to Main.java/public class Main
elif [[ "$language" == 'java' ]] ; then
	complier_output=$(javac Main.java 2> /dev/null)
	# check for compiler error
	complier_error=$?
	if [[ "$complier_error" -ne 0 ]] ; then
		echo "[ERROR][COMPILE]"
		exit 0
	else
		ulimit -v "$memory_limit"
		ts=$(date +%s%N)
		output=$(python -c "print '$input_string'" 2> /dev/null | time -f "[MEMORY:%MKB]" java Main.class 2> "$log")
		last_run_error=$?
		time_run=$((($(date +%s%N) - $ts)/1000000))
	fi
else
	echo "[ERROR][UNKNOWN_LANGUAGE]"
fi

final_time=$((time_run - time_input))
if [[ "$final_time" -lt 0 ]] ; then
	final_time="$time_run"
fi

# check runtime error
info='[TIME:'"$final_time"'ms]'$(cat "$log")
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
	rm -f Main.class 2> /dev/null
fi

exit 0