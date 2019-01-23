#!/bin/bash

# Title: SFA (School File Administration)
# Description: An administration tool to copy or delete files from any student's
#               home folder (their H:\ drive).

# Syntax:  copy $student_full_name - Copy $student_full_name's home folder to
#         your desktop.
#          delete $student_full_name - Delete $student_full_name's home folder.

# Make sure we're root
if [ "$EUID" -ne 0 ]; then
    echo "This script should be run as root. If you don't have root" \
          "you should follow this guide to get it:" \
          "https://apple.stackexchange.com/questions/164331/"
  exit
fi

year_dirs="2019", "2020", "2021", "2022", "2023"
# Mount //serverfs02
mkdir /Volumes/sf02
mount_smbfs //serverfs02 /Volumes/sf02

function main {
    for((;;)) {
        read -p "SFA> " cmd
        case $cmd in
            "copy"*)
                student_name="${cmd:5}"
                cmd="${cmd:0:4}"
                ;;
            "delete"*)
                student_name="${cmd:7}"
                cmd="${cmd:0:6}"
                ;;
            *)
                main
                ;;
        esac
        student_name="${student_name// /.}"
        for year_level in "$year_dirs"; do
            directory="/Volumes/sf02/${i}/${student_name}"
            if [ -d "${directory}"]; then
                if [ "${cmd}" -eq "delete"]; then
                    rm -R "${directory}/*"
                else
                    cp -R "${directory}" (~/)
                fi
            fi
        done
    }
}
