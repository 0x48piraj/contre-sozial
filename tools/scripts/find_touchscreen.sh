#!/bin/bash

for line in `adb shell getevent -lp 2>/dev/null | egrep -o "(/dev/input/event\S+)"`; do # read the info of each of the input devices
  echo $line
  output=`adb shell getevent -lp $line`
  # The touchscreen device contains the keyword ABS_MT in its info
  [[ "$output" == *"ABS_MT"* ]] && { echo "Touch device found! -> $line"; exit; }
done
echo "Touch device not found!"