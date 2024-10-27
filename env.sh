#!/bin/bash

NEW_ENV="/home/van/env.sh"
MOD_ENV="/home/van/modulefiles/modules.sh"

# Allow group to read new files/folders, see:
#   https://blogs.gentoo.org/mgorny/2011/10/18/027-umask-a-compromise-between-security-and-simplicity/
if ! grep -q "umask 027" $HOME/.bashrc; then
    echo "# Fix permissions" >> $HOME/.bashrc
    echo "umask 027" >> $HOME/.bashrc
fi

# Add my custom modulefiles, persist configuration on future logins
if ! grep -q "source $MOD_ENV" $HOME/.bashrc; then
    echo "# Add custom modules on login" >> $HOME/.bashrc
    echo "source $MOD_ENV" >> $HOME/.bashrc
else
    echo "Please remove this line: source /home/van/modules.sh - VAN"
    exit 1
fi

# Add my bash commands/scripts to environment, persist configuration on future logins
if ! grep -q "PATH=/home/van/Scripts/bin" $HOME/.bashrc; then
    echo "# Add van's custom bash commands/scripts on login" >> $HOME/.bashrc
    echo "export PATH=/home/van/Scripts/bin:\${PATH}" >> $HOME/.bashrc
fi

# Persist changes to environment on future logins
if ! grep -q "source $NEW_ENV" $HOME/.bashrc; then
    echo "# Add custom environment to ~/.bashrc" >> $HOME/.bashrc
    echo "source $NEW_ENV" >> $HOME/.bashrc
fi

# Persist changes to environment on future logins
if ! grep -q "source $NEW_ENV" $HOME/.bashrc; then
    echo "# Add custom environment to ~/.bashrc" >> $HOME/.bashrc
    echo "source $NEW_ENV" >> $HOME/.bashrc
fi

#############################################################
# NOTE: ECHO IN CONSOLE WILL BREAK SCP/RSYNC 
#############################################################
# Print log message
#echo "$(/home/van/ascii/random-ascii)"
#echo " "


