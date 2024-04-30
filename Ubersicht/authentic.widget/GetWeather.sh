#!/bin/bash

# Temperature and Weather condition
osascript authentic.coffee/GetWeather.applescript



temp=$(echo $data | awk "and" '{print $1}')
condition=$(echo $data | awk -F "and" '{print $3}')


#
