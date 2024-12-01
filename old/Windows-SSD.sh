#!/bin/bash
#this mounts Windows-SSD disk without showing any notifications

udisksctl mount -b /dev/nvme0n1p3
sleep 0.3
dolphin /home/pietro/Documents/Windows-SSD/Windows-Folders/

exit 0
