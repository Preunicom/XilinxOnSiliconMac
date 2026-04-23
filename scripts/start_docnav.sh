#!/bin/bash

# This script is run whenever the desktop environment has started or the desktop entry is clicked.
# (with normal user privileges).

script_dir="/home/user/scripts"
source "$script_dir/header.sh"
validate_linux

# Change working directory to a writable folder.
cd /home/user/XilinxLogs

# if Vivado is installed
if [ -d "/home/user/Xilinx" ]
then
	/home/user/Xilinx/DocNav/docnav
	f_echo "DocNav opened! Do not close this window!"
    f_echo "PRess enter to close this window."
	read
else
	f_echo "The installation is incomplete."
	wait_for_user_input
fi
