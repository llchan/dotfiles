#!/bin/sh

killall status.sh
$(echo $XDG_CONFIG_HOME)/wmfs/status.sh &
