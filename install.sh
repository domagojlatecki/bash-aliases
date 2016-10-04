#!/bin/bash
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
