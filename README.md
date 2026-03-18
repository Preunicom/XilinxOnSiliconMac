# XilinxOnSiliconMac

This is a tool for installing [Vivado™ and Vitis™](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html) on Arm®-based Apple Silicon Macs in a Rosetta-enabled virtual machine.
It is in no way associated with Xilinx or AMD.
This tool is based on [vivado-on-silicon-mac by ichi4096](https://github.com/ichi4096/vivado-on-silicon-mac).
Thanks for the great work!

The supported versions of Vivado are:
- 2023.2
- 2025.2

The above versions were tested on macOS 26.

## How to install

Expect the installation process to last about one to two hours and download ~35 GB for the web installer.

### Preparations

You first need to install [Docker®](https://www.docker.com/products/docker-desktop/) (make sure to choose "Apple Chip" instead of "Intel Chip").
You may find it useful to disable the option "Open Docker Dashboard when Docker Desktop starts".

Rosetta must be installed on your Mac.
The installer will ask you to install it if it is not already installed.

You will also need the Vivado installer file (the "Linux® Self Extracting Web Installer").
To download and install the Vivado installer (which also installs Vitis) you need an AMD account.

### Installation

1. Download or clone this repo.
2. Copy the Vivado installer into the repo root folder.
3. Open a terminal.
Then enter:
```
cd <repo>
caffeinate -dim zsh ./scripts/setup.sh
```
5. Follow the instructions (in yellow) from the terminal.

Note that the installation requires You to log into Your AMD account.
When asked to, allow "Terminal" to access data of other apps (the installation may succeed regardless).

### Usage

Run
```
<repo>/scripts/start_container.sh
```
inside the terminal.
The container can be stopped by pressing `Ctrl-C` inside the terminal or by logging out inside the container.

USB flashing support is limited, see the "USB Connection" paragraph below.

If you want to exchange files with the container, you need to store them inside the \<repo\> folder.
Inside Vivado, the files will be accessible via the "/home/user" folder.
Data not in "/home/user" or subdirectories are reset between restarts of the container.
I personally prefer creating the directory "/home/user/data" and store all my projects and data in there.

You can allocate more/less memory and CPU resources to for the Docker container by going to the Resources tab in the Docker settings.

### Notes

If the installation fails or Vivado crashes, consider:
- deleting the folder and go through the above steps again
- establishing a more reliable internet connection
- trying a different version of Vivado
- increasing RAM / Swap / CPU allocations in the Docker settings.

You may download via `git` instead of downloading the ZIP file and/or modify the scripts.
The installation is wholly contained in the repository folder, which is exposed in the Docker container as the `/home/user` folder.

Installation on external storage media may work but can cause issues, such as a file system (like FAT32, exFAT, NTFS) that does not support UNIX file permissions.

### Known Bugs

#### Vitis launch button in Vivado

Vitis can not be launched through Vivado.
Vivado needs preloaded libraries but Vitis crashes with them.
When Vivado starts Vitis the preloaded libraries are still preloaded as Vitis starts in the same environment as Vivado.
It therefore crashes silently and does not open.
To start Vitis use the desktop entry or the start_vitis.sh script.
This starts a new terminal with a clean environment without preloaded libraries.

## Installing other software

If you want to use additional Ubuntu packages, specify them in the Dockerfile.
If you want to install further AMD / Xilinx software, you can do so by copying the corresponding installer into the folder containing the Vivado installation and launching it via the GUI.  
__Attention!__ You must install it below the folder `/home/user` because any data outside of `/home/user` does not persist between VM reboots.
You can even skip installing Vivado entirely by commenting out the last line of `setup.sh`.

## How it works

### Docker, Rosetta & VNC

This collection of scripts creates an x64 Docker container running Linux® that is accelerated by [Rosetta 2](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment) via the Apple Virtualization framework.
The container has all the necessary libraries preinstalled for running Vivado and Vitis.
It is installed automatically given an installer file that the user must provide.
GUI functionality is provided via VNC and the built-in "Screen Sharing" app.

### USB connection

A drawback of the Apple Virtualization framework is that there is no implementation for USB forwarding as of when I'm writing this.
Therefore, these scripts set up the [Xilinx Virtual Cable protocol](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/644579329/Xilinx+Virtual+Cable).
Intended to let a computer connect to an FPGA plugged into a remote computer, it allows for the host system to run an XVC server (in this case a software called [xvcd](https://github.com/tmbinc/xvcd) by Felix Domke), to which the docker container can connect.

xvcd is contained in this repository, but with slight changes to make it compile on modern day macOS (compilation requires libusb and libftdi installed via homebrew, though there is a compiled version included).
It runs continuously while the docker container is running.

This version of xvcd only supports the FT2232C chip.
There are forks of this software supporting other boards such as [xvcserver by Xilinx](https://github.com/Xilinx/XilinxVirtualCable).

## Files overview

### Important files for the user

- `setup.sh`: Setup file, to be run once in the beginning
- `start_container.sh`: Starts the container and "Screen Sharing" session
- `cleanup.sh`: Removes Vivado and dotfiles.

### Other files

- `header.sh`: Common shell functions
- `configure_docker.sh`: Prompts the user to set necessary Docker settings
- `Dockerfile`: The Dockerfile for the container.
- `gen_image.sh`: Generates the Docker image to be used according to the Dockerfile
- `hashes.sh`: Contains the hashes of installer files and associated Vivado versions
- `linux_start.sh`: Docker container start script
- `install_configs`: Installation configuration files for all supported Vivado versions.
- `start_vivado.sh`: Script to start Vivado.
- `start_vivado.desktop`: Desktop entry to start the Vivado start script.
- `start_vitis.sh`: Script to start Vitis.
- `start_vitis.desktop`: Desktop entry to start the Vitis start script.
- `start_docnav.sh`: Script to start DocNav.
- `start_docnav.desktop`: Desktop entry to start the DocNav start script.
- `xvcd`: [xvcd](https://github.com/tmbinc/xvcd) source and binary copy
- `install_bin`: Full path to Vivado installation binary
- `vnc_resolution`: Manually adjustable resolution of the container GUI, formatted like "widthxheight"
- `vncpasswd`: Password for the VNC connection.
It is purposefully weak, as it serves no security function.
The VNC server inside the container will not allow outside connections.
The password can be changed manually nonetheless.

## License, copyright and trademark information

The repository's contents are licensed under the Creative Commons Zero v1.0 Universal license.

Note that the scripts are configured such that you automatically agree to Xilinx' and 3rd party EULAs (which can be obtained by extracting the installer yourself) by running them.
You also automatically agree to [Apple's software license agreement](https://www.apple.com/legal/sla/) for Rosetta 2.

This repository contains the modified source code of [xvcd](https://github.com/tmbinc/xvcd) as well as a compiled version which is statically linked against [libusb](https://libusb.info/) and [libftdi](https://www.intra2net.com/en/developer/libftdi/).
This is in accordance to the [LGPL Version 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html), under which both of those libraries are licensed.

Vivado and Xilinx are trademarks of Xilinx, Inc.

Arm is a registered trademark of Arm Limited (or its subsidiaries) in the US and/or elsewhere.

Apple, Mac, MacBook, MacBook Air, macOS and Rosetta are trademarks of Apple Inc., registered in the U.S. and other countries and regions.

Docker and the Docker logo are trademarks or registered trademarks of Docker, Inc. in the United States and/or other countries. Docker, Inc. and other parties may also have trademark rights in other terms used herein.

Intel and the Intel logo are trademarks of Intel Corporation or its subsidiaries.

Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries.

Oracle, Java, MySQL, and NetSuite are registered trademarks of Oracle and/or its affiliates.
Other names may be trademarks of their respective owners.

X Window System is a trademark of the Massachusetts Institute of Technology.
