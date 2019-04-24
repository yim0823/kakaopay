#!/bin/bash

##################################
# Installing python 3.x
##################################

# check Python exists and version
REQUIRE_VERSION=3.0
is_need_to_install=false
if which python > /dev/null 2>&1;
then
    # Python is already installed
    python_version=`python --version 2>&1 | awk '{print $2}'`
    echo "Python version $python_version is installed."

	if $(dpkg --compare-versions $python_version "lt" $REQUIRE_VERSION);
	then 
		echo "Need to install Python 3.x"
		is_need_to_install=true
	else
		echo "No need to install Python 3.x"
		is_need_to_install=false
	fi
else
    # Python is not installed
    echo "No Python executable is found."
    is_need_to_install=true
fi

if $is_need_to_install; 
then
	echo "Installing... Python3 & pip3"
	
	# update and upgrade the system with the apt command
	sudo apt-get update && sudo apt-get -y upgrade

	# install essential libraries for development enviroment.
	sudo apt -y install build-essential libssl-dev libffi-dev python3-dev

	# installing python 3.x
	sudo apt install -y python3-pip
else
	echo "Already ready."
fi

# Install the necessary modules for python
echo "Installing necessary modules for python"
sudo pip3 install pandas pyyaml>=3.13 validators>=0.12 argparse

# If there is a error like this, 
#  File "/usr/bin/pip3", line 9, in <module> from pip import main
# you try to execute next command.
# sudo python3 -m pip uninstall pip && sudo apt-get install python3-pip --reinstall
