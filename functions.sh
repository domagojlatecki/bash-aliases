#!/bin/bash
# This file contains functions which act as de facto complex aliases.

A() {
    ANCHOR="$PWD"
}

U() {
    if [[ "$PWD" == "$ANCHOR"* ]]; then
        cd "$ANCHOR"
    fi
}

sw() {
    local target=""
    local tragetOldPWd=""

    if [ -z "$TW_ACTIVE" ]; then
        if [ -z "$PWD_IDX" ]; then
            PWD_IDX="1"
            OTHER_PWD="$PWD"
            OLD_PWD_1="$OLDPWD"
            OLD_PWD_2="$OLDPWD"
        fi

        if [ "$PWD_IDX" -eq "1" ]; then
            PWD_IDX="2"
            OLD_PWD_1="$OLDPWD"
            tragetOldPWd="$OLD_PWD_2"
        else 
            PWD_IDX="1"
            OLD_PWD_2="$OLDPWD"
            tragetOldPWd="$OLD_PWD_1"
        fi

        target="$OTHER_PWD"

        OTHER_PWD="$PWD"
    else
        TW_ACTIVE=""
        target="$NTW_PWD"

        if [ -n "$PWD_IDX" ]; then
            if [ "$PWD_IDX" -eq "1" ]; then
                tragetOldPWd="$OLD_PWD_1"
            else
                tragetOldPWd="$OLD_PWD_2"
            fi
        else
            tragetOldPWd="$NTW_OLD_PWD"
        fi

        NTW_PWD=""
        NTW_OLD_PWD=""
    fi

    if [ ! -z "$1" ]; then
        target="$1"
    fi

    cd "$target"

    if [ ! -z "$tragetOldPWd" ]; then
        OLDPWD="$tragetOldPWd"
    fi
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
    PWD_IDX=""
    OTHER_PWD="$PWD"
}

#syn/qw/Sets both working directories to current working directory.
#doc/qw/Usage: qw\n
#doc/qw/Unsets the alternate working directory set by the sw alias.

sw_colored_wd() {
    local wdClr="\[\033[$PS1_DIR_CLR\]"
    local oWdClr="\[\033[$PS1_ALT_DIR_INACTIVE_CLR\]"

    if [ "${PWD_IDX:-0}" -eq "2" ]; then
        wdClr="\[\033[$PS1_ALT_DIR_CLR\]"
        oWdClr="\[\033[$PS1_DIR_INACTIVE_CLR\]"
    fi

    local aClr="\[\033[$ANCHOR_CLR\]"
    local rstClr="\[\033[0m\]"
 
    local anchoredWd="${wdClr}\w${rstClr}"

    if [[ -n "$ANCHOR" ]]; then
        if [[ "$PWD" == "$ANCHOR/"* ]]; then
            local beforeAnchor="$ANCHOR"
            local afterAnchor="${PWD/$ANCHOR\//}"

            local anchored="${beforeAnchor}${rstClr}${aClr}${ANCHOR_SYMBOL}${rstClr}${wdClr}${afterAnchor}${rstClr}"
            anchoredWd="${wdClr}${anchored/$HOME/~}"
        elif [[ "$ANCHOR" == "/" && "$PWD" != "/" ]]; then
            anchoredWd="${PWD/\//${aClr}$ANCHOR_SYMBOL${rstClr}${wdClr}}${rstClr}"
        else
            anchoredWd="${wdClr}${PWD/$HOME/~}${rstClr}"
        fi
    fi

    if [ -n "$TW_ACTIVE" ]; then
        echo -n "[\[\033[$PS1_TW_DIR_CLR\]\w$rstClr]"
    elif [ -n "$PWD_IDX" ]; then
        local relWdPath=$(realpath -s --relative-to="$PWD" "$OTHER_PWD")

        if [[ "$relWdPath" != "~"* && "$relWdPath" != .* && "$relWdPath" != /* ]]; then
            relWdPath="./$relWdPath"
        fi

        if [ "$PWD_IDX" -eq "1" ]; then
            echo -n "[$anchoredWd|$oWdClr$relWdPath$rstClr]"
        else 
            echo -n "[$oWdClr$relWdPath$rstClr|$anchoredWd]"
        fi
    else
        echo -n "[$anchoredWd]"
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
                local tmpPwd="$PWD"
                local tmpOldPwd="$OLDPWD"
                cd "$Y_SRC"
                cp -t "$tmpPwd" $Y_FILES
                cd "$tmpPwd"
                OLDPWD="$tmpOldPwd"
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

current_java_version() {
    echo -ne "[\[\033[$ACTIVE_JAVA_VERSION_CLR\]\xE2\x98\x95$ACTIVE_JAVA_VERSION\[\033[0m\]]"
}

jv() {
    if [ -z "$1" ]; then
        echo "Active Java version: $ACTIVE_JAVA_VERSION"
    else
        if [ -z "${JAVA_VERSIONS[$1]}" ]; then
            echo "No such Java version: $1"
        else
            ACTIVE_JAVA_VERSION="$1"
            local withoutJavaPath="${PATH/${JAVA_HOME}\/bin:/}"
            export JAVA_HOME="${JAVA_VERSIONS[$ACTIVE_JAVA_VERSION]}"
            export PATH="${JAVA_HOME}/bin:${withoutJavaPath}"
            echo "Switched to Java version $ACTIVE_JAVA_VERSION"
        fi
    fi
}

#syn/jv/Sets currently active Java version.
#doc/jv/Usage: jv [version]

opt_newline_and_exit_code() {
    local ec=$?
    local ecClr="$EXIT_CODE_Z_CLR"

    if [ $ec -ne 0 ]; then
        local ecClr="$EXIT_CODE_NZ_CLR"
    fi

    IFS=';' read -sdR -p $'\E[6n' row col

    if [ $col -ne 1 ]; then
        echo -n "\[\033[0;31m\]⊖ ↵\[\033[0m\]\n\[\033[0m\]╭─[\u@\h][\[\033[$ecClr\]$ec\[\033[0m\]]"
    else
        echo -n "\[\033[0m\]╭─[\u@\h][\[\033[$ecClr\]$ec\[\033[0m\]]"
    fi
}

bg_job_count() {
    local numJobs="$(jobs | wc -l)"

    if [ $numJobs -ne 0 ]; then
        echo -n "{\[\033[$JOBS_CLR\]λ$numJobs\[\033[0m\]}"
    fi
}
