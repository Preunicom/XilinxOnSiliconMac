#!/bin/bash

# This script is run whenever the desktop environment has started.
# (with normal user privileges).

script_dir="/home/user/scripts"
source "$script_dir/header.sh"
validate_linux

# Change working directory to a writable folder to allow Vivado to write its logs.
cd /home/user/XilinxLogs

export LD_PRELOAD="/lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libz.so.1"

# if Vivado is installed
if [ -d "/home/user/Xilinx" ]
then
	# Make Vivado connect to the xvcd server running on macOS (the version number can be above and below the Vivado folder level depending on the Vivado version)
	if  [ -d "/home/user/Xilinx/Vitis" ]
	then
		source /home/user/Xilinx/Vitis/*/settings64.sh
		vitis
	else
		source /home/user/Xilinx/*/Vitis/settings64.sh
		vitis
	fi
	f_echo "Vitis opened! Do not close this window!"
	wait_for_user_input
else
	f_echo "The installation is incomplete."
	wait_for_user_input
fi
