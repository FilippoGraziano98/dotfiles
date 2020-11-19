#!/usr/bin/env bash

################################
# Shows info about the RAM
#
# Dependencies:
# - [notify-send]
#
# @return {Number(%)}: RAM usage
################################

full=""
status=0

t_warn=50
t_crit=80

idle=$(mpstat 1 1|awk '/Average/ {print $12}'|tr ',' '.')
cpu_usage=$(echo "100 - $idle" | bc)

full="$cpu_usage%"
echo "$full"

# Print color, if needed
if [ ${cpu_usage%%.*} -ge $t_crit ]; then 
	status=33
#elif [ ${cpu_usage%%.*} -ge $t_warn ]; then 
#    echo ""
#    echo "#ff6347"
fi

case $BLOCK_BUTTON in
    # click: show packages
    1 | 2 | 3) 
    n=16
    summary=$(ps -eo pcpu,pmem,pid,psr,comm --sort=-pcpu | head -$n)
    notify-send "Top $n CPU-eaters" "$summary"
    ;;
esac

exit $status

