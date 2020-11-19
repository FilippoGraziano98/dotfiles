#!/usr/bin/env bash

WIDTH=${WIDTH:-200}
HEIGHT=${HEIGHT:-200}

case $BLOCK_BUTTON in
    1) # left click
		#posX=$(($BLOCK_X - $WIDTH / 2))
		#posY=$(($BLOCK_Y - $HEIGHT))
		posX=$((1920 - 25 - $WIDTH))
		posY=$((1080 - 15 - $HEIGHT))
		i3-msg -q "exec yad --calendar  --width=$WIDTH --height=$HEIGHT  --undecorated --fixed  --close-on-unfocus --no-buttons  --posx=$posX --posy=$posY  > /dev/null"
		;;
	3) #right click
		notify-send "TODO" "$(calcurse -Q --days 2)" 
		;;
esac

echo "$(date '+%a %d-%m-%y %H:%M:%S %p')"

