#!/bin/bash

LoginNode=$(echo $(hostname))

# if [[ "${LoginNode}" != "login01.cluster" ]]; then
#     exit 1
# fi

# Get a list of existing tmux sessions:
TMUX_SESSIONS=$(tmux ls | awk -F: '{print $1}')

if [  $(realpath .) -eq $(echo $HOME) ]; then
    if [[ $(tmux ls | grep "attached" | wc -l ) -eq 1 ]]; then
        exit 1
    fi
fi

# If there are no existing sessions:
if [[ -z $TMUX_SESSIONS ]]; then
    echo "No existing tmux sessions. Creating a new session called 'default'..."
    tmux new -s 0
else
    # Present a menu to the user:
    echo "Existing tmux sessions:"
    echo "$TMUX_SESSIONS"
    echo "Enter the name of the session you want to attach to, or 'new' to create a new session: "
    read user_input

    # Attach to the chosen session, or create a new one:
    if [[ $user_input == "new" ]]; then
        echo "Enter name for new session: "
        read new_session_name
        tmux new -s $new_session_name
    elif [[ $user_input ]]; then
        tmux attach -t $user_input
    else
        exit 0
    fi
fi
