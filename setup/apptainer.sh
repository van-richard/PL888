#!/bin/bash
#

sudo apt update -y
sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt update -y
sudo apt install -y apptainer

sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt update -y
sudo apt install -y apptainer-suid
