#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# The MIT License (MIT)                                                       #
#                                                                             #
# Copyright © 2016 Domagoj Latečki                                            #
#                                                                             #
# Permission is hereby granted, free of charge, to any person obtaining a     #
# copy of this software and associated documentation files (the "Software"),  #
# to deal in the Software without restriction, including without limitation   #
# the rights to use, copy, modify, merge, publish, distribute, sublicense,    #
# and/or sell copies of the Software, and to permit persons to whom the       #
# Software is furnished to do so, subject to the following conditions:        #
#                                                                             #
# The above copyright notice and this permission notice shall be included     #
# in all copies or substantial portions of the Software.                      #
#                                                                             #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         #
# DEALINGS IN THE  SOFTWARE.                                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# This file contains functions which act as de facto complex aliases.

PS1_DIR_CLR="01;33m"
PS1_ALT_DIR_CLR="01;34m"

sw() {
    if [ -z "$OTHER_PWD_SET" ];
    then
        OTHER_PWD_SET="t"
        OTHER_PWD="$PWD"
        OTHER_OLD_PWD="$OLDPWD"
    fi

    local ACTIVE_DIR_CLR="$PS1_DIR_CLR"

    PS1_DIR_CLR="$PS1_ALT_DIR_CLR"
    PS1_ALT_DIR_CLR="$ACTIVE_DIR_CLR"

    local TARGET="$OTHER_PWD"

    OTHER_PWD="$PWD"

    if [ ! -z "$1" ];
    then
        TARGET="$1"
    fi

    cd "$TARGET"
}

#syn/sw/Swaps current working directory.
#doc/sw/Usage: sw [dir]\n
#doc/sw/Switches to an alternate working directory. Old working directory will be saved so it can be switched back to using this alias.

qw() {
    PS1_DIR_CLR="01;33m"
    PS1_ALT_DIR_CLR="01;34m"
    OTHER_PWD_SET=""
    OTHER_PWD="$PWD"
}

#syn/qw/Sets both working directories to current working directory.
#doc/qw/Usage: qw\n
#doc/qw/Unsets the alternate working directory set by the sw alias.

sw_colored_wd() {
    if [ -n "$OTHER_PWD_SET" ]; then
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

count_code_lines() {
    local total_comment_count=0
    local total_documentation_count=0
    local total_line_count=0
    local total_empty_lines=0
    local total_source_files=0

    for source_file in $(find . -type f -name "$2"); do
        total_comment_count=$((total_comment_count + $(cat $source_file | grep -e "^\s*//" | wc -l)))
        total_comment_count=$((total_comment_count + $(cat $source_file | grep -Pzo "^.*?/\*[^\*][\s\S]*?\*\/" | rev | grep -vP ".+?\*/\s*[^\s]" | wc -l)))
        total_documentation_count=$((total_documentation_count + $(cat $source_file | grep -Pzo "^.*?/\*\*[\s\S]*?\*\/" | rev | grep -vP ".+?\*\*/\s*[^\s]" | wc -l)))
        total_empty_lines=$((total_empty_lines + $(cat $source_file | grep -e "^\s*$" | wc -l)))
        total_line_count=$((total_line_count + $(cat $source_file | wc -l)))
        total_source_files=$((total_source_files + 1))
        grand_total_file_count=$((grand_total_file_count + 1))
    done

    local total_code_count=$((total_line_count-total_comment_count-total_documentation_count-total_empty_lines))

    if [ $total_source_files -ne 0  ]; then
        echo ""
        echo -e "Found total of \033[0;33m$total_line_count\033[0m line(s) across \033[0;33m$total_source_files\033[0m $1 source file(s)."
        echo -e "There are \033[0;32m$total_code_count\033[0m line(s) of code, \033[0;36m$total_documentation_count\033[0m line(s) of documentation, \033[0;34m$total_comment_count\033[0m line(s) of comments and \033[0;31m$total_empty_lines\033[0m empty line(s)."
    fi

    grand_total_line_count=$((grand_total_line_count + total_line_count))
}

clns() {
    grand_total_line_count=0
    grand_total_file_count=0
    count_code_lines Java "*.java"
    count_code_lines JavaScript "*.js"
    count_code_lines TypeScript "*.ts"

    if [ $grand_total_line_count -ne 0 ]; then
        echo -e "\n\033[1;33m$grand_total_line_count\033[0m line(s) across \033[1;33m$grand_total_file_count\033[0m files.\n"
    else
        echo -e "\nNo code found.\n"
    fi
}

#syn/clns/Counts lines of code in current working directory.
#doc/clns/Usage: clns\n
#doc/clns/Counts and prints number of empty lines, lines with code, comments and documentation contained in working directory tree.
#doc/clns/Lines are counted only for files that end in .java, .js or .ts.

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
