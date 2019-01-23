#!/bin/bash

# Make sure we're root
if [ "$EUID" -ne 0 ]
  then echo "This script should be run as root. If you don't have root" \
          "you should follow this guide to get it:" \
          "https://apple.stackexchange.com/questions/164331/"
  exit
fi

# Functions and variables for later use
function echo_title {
  echo "==================="
  echo "$1"
  echo "==================="
}

function as_user {
  sudo -u "$SUDO_USER" "$1"
}

read -d "" uberbloc << EOF
.--.--.__                __     __
|--|--|  |--.-----.----.|  |--.|  |.-----.----.
|  |  |  _  |  -__|   _||  _  ||  ||  _  |  __|
|_____|_____|_____|__|  |_____||__||_____|____|


EOF
# Main functions
function menu {
  for((;;)) {
    clear
    echo "$uberbloc " # This... fixes format highlighting?
    echo ""
    echo "{0} - Exit"
    echo "{1} - Install Homebrew and Software"
    echo "{2} - Meraki submenu"
    echo "{3} - Change MAC"
    echo ""
    read -p "Enter choice: " choice
    case "$choice" in
      0)
        echo Exiting
        exit 0
        ;;
      1)
        install_software
        ;;
      2)
        meraki_submenu
        ;;
      3)
        change_mac
        ;;
      *)
        echo Invalid choice.
        ;;
    esac
  }
}

function install_software {
  echo_title "Installing Homebrew and Software"
  echo "Installing Homebrew"
  as_user "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
  echo "Installing Noah"
  as_user "brew install linux-noah/noah/noah"
  echo "Installing nVim"
  as_user "brew install nvim"
}

function meraki_submenu {
  clear
  for((;;)) {
    echo "{0} - Exit"
    echo "{1} - Detect meraki files"
    read -p "Enter choice: " choice
    case "$choice" in
      0)
        break
        ;;
      1)
        find / | grep meraki
        ;;
      *)
        echo Invalid choice.
        ;;
    esac
  }
}

function change_mac {
  clear
  echo "Warning, this will temporarily disconnect you from the internet."
  echo "Waiting 5 seconds. \(Ctrl+C to cancel\)"
  interface="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"
  ifc="$(echo -e "$(ifconfig $interface | grep ether)" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  ifc="${ifc#$ether}"
  echo "$ifc" >> old_mac
  sleep 5
  echo "Created a file called old_mac containing your old MAC address, you may" \
        "need this."
  new_mac="$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')"
  echo "Setting your new MAC address ($new_mac)"
  # Here we go bois
  ifconfig ${interface} ${new_mac}
  new_mac=$(echo -e "$(ifconfig $interface | grep ether)" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  if [ ${new_mac} = ${old_mac} ]
  then
    echo "Both your old and new MAC address are the same, this may be the result" \
        "of either a very unlikely coincidence, or a sign something has gone wrong."
  else
    echo "Your MAC address is now being spoofed."
  fi
}

menu
