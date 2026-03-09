#!/bin/zsh

# starts the Docker container and xvcd for USB forwarding

script_dir=$(dirname -- "$(readlink -nf $0)";)
source "$script_dir/header.sh"
validate_macos

# Delete the pcmanfm socket if it wasn't deleted after the last session so the desktop will show
if [[ -f "$script_dir/../.cache/pcmanfm-socket--1" ]]; then
    rm "$script_dir/../.cache/pcmanfm-socket--1"
fi

# this is called when the container stops or ctrl+c is hit
function stop_container {
    docker kill xilinx_container > /dev/null 2>&1
    f_echo "Stopped Docker container"
    killall xvcd > /dev/null 2>&1
    f_echo "Stopped xvcd"
    exit 0
}
trap 'stop_container' INT

# Make sure everything is setup to run the container
start_docker
if [[ $(docker ps) == *xilinx_container* ]]
then
    f_echo "There is already an instance of the container running."
    exit 1
fi
killall xvcd > /dev/null 2>&1

# run container
docker run --init --rm --name xilinx_container --mount type=bind,source="$script_dir/..",target="/home/user" -p 127.0.0.1:5901:5901 --platform linux/amd64 xilinx-x64 sudo -H -u user bash /home/user/scripts/linux_start.sh &
f_echo "Started container"
sleep 7
f_echo "Starting VNC viewer"
vncpass=$( tr -d "\n\r\t " < "$script_dir/vncpasswd" )
osascript -e "tell application \"Screen Sharing\" to GetURL \"vnc://user:$vncpass@localhost:5901\""
f_echo "Running xvcd for USB forwarding..."
# while xilinx_container is running
while [[ $(docker ps) == *xilinx_container* ]]
do
    # if there is a running instance of xvcd
    if pgrep -x "xvcd" > /dev/null
    then
        :
    else
        eval "$script_dir/xvcd/bin/xvcd > /dev/null 2>&1 &"
        sleep 2
    fi
done
stop_container
