#!/bin/zsh

# Attempts to configure Docker by enabling Rosetta and increasing swap

script_dir=$(dirname -- "$(readlink -nf $0)";)
source "$script_dir/header.sh"
validate_macos

stop_docker

f_echo "Please configure following settings in Docker manually:"
f_echo ""
f_echo "1) General --> Virtual Machien Options --> Choose Virtual Machine Manager (VMM) --> Apple Virtualization Framework (useVirtualizationFramework: true)"
f_echo ""
f_echo "2) General --> Virtual Machien Options --> Choose Virtual Machine Manager (VMM) --> Use Rosetta for x86_64/amd64 emulation on Apple Silicon (useVirtualizationFrameworkRosetta: true)"
f_echo ""
f_echo "3) Ressources --> Ressource Allocation --> Swap --> >= 4 GB (swapMiB: 4096)"
f_echo ""
wait_for_user_input