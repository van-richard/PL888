#!/bin/bash
# Run r
#https://alvinalexander.com/mac-os-x/mac-osx-startup-crontab-launchd-jobs/

log_file="/tmp/ubersicht.out"

date > ${log_file}

/Applications/Übersicht.app/Contents/MacOS/Übersicht

exec 1>${log_file} 2>&1


