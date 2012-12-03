#!/bin/sh

fifo="/tmp/monsterwm"
export PATH=~/build/mstatusbar:~/build/bar:$PATH

trap 'rm -f "${fifo}"' INT TERM EXIT
[ -p "${fifo}" ] || { rm -f "${fifo}"; mkfifo -m 600 "${fifo}"; }

mstatusbar < "${fifo}" | bar &

monsterwm > "${fifo}"
