#!/bin/bash

_vbase="$HOME/github/PL888"


# Allow group to read new files/folders, see:
#   https://blogs.gentoo.org/mgorny/2011/10/18/027-umask-a-compromise-between-security-and-simplicity/
printf "\ncheck permissions: (y/n)"
read answer
if [ "${answer}" == "y" ]; then
    if ! grep -q "umask 027" $HOME/.bashrc; then
        echo "adding: umask 027 !!!"
        echo "# allow group to read files/folders" >> $HOME/.bashrc
        echo "umask 027" >> $HOME/.bashrc
        echo ""
    else
        echo "Found: umask 027 in $HOME/.bashrc !!!"
    fi
fi

# Add my custom modulefiles, persist configuration on future logins
printf "\ncheck modules: (y/n)"
read answer
if [ "${answer}" == "y" ]; then
    MODULES="${_vbase}/modulefiles/modules.sh"
    if ! grep -q "source $MODULES" $HOME/.bashrc; then
        echo "Adding: $MODULES !!!"
        echo "# Add custom modules on login" >> $HOME/.bashrc
        echo "source $MODULES" >> $HOME/.bashrc
        echo ""
    else
        echo "Found: $MODULES in $HOME/.bashrc !!!"
    fi
    unset $MODULES
fi


# Add my bash commands/scripts to environment, persist configuration on future logins
printf "\ncheck Scripts: (y/n)"
read answer
if [ "${answer}" == "y" ]; then
if ! grep -q "PATH=/home/van/Scripts/bin" $HOME/.bashrc; then
    echo "Adding: Scripts"
    echo "# Add van's custom bash commands/scripts on login" >> $HOME/.bashrc
    echo "export PATH=/home/van/Scripts/bin:\${PATH}" >> $HOME/.bashrc
    echo ""
else
    echo "Found: $PATH in $HOME/.bashrc !!!"
fi
fi

# Persist changes to environment on future logins
printf "\ncheck aliases: (y/n)"
read answer
if [ "${answer}" == "y" ]; then
if ! grep -q "source $BASE/aliases/aliases.sh" $HOME/.bashrc; then
    echo "Adding: $BASE/aliases/aliases.sh !!!"
    echo "# Add aliases to ~/.bashrc" >> $HOME/.bashrc
    echo "source $BASE/aliases/aliases.sh" >> $HOME/.bashrc
    echo ""
else
    echo "Found: $BASE/aliases/aliases.sh in $HOME/.bashrc !!!"
fi
fi
