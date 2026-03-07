#!/bin/bash

# This script is run whenever the desktop environment has started.
# (with normal user privileges).

script_dir=$(dirname -- "$(readlink -nf $0)";)
source "$script_dir/header.sh"
validate_linux

# Change working directory to a writable folder to allow Vivado to write its logs.
cd /home/user/VivadoLogs

export LD_PRELOAD="/lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libgdk-x11-2.0.so.0"

# if Vivado is installed
if [ -d "/home/user/Xilinx" ]
then
	# Make Vivado connect to the xvcd server running on macOS (the version number can be above and below the Vivado folder level depending on the Vivado version)
	if  [ -d "/home/user/Xilinx/Vivado" ]
	then
		/home/user/Xilinx/Vivado/*/bin/hw_server -e "set auto-open-servers     xilinx-xvc:host.docker.internal:2542" &
		/home/user/Xilinx/Vivado/*/settings64.sh
		/home/user/Xilinx/Vivado/*/bin/vivado
	else
		/home/user/Xilinx/*/Vivado/bin/hw_server -e "set auto-open-servers     xilinx-xvc:host.docker.internal:2542" &
		/home/user/Xilinx/*/Vivado/settings64.sh
		/home/user/Xilinx/*/Vivado/bin/vivado
	fi
else
	f_echo "The installation is incomplete."
	wait_for_user_input
fi
