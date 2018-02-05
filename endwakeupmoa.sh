#!/bin/bash

kill $(ps aux | grep '[w]akeupmoa.sh' | awk '{print $2}')

exit 1