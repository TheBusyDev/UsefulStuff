#!/bin/bash

# launch open-webui server
/home/pietro/.local/bin/open-webui serve &
webui_pid=$! # get process ID

# sleep 10

# open chromium tab
chromium-browser --app=http://localhost:8080

# kill open-webui one the chromium tab has been closed
kill -SIGINT $webui_pid
sleep 2

exit 0
