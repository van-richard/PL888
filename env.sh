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
#   See /home/van/modules.sh for more information
if ! grep -q "source $MOD_ENV" $HOME/.bashrc; then
    echo "# Add custom modules on login" >> $HOME/.bashrc
    echo "source $MOD_ENV" >> $HOME/.bashrc
fi
if grep -q "source /home/van/modules.sh" $HOME/.bashrc; then
    echo "Please remove this line: source /home/van/modules.sh - VAN"
fi

# Add my bash commands/scripts to environment, persist configuration on future logins
#   See /home/van/Scripts/bin for more information
if ! grep -q "PATH=/home/van/Scripts/bin" $HOME/.bashrc; then
    echo "# Add van's custom bash commands/scripts on login" >> $HOME/.bashrc
    echo "export PATH=/home/van/Scripts/bin:\${PATH}" >> $HOME/.bashrc
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


#############################################################
# OLD - need to write a better check method
#############################################################
# if [ -f "${HOME}/.bashrc" ]; then
# #    echo "FOUND: $HOME/.bashrc" >> $LOG
#     if ! grep -q "$NEW_ENV" $HOME/.bashrc; then
#         # Add env to login
# #        echo "Add new env variables" >> $LOG
#         echo "# Add custom environment to ~/.bashrc" >> $HOME/.bashrc
#         echo "source $NEW_ENV" >> $HOME/.bashrc
#     fi
#     if ! grep -q "umask 027" $HOME/.bashrc; then
#         # Fix permission on login
# #        echo "Fix permissions !!!" >> $LOG
#         echo "# Fix permissions" >> $HOME/.bashrc
#         echo "umask 027" >> $HOME/.bashrc
#     fi
# else
#     echo "NOT FOUND: ${HOME}/.bashrc"
# fi

#if [ -d "${CCATS}/bin" ]; then
#    if ! grep -q "$CCATS/bin" $HOME/.bashrc; then
#        echo "export PATH=${CCATS}/bin:$PATH" >> $HOME/.bashrc
#    fi
#else
#    echo "NOT FOUND: ${CCATS}/bin" >> $LOG
#fi

# Add custom modules
# if [[ -f "$MOD_ENV" ]]; then
#     echo "FOUND: $MOD_ENV" >> $LOG
#     if ! grep -q "source $MOD_ENV" $HOME/.bashrc; then
#         echo "# Add custom modules on login" >> $HOME/.bashrc
#         echo "source $MOD_ENV" >> $HOME/.bashrc
#     fi
# else
#     echo "NOT FOUND: $MOD_ENV" >> $LOG
# fi

# Print log message
#echo "$(/home/van/ascii/random-ascii)"
#echo " "
#/home/van/ascii/random-ascii > $LOGDIR/MESSAGE
#cat $LOGDIR/MESSAGE

#printf "\n%s\n" \
#    "\$SHELL environment configuration $(echo $NEW_ENV)" \
#    "CCATS BASH / Python / SLURM scripts & excutable commands $(echo $CCATS)"\
#    "Custom modules $(echo $MOD_ENV)" >> $LOGDIR/MESSAGE

