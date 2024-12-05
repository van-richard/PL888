#!/bin/bash

cat /etc/shells

read -p "Change current shell to: " NEW
read -p "Continue? (y/n): " confirm && [[ $confirm ==[yY] || $confirm == [yY][eE][sS] ]] || exit 1

chsh ${NEW}

