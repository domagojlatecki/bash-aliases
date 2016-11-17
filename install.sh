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

if [ -f ~/.bash_aliases ]; then
    echo "Warning: file ~/.bash_aliases already exists. Do you want to overwrite it or append to it?"
    echo "A - Append"
    echo "O - Overwrite"
    echo "Any other key - Cancel"
    read answer

    case "$answer" in
        A)
            action='>>'
        ;;
        O)
            action='>'
        ;;
        *)
            echo "Canceling..."
            exit
        ;;
    esac
else
    action='>>'
fi

bash -c \
"cat $action ~/.bash_aliases << EOF
export ALIAS_HOME=\"$PWD\"
export ALIAS_FILES=\"\\\$ALIAS_HOME/simple_aliases.sh \\\$ALIAS_HOME/functions.sh\"

for ALIAS_FILE in \\\$ALIAS_FILES; do
    source \"\\\$ALIAS_FILE\"
done
EOF"

echo "Action completed."
