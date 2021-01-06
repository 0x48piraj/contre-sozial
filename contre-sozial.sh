#!/bin/bash

while true; do
 if [[ `dumpsys activity activities | grep mResumedActivity | grep -e com.instagram.android -e com.linkedin.android -e com.twitter.android` ]]; then
  # getevent -l | grep --line-buffered ^/ | tee /tmp/android-touch-events.log
  # subroutine for detecting swipe gestures
 else
  echo "Sozials are not running."
 fi
done