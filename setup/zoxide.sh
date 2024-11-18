#!/bin/bash

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "export PATH=/home/van/.local/bin:\$PATH" >> ~/.bashrc
echo "eval "\$(zoxide init bash --cmd cd)" >> ~/.bashrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
