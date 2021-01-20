#!/bin/bash

while true; do
 if [[ `dumpsys activity activities | grep mResumedActivity | grep -e com.instagram.android -e com.linkedin.android -e com.twitter.android` ]]; then
  $(getevent -l | grep --line-buffered ^/ | tee /mnt/sdcard/android-touch-events.log > /dev/null 2>&1 &) # start recording touch-data in background
 else
   if [[ `ps | grep getevent` ]]; then
        pkill -f getevent
        # routine for detecting swipe gestures from logcat
        RESULT=$(cat /mnt/sdcard/android-touch-events.log | grep BTN_TOUCH -n | cut -d\: -f1 | sed '$!N;s/\n/ /')
        echo "$RESULT" | while read line 
        do
            DOP=`echo "$line" | tr " " ,` # DOWN <-> UP
            if [[ `sed "$DOP!d" /mnt/sdcard/android-touch-events.log | grep ABS_MT_POSITION_X -c` -gt 2 ]]; then # if X > 2 || Y > 2: swipe
                echo "Swipe!"
            else
                echo "No Swipe"
            fi
        done
        # creating activity logfile
        # rm /mnt/sdcard/android-touch-events.log # deleting getevent logcat
   fi
 fi
done


# ---

$(getevent -l | grep --line-buffered ^/ | tee /mnt/sdcard/android-touch-events.log > /dev/null 2>&1 &) # start recording touch-data in background
while true; do
   if [[ `dumpsys activity activities | grep mResumedActivity | grep -e com.instagram.android -e com.linkedin.android -e com.twitter.android` ]]; then
        RESULT=$(cat /mnt/sdcard/android-touch-events.log | grep BTN_TOUCH -n | cut -d\: -f1 | sed '$!N;s/\n/ /')
        echo "$RESULT" | while read line 
        do
            DOP=`echo "$line" | tr " " ,` # DOWN <-> UP
            if [[ `sed "$DOP!d" /mnt/sdcard/android-touch-events.log | grep ABS_MT_POSITION_X -c` -gt 2 ]]; then # if X > 2 || Y > 2: swipe
                echo "Swipe!"
            else
                echo "No Swipe"
            fi
        done
   fi
done


# ---

$(getevent -l | grep --line-buffered ^/ | tee /mnt/sdcard/android-touch-events.log > /dev/null 2>&1 &) # start recording touch-data in background
while [[ `dumpsys activity activities | grep mResumedActivity | grep -e com.instagram.android -e com.linkedin.android -e com.twitter.android` ]]; do
    RESULT=$(cat /mnt/sdcard/android-touch-events.log | grep BTN_TOUCH -n | cut -d\: -f1 | sed '$!N;s/\n/ /')
    echo "$RESULT" | while read line 
    do
        DOP=`echo "$line" | tr " " ,` # DOWN <-> UP
        if [[ `sed "$DOP!d" /mnt/sdcard/android-touch-events.log | grep ABS_MT_POSITION_X -c` -gt 2 ]]; then # if X > 2 || Y > 2: swipe
            echo "Swipe!"
        else
            echo "No Swipe"
        fi
    done
done