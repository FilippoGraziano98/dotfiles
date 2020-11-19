#!/usr/bin/env bash

brightness() {
	xbacklight -get | sed -E 's/([0-9]{1,3})\.[^ ]*/\1/g'
}

format() {
	PERL_FILTER='IF (/.*\[(\d+%)\] (\[(-?\d+.\d+dB)\] )?\[(on|off)\]/)'
	perl_filter+='{CORE::say $4 eq "off" ? "MUTE" : "'
	# If dB was selected, print that instead
	perl_filter+=$([[ $STEP = *dB ]] && echo '$3' || echo '$1')
	perl_filter+='"; exit}'
	perl -ne "$perl_filter"
}

case $BLOCK_BUTTON in
	3)
		# right click, set to `20
		xbacklight -set 20
		notify-send -c "brightness" --urgency=low "screen brightness" "set 20%"
		;;

	4)
		# scroll up, raise brightness
		xbacklight -inc 10
		notify-send -c "brightness" --urgency=low "screen brightness" "\+10% : $(brightness)%"
		;;

	5)
		# scroll down, lower brightness
		xbacklight -dec 10
		notify-send -c "brightness" --urgency=low "screen brightness" "\-10% : $(brightness)%"
		;;
esac

echo "$(brightness)%" 
#echo &#xf185; 
