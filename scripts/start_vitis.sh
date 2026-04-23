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
		/home/user/Xilinx/Vitis/*/bin/hw_server -e "set auto-open-servers     xilinx-xvc:host.docker.internal:2542" &
		source /home/user/Xilinx/Vitis/*/settings64.sh
		vitis
	else
		/home/user/Xilinx/*/Vitis/bin/hw_server -e "set auto-open-servers     xilinx-xvc:host.docker.internal:2542" &
		source /home/user/Xilinx/*/Vitis/settings64.sh
		vitis
	fi
	f_echo "Vitis opened! Do not close this window!"
	f_echo "Press enter to close this window."
	read
else
	f_echo "The installation is incomplete."
	wait_for_user_input
fi
