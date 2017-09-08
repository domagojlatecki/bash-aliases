#!/bin/bash
# This file contains functions which act as de facto complex aliases.

sw() {
    if [ -z "$TW_ACTIVE" ]; then
        if [ -z "$OTHER_PWD_SET" ]; then
            OTHER_PWD_SET="t"
            OTHER_PWD="$PWD"
            OTHER_OLD_PWD="$OLDPWD"
        fi

        local ACTIVE_DIR_CLR="$PS1_DIR_CLR"

        PS1_DIR_CLR="$PS1_ALT_DIR_CLR"
        PS1_ALT_DIR_CLR="$ACTIVE_DIR_CLR"

        local TARGET="$OTHER_PWD"

        OTHER_PWD="$PWD"
    else
        TW_ACTIVE=""
        TARGET="$NTW_PWD"
        NTW_PWD=""
        NTW_OLD_PWD=""
    fi
    if [ ! -z "$1" ]; then
        TARGET="$1"
    fi

    cd "$TARGET"
}

#syn/sw/Swaps current working directory.
#doc/sw/Usage: sw [dir]\n
#doc/sw/Switches to an alternate working directory. Old working directory will be saved so it can be switched back to using this alias.

tw() {
    if [ -z "$TW_ACTIVE" ]; then
        TW_ACTIVE="t"
        NTW_PWD="$PWD"
        NTW_OLD_PWD="$OLDPWD"
        cd /tmp/
    fi
}

#syn#doc/tw/Switch to temporary working directory.

qw() {
    TW_ACTIVE=""
    NTW_PWD=""
    NTW_OLD_PWD=""
    PS1_DIR_CLR="01;33m"
    PS1_ALT_DIR_CLR="01;34m"
    OTHER_PWD_SET=""
    OTHER_PWD="$PWD"
}

#syn/qw/Sets both working directories to current working directory.
#doc/qw/Usage: qw\n
#doc/qw/Unsets the alternate working directory set by the sw alias.

sw_colored_wd() {
    if [ -n "$TW_ACTIVE" ]; then
        echo -n "[\[\033[$PS1_TW_DIR_CLR\]\w\[\033[0m\]]"
    elif [ -n "$OTHER_PWD_SET" ]; then
        if [ "$PWD" != "$OTHER_PWD" ]; then
            local symbol="*"
        else
            local symbol="."
        fi
        echo -n "[\[\033[$PS1_ALT_DIR_CLR\]$symbol\[\033[0m\]|\[\033[$PS1_DIR_CLR\]\w\[\033[0m\]]"
    else
        echo -n "[\[\033[$PS1_DIR_CLR\]\w\[\033[0m\]]"
    fi
}

h() {
    if [ -z "$1" ]; then
        echo -e "$(cat $ALIAS_FILES | grep '^#' | grep "#syn" | sed -r 's/^[^\/]+\/([^\/]+)\/(.+)/\\033[0;34m\1\\033[0m → \2/g' | sort)"
    else
        if [ "$1" = "-r" ]; then
            echo -e "$(cat $ALIAS_FILES | grep '^#' | grep "#syn" | sed -r 's/^[^\/]+\/([^\/]+)\/(.+)/\1 → \2/g' | sort)"
        else
            echo -e "$(cat $ALIAS_FILES | grep '^#' | grep "#doc" | grep "/$1/" | sed -r 's/^[^\/]+\/[^\/]+\/(.+)/\1/g')"
        fi
    fi
}

#syn/h/Provides info on specified alias, or lists all aliases if no argument is provided.
#doc/h/Usage: h [-r|alias_name]\n
#doc/h/-r : prints out help in raw format (without color codes).
#doc/h/Prints out detailed help message for specified alias. If no alias name is provided, list of all aliases along with their short descriptions will be printed.

hl() {
    h $1 | less -R
}

#syn#doc/hl/Same as 'h' alias, but piped to less.

y() {
    if [ -z "$1" ]; then
        if [ -z "$Y_FILES" ]; then
            echo "No file(s) selected."
        else
            echo "Selected file(s): $Y_FILES, source directory: $Y_SRC"
            read -p "Continue (y/n)? " answer
            if [ "$answer" = "y"  ]; then
                local TMP_PWD="$PWD"
                local TMP_OLDPWD="$OLDPWD"
                cd "$Y_SRC"
                cp -t "$TMP_PWD" $Y_FILES
                cd "$TMP_PWD"
                OLDPWD="$TMP_OLDPWD"
            else
                echo "Canceled."
            fi
        fi
    else
        echo "Selected file(s): $@"
        Y_FILES="$@"
        Y_SRC="$PWD"
    fi
}
#syn/y/Select and copy files to current working directory.
#doc/y/Usage: y [files...]\n
#doc/y/Selects files to be copied. When no files are specified, previously selected files are copied into current working directory.
