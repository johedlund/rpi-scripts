#!/bin/bash

kill $(ps aux | grep '[w]akeupoliver.sh' | awk '{print $2}')

exit 1