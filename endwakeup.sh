#!/bin/bash

kill $(ps aux | grep '[w]akeup.sh' | awk '{print $2}')

exit 1