#!/bin/bash

# This script is run whenever the desktop entry is clicked.
# (with normal user privileges).

script_dir="/home/user/scripts"
source "$script_dir/header.sh"
validate_linux

# Change working directory to a writable folder to allow Vivado to write its logs.
cd /home/user/XilinxLogs

# if Vivado is installed
if [ -d "/home/user/Xilinx" ]
then
	# Make Vivado connect to the xvcd server running on macOS (the version number can be above and below the Vivado folder level depending on the Vivado version)
	if  [ -d "/home/user/Xilinx/Vitis" ]
	then
		source /home/user/Xilinx/Vitis/*/settings64.sh
	else
		source /home/user/Xilinx/*/Vitis/settings64.sh
	fi
	exec bash
else
	f_echo "The installation is incomplete."
	wait_for_user_input
fi
