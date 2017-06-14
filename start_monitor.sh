#!/bin/bash

# Absolute path to this script
SCRIPT=$(realpath $0)
SCRIPTPATH=`dirname $SCRIPT`

xterm -maximized -vb -e $SCRIPTPATH/display_status.sh
