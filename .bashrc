# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


####################
# cd Aliases
####################
alias cdfun='cd /fun'
alias cddown='cd /fun/downloads'
alias cdvid='cd /fun/videos'
alias cdpic='cd /fun/pictures'
alias cdmus='cd /fun/music'
alias cdmit='cd /fun/Dropbox/MIT/'
alias cdproj='cd ~/projects'
alias cdbc='cd ~/projects/battlecode/2010'
alias cdb='cd ~/projects/battlecode/2010/teams/team212'

####################
# ls Aliases
####################
alias ll='ls -hl'
alias lal='ls -hal'
alias grt='ls -hgrt'
alias grta='ls -hgrta'

####################
# aptitude Aliases
####################
alias update='sudo aptitude update'
alias safe-upgrade='sudo aptitude safe-upgrade'
alias dist-upgrade='sudo aptitude dist-upgrade'
alias search='sudo aptitude search'
alias show='sudo aptitude show'
alias install='sudo aptitude install'
alias remove='sudo aptitude remove'

####################
# ssh Aliases
####################
alias ttt='ssh -p 315 triple-t.mit.edu'
alias athena='ssh linux.mit.edu'
alias tracksbox='ssh llchan.xvm.mit.edu'
alias micro='ssh -i ~/llchan_ec2_key.pem ec2-user@ec2-184-73-30-101.compute-1.amazonaws.com'
alias micro2='ssh -i ~/llchan_ec2_key.pem root@ec2-174-129-160-179.compute-1.amazonaws.com'
alias micro4='ssh -i ~/llchan_ec2_key.pem ubuntu@204.236.219.27'
alias ec2llchan='ssh -i ~/llchan_ec2_key.pem ec2-50-17-161-38.compute-1.amazonaws.com'
# alias arch='ssh -i llchan_ec2_key.pem llchan@ec2-184-73-62-121.compute-1.amazonaws.com'
alias arch='ssh -i llchan_ec2_key.pem llchan@75.101.163.59'
# alias winxp='rdesktop llchan-vm-winxp.csail.mit.edu -g 1280x1024 -u Administrator -p gecco2005'
alias winxp='rdesktop llchan-vm-winxp.csail.mit.edu -g 1280x800 -u Administrator -p gecco2005'
alias vcenter='rdesktop evo-vcenter.csail.mit.edu -g 1280x800 -u Administrator -p gecco2005'
alias win7='rdesktop evo-windows01.csail.mit.edu -g 1280x800 -u evo-admin -p gecco2005'
alias win='rdesktop evo-win01.csail.mit.edu -g 1280x800 -u evo-admin -p gecco2005'
alias win02='rdesktop evo-win02.csail.mit.edu -g 1280x800 -u evo-admin -p gecco2005'
alias evo02='ssh evo02.csail.mit.edu'
alias evo-esx='ssh evo-admin@evo-esx.csail.mit.edu'
alias evo-esx03='ssh evo-admin@evo-esx03.csail.mit.edu'
alias evo-apache01='ssh evo-admin@evo-apache01.csail.mit.edu'
alias evo-apache02='ssh evo-admin@evo-apache02.csail.mit.edu'
alias evo-apache03='ssh evo-admin@evo-apache03.csail.mit.edu'
alias evo-cpuloader01='ssh evo-admin@evo-cpuloader01.csail.mit.edu'
alias evo-mysql01='ssh evo-admin@evo-mysql01.csail.mit.edu'
alias evo-rubis01='ssh evo-admin@128.30.108.116' #evo-rubis01.csail.mit.edu'
alias evo-data='ssh evo-admin@evo-data.csail.mit.edu'
alias evo-faban-agent='ssh evo-admin@evo-faban-agent01.csail.mit.edu'
alias evo-faban-master='ssh evo-admin@evo-faban-master.csail.mit.edu'

####################
# misc Aliases
####################
alias psg='ps aux | grep'
alias eclimd='screen -S eclimd /usr/lib/eclipse/eclimd'

export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/cuda/lib64:/usr/local/cuda/lib:/usr/lib:$LD_LIBRARY_PATH
export PATH=$PATH:/usr/local/cuda/bin
export CUDA_ROOT=/usr/local/cuda

calc(){ awk "BEGIN{ print $* }" ;}

alias wf='sudo iwconfig wlan0 rate 54M'

export P4CONFIG=.p4config

# export PYTHONPATH=$PYTHONPATH:/mts-cm/home/lawrencechan/pyVpx
# export PYTHONPATH=$PYTHONPATH:/build/toolchain/noarch/pyVpx-4.0.0-162856/

export EDITOR=vim
export GIT_SSL_NO_VERIFY=true

set -o vi

# This is probably hacky, but if we're not in a tmux/screen, we should tell
# tmux/screen that we have 256 colors.  Couldnt get tmux -2 to do what i wanted
# it to...
case "$TERM" in
xterm*|rxvt*)
    export TERM=xterm-256color
    ;;
*)
    ;;
esac

#MATHEMATICA_FONT_DIR="/usr/share/fonts/type1/mathematica"
#if [ -d "$MATHEMATICA_FONT_DIR" ]; then
#    xset fp+ "$MATHEMATICA_FONT_DIR"
#fi
# mkfontdir ~/.fonts
# xset fp+ ~/.fonts
# xset fp rehash

#export WORKON_HOME="$HOME/.python-environments"
#export PIP_VIRTUALENV_BASE=$WORKON_HOME
#export PIP_RESPECT_VIRTUALENV=true
#source /usr/local/bin/virtualenvwrapper.sh

#xrdb -merge $HOME/.Xdefaults

alias agi='cd /home/llchan/Dropbox/Projects/AgI'
