#!/bin/bash

#------------------------------------------------------------------------

#execute the general script (passing over the environment variables)
~/.config/i3/i3blocks_scripts/ip.sh

#------------------------------------------------------------------------



FZF_FLAGS="--border --reverse --height=100 --inline-info"

FILE_FULLPATH=/tmp/i3blocks_wifi_netctl_network_path
FILE_WNAME=/tmp/i3blocks_wifi_netctl_network
touch $FILE

case $BLOCK_BUTTON in
    1) # left click
                    #\"fd '^wlp3s0-.*$' /etc/netctl -d 1 --no-ignore | fzf > $FILE_FULLPATH \
        i3-msg -q "exec st -c wifi-netctl-menu -g '72x12+112+848' -e /bin/bash -c \
                    \"find /etc/netctl -maxdepth 1 -type f -regex '^/etc/netctl/$BLOCK_INSTANCE-.*$' -printf '%TF %Tk:%TM  %p\n' | sort -r | fzf $FZF_FLAGS --prompt 'Select Wireless Network: ' | cut -d ' ' -f 5 > $FILE_FULLPATH \
                        && cat $FILE_FULLPATH | xargs sudo touch \
                        && cat $FILE_FULLPATH | cut -d '/' -f 4 > $FILE_WNAME \
                        && sudo netctl stop-all \
                        && cat $FILE_WNAME | xargs -I wname sudo netctl start wname\""
		;;
    2) # middle click
        i3-msg -q "exec st -c wifi-netctl-menu -e sudo wifi-menu"
		;;
    3) # right click
        notify-send "WiFi Network [$BLOCK_INSTANCE]" "$(cat $FILE_WNAME)"
		;;
esac
