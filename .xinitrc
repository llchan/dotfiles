#!/bin/sh
xmodmap ~/.Xmodmap

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb -merge ~/.Xresources

xset +fp /usr/share/fonts/local
xset fp rehash


DEFAULT_SESSION=subtle

case $1 in
subtle)
	exec subtle
	;;
awesome)
	exec awesome
	;;
i3)
	exec i3
	;;
xfce)
	exec ck-launch-sesion startxfce4
	;;
*)
	exec $DEFAULT_SESSION
	;;
esac

