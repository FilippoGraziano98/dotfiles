#!/usr/bin/env bash
#
# Copyright 2014 Pierre Mavro <deimos@deimos.fr>
# Copyright 2014 Vivien Didelot <vivien@didelot.org>
#
# Licensed under the terms of the GNU GPL v3, or any later version.
#
# This script is meant to use with i3blocks. It parses the output of the "acpi"
# command (often provided by a package of the same name) to read the status of
# the battery, and eventually its remaining time (to full charge or discharge).
#
# The color will gradually change for a percentage below 85%, and the urgency
# (exit code 33) is set if there is less that 5% remaining.

acpi_out=$(acpi -b)
#acpi_out="Battery 0: Discharging, 15%, 00:22:31 remaining"

num='[0-9^]+'
str='[^0-9^]+'

if [[ $acpi_out =~ ^"Battery "($num)": "($str)", "($num)"%, "($num)":"($num)":"$num" "("remaining"|"until charged")$ ]]; then
	bat_number=${BASH_REMATCH[1]}
	status=${BASH_REMATCH[2]}
	percent=${BASH_REMATCH[3]}
	hrem=${BASH_REMATCH[4]}
	mrem=${BASH_REMATCH[5]}
elif [[ $acpi_out =~ ^"Battery "($num)": "($str)", "($num)%$ ]]; then
	bat_number=${BASH_REMATCH[1]}
	status=${BASH_REMATCH[2]}
	percent=${BASH_REMATCH[3]}
	hrem='-'
	mrem='-'
else
	# fail on unexpected output
	echo "die"
	exit 1
fi

full_text="$percent%"

if [ "$status" = 'Discharging' ]; then
	full_text=$full_text" DIS ["$hrem"h"$mrem"m]"
elif [ "$status" = 'Charging' ]; then
	full_text=$full_text" CHR ["$hrem"h"$mrem"m]"
elif [ "$status" = 'Not charging' ]; then
	full_text="$full_text NOT CHR"
elif [ "$status" = 'Full' ]; then
	full_text="$full_text FULL"
fi

# print text
#echo "$full_text"

# consider color and urgent flag only on discharge
if [ "$status" = 'Discharging' ]; then

	if [ $percent -le 10 ]; then 
        echo "BAT $full_text"
		notify-send -u critical -t 5000 "I don't wanna die"
		exit 33
    elif [ $percent -le 20 ]; then 
        echo "<span foreground='#dc143c'>BAT $full_text</span>"
    elif [ $percent -le 40 ]; then 
        echo "<span foreground='#ff6347'>BAT $full_text</span>"
    elif [ $percent -le 60 ]; then 
        echo "<span foreground='#98971a'>BAT $full_text</span>"
    else
        echo "BAT $full_text"
    fi

else
    echo "BAT $full_text"
fi

exit 0 

