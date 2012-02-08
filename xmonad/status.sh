#!/bin/bash

#Layout
BAR_H=9
BIGBAR_W=32
WIDTH_L=800
WIDTH_R=800 #WIDTH_L + WIDTH_R = 1280
HEIGHT=16
X_POS_L=0
X_POS_R=$WIDTH_L
Y_POS=0

#Colors and font
CRIT="#99cc66"
BAR_FG="#3475aa"
BAR_BG="#363636"
DZEN_FG="#9d9d9d"
DZEN_FG2="#444444"
DZEN_BG="#020202"
COLOR_SEP=$DZEN_FG2
FONT="-*-montecarlo-medium-r-normal-*-11-*-*-*-*-*-*-*"

#Conky
CONKYFILE="${HOME}/.config/conky/conkyrc"
IFS='|'
INTERVAL=1
CPUTemp=0
GPUTemp=0
CPULoad0=0
CPULoad1=0
MpdInfo=0
MpdRandom="Off"
MpdRepeat="Off"

printWifiInfo() {
	WIFIDOWN=$(wicd-cli --wireless -d | wc -l)
	WIFISIGNAL=0
#	[[ $WIFIDOWN -ne "1" ]] && WIFISIGNAL=$(wicd-cli --wireless -d | grep Quality | awk '{print $2}')
	echo -n "^fg($DZEN_FG2)WIFI "
	if [[ $WIFIDOWN -ne "1" ]]; then
		WIFISIGNAL=$(wicd-cli --wireless -d | grep Quality | awk '{print $2}')
		echo -n "$(echo $WIFISIGNAL | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -s o -ss 1 -sw 2 -nonl) "
		echo -n "^fg()$WIFISIGNAL% "
	else
		echo -n "^fg($CRIT)N/A "
	fi
	return
}

printVolInfo() {
	Perc=$(amixer get Master | grep "Front Left:" | awk '{print $5}' | tr -d '[]%')
	Mute=$(amixer get Master | grep "Front Left:" | awk '{print $7}')
	echo -n "^fg($DZEN_FG2) VOL "
	if [[ $Mute == "[off]" ]]; then
		echo -n "$(echo $Perc | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -s o -ss 1 -sw 2 -nonl) "
		echo -n "^fg()off"
	else
		echo -n "$(echo $Perc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -s o -ss 1 -sw 2 -nonl) "
		echo -n "^fg()${Perc}%"
	fi
	return
}

printBattery() {
	BatPresent=$(acpi -b | wc -l)
	ACPresent=$(acpi -a | grep -c on-line)
	if [[ $BatPresent == "0" ]]; then
		echo -n "^fg($DZEN_FG2)AC ^fg($BAR_FG)on ^fg($DZEN_FG2)BAT ^fg($BAR_FG)off"
		return
	else
		RPERC=$(acpi -b | awk '{print $4}' | tr -d "%,")
		echo -n "^fg($DZEN_FG2)BAT "
		if [[ $ACPresent == "1" ]]; then
			echo -n "$(echo $RPERC | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -s o -ss 1 -sw 2 -nonl)"
		else
			echo -n "$(echo $RPERC | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -s o -ss 1 -sw 2 -nonl)"
		fi
		echo -n " ^fg()$RPERC%"
	fi
	return
}

printCPUInfo() {
	[[ $CPULoad0 -gt 70 ]] && CPULoad0="^fg($CRIT)$CPULoad0^fg()"
	[[ $CPULoad1 -gt 70 ]] && CPULoad1="^fg($CRIT)$CPULoad1^fg()"
	echo -n " ^fg($DZEN_FG2)CPU ^fg($BAR_FG)${CPULoad0}%^fg($DZEN_FG2)/^fg($BAR_FG)${CPULoad1}%"
	return
}

printTempInfo() {
    CPUTemp=$(sensors *-isa-* | grep -m 1 "Core" | awk '{print $3}' | grep -o "[0-9]\+\.[0-9]*")
    GPUTemp=$(sensors *-pci-* | grep -m 1 "temp" | awk '{print $2}' | grep -o "[0-9]\+\.[0-9]*")
	[[ $CPUTemp -gt 70 ]] && CPUTemp="^fg($CRIT)$CPUTemp^fg()"
	[[ $GPUTemp -gt 70 ]] && GPUTemp="^fg($CRIT)$GPUTemp^fg()"
	echo -n "^fg($DZEN_FG2)TEMP ^fg($BAR_FG)${CPUTemp}°^fg($DZEN_FG2)/^fg($BAR_FG)${GPUTemp}°"
	return
}

printMemInfo() {
	[[ $MemPerc -gt 70 ]] && CPUTemp="^fg($CRIT)$MemPerc^fg()"
	echo -n "^fg($DZEN_FG2)MEM ^fg($BAR_FG)${MemPerc}%"
	return
}

printDateInfo() {
	# echo -n "^fg()$(date '+%Y^fg(#444).^fg()%m^fg(#444).^fg()%d^fg(#3475aa)/^fg(#444444)%a ^fg(#363636)| ^fg()%H^fg(#444):^fg()%M^fg(#444):^fg()%S') "
	echo -n "^fg()$(date '+%Y^fg(#444)-^fg()%m^fg(#444)-^fg()%d ^fg(#444444)%a ^fg($COLOR_SEP)| ^fg()%H^fg(#444):^fg()%M^fg(#444):^fg()%S') "
	return
}

printSpace() {
	echo -n " ^fg($COLOR_SEP)|^fg() "
	return
}

# printLeft() {
	# while true; do
		# read CPULoad0 CPULoad1 CPUFreq MemUsed MemPerc MpdInfo MpdRandom MpdRepeat
		# printVolInfo
		# printSpace
		# printDropBoxInfo
		# printSpace
		# printMpdInfo
		# echo -n " ^fg()>^fg($BAR_FG)>^fg($DZEN_FG2)>"
		# echo
	# done
	# return
# }

printRight() {
	while true; do
		read CPULoad0 CPULoad1 CPUFreq MemUsed MemPerc MpdInfo MpdRandom MpdRepeat CPUTemp1 CPUTemp2
		printCPUInfo
		printSpace
        printTempInfo
        printSpace
		printMemInfo
        printSpace
        printVolInfo
        printSpace
        printWifiInfo
        printSpace
        printBattery
		printSpace
		printDateInfo
		echo
	done
	return
}


# conky -c $CONKYFILE -u $INTERVAL | printLeft | dzen2 -x $X_POS_L -y $Y_POS -w $WIDTH_L -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e '' &
conky -c $CONKYFILE -u $INTERVAL | printRight | dzen2 -x $X_POS_R -y $Y_POS -w $WIDTH_R -h $HEIGHT -fn $FONT -ta 'r' -bg $DZEN_BG -fg $DZEN_FG -p -e ''
