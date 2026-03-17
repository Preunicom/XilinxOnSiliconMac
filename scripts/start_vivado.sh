#!/bin/bash

# This script is run whenever the desktop environment has started or the desktop entry is clicked.
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
	if  [ -d "/home/user/Xilinx/Vivado" ]
	then
		# Vivado 2024 and older
		# Set environment variables to ensure vivado does not crash when syntezising and implementing a design
		export LD_PRELOAD="/lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libgdk-x11-2.0.so.0"
		/home/user/Xilinx/Vivado/*/bin/hw_server -e "set auto-open-servers     xilinx-xvc:host.docker.internal:2542" &
		/home/user/Xilinx/Vivado/*/settings64.sh
		/home/user/Xilinx/Vivado/*/bin/vivado
	else
		# Vivado 2025.1 and newer
		# Set environment variables to ensure vivado does not crash when syntezising and implementing a design
		export LD_PRELOAD="/lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libz.so.1"
		export QT_XCB_FORCE_SOFTWARE_OPENGL=1
		/home/user/Xilinx/*/Vivado/bin/hw_server -e "set auto-open-servers     xilinx-xvc:host.docker.internal:2542" &
		/home/user/Xilinx/*/Vivado/settings64.sh
		/home/user/Xilinx/*/Vivado/bin/vivado
	fi
	wait_for_user_input
else
	f_echo "The installation is incomplete."
	wait_for_user_input
fi
