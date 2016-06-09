[ -r /etc/bashrc ] && source /etc/bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# [ -z "$PS1" ] && return


# ---- shell options ---- #
set -o vi
shopt -s checkwinsize  # checkhash
shopt -s direxpand  # prevent tab from escaping env vars

stty -ixon  # disable flow control


# ---- history options ---- #
shopt -s histappend cmdhist histverify

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=65536
HISTFILESIZE=1048576


# ---- prompt options ---- #
git_prompt_paths=(
    /usr/share/git-core/contrib/completion/git-prompt.sh
    /usr/local/etc/bash_completion.d/git-prompt.sh
)
for p in "${git_prompt_paths[@]}"; do
    if [ -r "$p" ]; then
        source "$p"
        git_prompt_loaded=true
        break
    fi
done
if [ "$git_prompt_loaded" != true ]; then
    echo 'WARNING: git-prompt.sh could not be loaded, using dummy function' >2
    __git_ps1() { :; }
    export __git_ps1
fi

PROMPT_DIRTRIM=2
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto

set_prompt () {
    local last_command=$?
    PS1=''

    # save after every command
    history -a

    # color escape codes
    local color_off='\[\e[0m\]'
    local color_red='\[\e[0;31m\]'
    local color_green='\[\e[0;32m\]'
    local color_yellow='\[\e[0;33m\]'
    local color_blue='\[\e[0;34m\]'
    local color_purple='\[\e[0;35m\]'
    local color_cyan='\[\e[0;36m\]'

    # add purple exit code if non-zero
    if [[ $last_command != 0 ]]; then
        PS1+="${color_purple}${last_command} ${color_off} "
    fi

    # shortened working directory
    PS1+='\w '

    # add Git status with color hints
    PS1+="$(__git_ps1 "(%s) ")"

    # red for root, off for user
    if [[ $EUID == 0 ]]; then
        PS1+="${color_red}#${color_off} "
    else
        PS1+="${color_off}$ "
    fi
}
PROMPT_COMMAND='set_prompt'


# ---- misc environment variables ---- #
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

export EDITOR=vim
export PAGER=less

case "$TERM" in
    rxvt-unicode-256color)
        export TERM=xterm-256color
        ;;
esac


# ---- misc command mods ---- #
export LESS="-i -M -S -x4 -F -X -R"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}


# ---- aliases ---- #
alias ll='ls -lh'
alias lla='ls -lha'
