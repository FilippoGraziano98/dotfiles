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

t_warn=60
t_crit=90

info=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader)
usage=$(echo $info|cut -d" " -f1 | bc )
mem_used=$(echo $info|cut -d" " -f3)
mem_total=$(echo $info|cut -d" " -f5)
temp=$(echo $info|cut -d" " -f7 | bc )

mem_usage=$(echo "100*$mem_used / $mem_total" | bc)

full="$usage% $temp° $mem_usage%"
echo "$full"

# Print color, if needed
if [ ${usage} -ge $t_crit ] || [ ${mem_usage} -ge $t_crit ]; then 
	status=33
#elif [ ${usage} -ge $t_warn ] || [ ${mem_usage} -ge $t_warn ]; then 
#    echo ""
#    echo "#ff6347"
fi

case $BLOCK_BUTTON in
	# click: show packages
	1 | 2 | 3) 
	summary=$(nvidia-smi --query-compute-apps=pid,process_name,used_memory --format=csv,noheader)
	notify-send "Top GPU-eaters" "  PID,   NAME,  MEM\n$summary"
	;;
esac

exit $status

