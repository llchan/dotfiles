echo '' | column -nts, &> /dev/null
HAS_COLUMN_N=$?

function csvless {
    if [ -z HAS_COLUMN_N ]; then
        column -nts, "$@" | less -S
    else
        column -ts, "$@" | less -S
    fi
}

function csvgrep {
    if [ -z HAS_COLUMN_N ]; then
        awk 'NR==1 || /$1/' "$2" | column -nts, "$@" | less -S
    else
        awk 'NR==1 || /$1/' "$2" | column -ts, "$@" | less -S
    fi
}
