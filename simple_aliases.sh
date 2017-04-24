#!/bin/bash
# This file contains simple bash aliases which don't use any conditional
# branching or helper functions.

alias -- ~='cd'
#syn#doc/~/Return to home directory.
alias -- -='cd -'
#syn#doc/-/Return to previous working directory.
alias -- a.='git add --all'
#syn#doc/a./Alias for 'git add --all'.
alias -- a='ls -A'
#syn#doc/a/List almost all direcotries in current working directory.
alias -- c='git commit'
#syn#doc/c/Alias for 'git commit'.
alias -- d='git pull'
#syn#doc/d/Alias for 'git pull'.
alias -- e='nautilus --browser .'
#syn#doc/e/Opens file explorer in current working directory.
alias -- ew='sw; qw'
#syn#doc/ew/Sets both working directories to an alternative directory.
alias -- f='git fetch'
#syn#doc/f/Alias for 'git fetch'.
alias -- hs='h -r | grep'
#syn#doc/hs/Searches alias descritions for specified word.
alias -- m='man'
#syn#doc/m/Alias for 'man'.
alias -- n4='ifconfig | grep -E "encap|inet " |
sed -r "s/^[A-Za-z0-9]+.+/€\0/" | xargs | sed -r "s/€/\n/g" | grep "addr:" |
sed -r "s/([A-Za-z0-9]+).+?addr:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).+/\1 -> \2/"'
#syn#doc/n4/Prints IPv4 adresses of all availible network interfaces.
alias -- o='git stash pop'
#syn#doc/o/Alias for 'git stash pop'.
alias -- p='git push'
#syn#doc/p/Alias for 'git push'.
alias -- rm='rm -vrI'
#syn#doc/rm/Safeguard for 'rm' command.
alias -- s='git status'
#syn#doc/s/Alias for 'git status'.
alias -- t='git stash'
#syn#doc/t/Alias for 'git stash'.
alias -- u='cd ..'
#syn#doc/u/Go up one directory.
alias -- u4='cd ../../..'
#syn#doc/u4/Go up 4 directories.
alias -- u5='cd ../../../..'
#syn#doc/u5/Go up 5 directories.
alias -- uu='cd ../..'
#syn#doc/uu/Go up 2 directories.
alias -- uuu='cd ../../..'
#syn#doc/uuu/Go up 3 directories.
alias -- uuuu='cd ../../..'
#syn#doc/uuuu/Go up 4 directories.
alias -- uuuuu='cd ../../../..'
#syn#doc/uuuuu/Go up 5 directories.
alias -- v='vim'
#syn#doc/v/Open vim.
alias -- vs='vmstat -wS M'
#syn#doc/vs/Show virtual memory statistics in wide mode, using MiB as unit.
alias -- vs1='vs 1'
#syn#doc/vs1/Alias for 'vs 1'.
alias -- sv='sudo vim'
#syn#doc/sv/Open vim as superuser.
alias -- x='clear'
#syn#doc/x/Clears the screen.
alias -- zg='curl -l wttr.in/Zagreb'
#syn#doc/zg/Prints weather in Zagreb. Requires internet connection.
