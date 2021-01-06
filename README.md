# Contre Sozial
<p align="center">
    <img alt="Contre Sozial" src="https://raw.githubusercontent.com/0x48piraj/Contre-Sozial/www/assets/images/contre-sozial-banner.png"><br>
    <i>Breaking the doomscrolling cycle with Contre Sozial.</i>
</p>

### Description

Contre Sozial tries to eliminate the biggest problem in social media networks, that is, doomscrolling using the power of machine learning algorithms.

#### Stratagem

##### Training
1. Record a series of touch events.
2. Identify and record scroll events using (position,velocity) data-points. 
3. Train a machine learning model to predict doomscroll patterns.

##### Testing
1. Detect foreground running overlay activities to trigger the main activity ([Current Activity - android-TopActivity](https://github.com/109021017/android-TopActivity))
2. Record a series of touch events. 
3. Detect scroll events using (position,velocity) data-points.

> Detecting the foreground running overlay activities simultaneously to trigger the main activity which observes touch events in real-time using the trained model provides precise doomscrolling duration.

### Internal input event handling in the Linux kernel and the Android userspace

<p align="center">
    <img alt="Event propagation flow on Android" src="https://raw.githubusercontent.com/0x48piraj/Contre-Sozial/www/assets/event-propagation-flow-on-android.png"><br>
    <i>Event propagation flow on Android</i>
</p>

### Problems in getting global touch events

- Putting a transparent layout which covers the phone screen and then receive the touch events and dynamically removing the glass so that the event could be passed to below the glass and then dynamically inserting the glass again. But the drawback was that it require two times tap which is not feasible (first tap would give the touch coordinates and second would be passed below).

- Using the flag `FLAG_WATCH_OUTSIDE_TOUCH` ([Monitor Screen Touch Event in Android](http://jhshi.me/2014/11/09/monitor-screen-touch-event-in-android/index.html)) but getting touch coordinates as (0,0) as the Android framework imposes security that no other process can get touch points inside other process.

- Running the `getevent` command natively through code requires `su`. On a different note, using `sendevent` enables one to send global touch events.

#### Gist

Using shell script with `getevent`, writing the touch events to a file then parsing the touch events to get readable coordinates. Using [ADB over TCP](https://stackoverflow.com/questions/2604727/how-can-i-connect-to-android-with-adb-over-tcp) for connection.

With that said, if the application finds a rooted host then it's possible to directly listen to incoming lines from `getevent`.

### Nitty-gritty

The `getevent` tool runs on the device and provides information about input devices and a live dump of kernel input events. The following command can be used to get the live events &mdash;

```
adb shell getevent
```

The following logcat of executing `getevent` command from **Helio G95 Android Q** shows a swipe gesture for a touchscreen using the Linux input protocol. The `-l` option displays textual descriptive labels.

```
<...>
/dev/input/event2: EV_ABS       ABS_MT_TRACKING_ID   0000119b
/dev/input/event2: EV_KEY       BTN_TOUCH            DOWN
/dev/input/event2: EV_ABS       ABS_MT_TOUCH_MAJOR   0000000b
/dev/input/event2: EV_ABS       ABS_MT_PRESSURE      0000000b
/dev/input/event2: EV_ABS       ABS_MT_POSITION_X    0000034b
/dev/input/event2: EV_ABS       ABS_MT_POSITION_Y    000006c9
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_TOUCH_MAJOR   0000000c
/dev/input/event2: EV_ABS       ABS_MT_PRESSURE      0000000c
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_TOUCH_MAJOR   0000000d
/dev/input/event2: EV_ABS       ABS_MT_PRESSURE      0000000d
/dev/input/event2: EV_ABS       ABS_MT_POSITION_X    00000341
/dev/input/event2: EV_ABS       ABS_MT_POSITION_Y    000006ab
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_TOUCH_MAJOR   0000000c
/dev/input/event2: EV_ABS       ABS_MT_PRESSURE      0000000c
/dev/input/event2: EV_ABS       ABS_MT_POSITION_X    00000325
/dev/input/event2: EV_ABS       ABS_MT_POSITION_Y    00000654
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_POSITION_X    00000307
/dev/input/event2: EV_ABS       ABS_MT_POSITION_Y    000005e9
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_TOUCH_MAJOR   00000005
/dev/input/event2: EV_ABS       ABS_MT_PRESSURE      0000000a
/dev/input/event2: EV_ABS       ABS_MT_POSITION_X    000002f9
/dev/input/event2: EV_ABS       ABS_MT_POSITION_Y    0000057d
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_PRESSURE      00000001
/dev/input/event2: EV_ABS       ABS_MT_POSITION_X    000002e7
/dev/input/event2: EV_ABS       ABS_MT_POSITION_Y    000004df
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
/dev/input/event2: EV_ABS       ABS_MT_TRACKING_ID   ffffffff
/dev/input/event2: EV_KEY       BTN_TOUCH            UP
/dev/input/event2: EV_SYN       SYN_REPORT           00000000
^C
```

Where each line represents an event's `device type code value`. `BTN_TOUCH DOWN` and `BTN_TOUCH UP` indicate the beginning and the end of the touch, `ABS_MT_POSITION_X` and `ABS_MT_POSITION_Y` represent the touch’s x and y positions. To put it in perspective, a simple touchscreen press-release event generates around 19 input events.

Using the `-t` option we can also record the timestamps. The touch data is in the following output format &mdash;

**Timestamp**|**Device**|**Type**|**Code**|**Value**
:-----:|:-----:|:-----:|:-----:|:-----:
[   97610.867783]|/dev/input/event2|0003|0039|00001569
[   97610.867783]|/dev/input/event2|0001|014a|00000001
[   97610.867783]|/dev/input/event2|0003|0032|0000000b
[   97610.867783]|/dev/input/event2|0003|0030|0000000b
...|...|...|...|...
[   97610.995255]|/dev/input/event2|0003|0036|00000515
[   97610.995255]|/dev/input/event2|0000|0000|00000000
[   97611.004105]|/dev/input/event2|0003|0039|ffffffff
[   97611.004105]|/dev/input/event2|0001|014a|00000000
[   97611.004105]|/dev/input/event2|0000|0000|00000000

**NOTE:** `getevent` timestamps use the format **$SECONDS.$MICROSECONDS** in the `CLOCK_MONOTONIC` timebase. This data-format is not ideal as it is **relative** to an arbitrary time in the system.

For a complete list of the applicable events’ types and codes, refer to **linux/input.h**<sup>[1](https://android.googlesource.com/kernel/msm.git/+/android-msm-hammerhead-3.4-kk-r1/include/linux/input.h)</sup>.

##### Record

Recording a series of events in a file (`/tmp/touch-events.log`) &mdash;

```
$ adb shell getevent | grep --line-buffered ^/ | tee /tmp/touch-events.log
```

#### Pseudocode

```bash
while true; do
 if [[ `dumpsys activity activities | grep mResumedActivity | grep -e com.instagram.android -e com.linkedin.android -e com.twitter.android` ]]; then
  getevent -l | grep --line-buffered ^/ | tee /tmp/android-touch-events.log
  # subroutine for detecting swipe gestures
 else
  echo "Sozials are not running."
 fi
done
```

### References

- [Touch Devices - Android Open Source Project](https://source.android.com/devices/input/touch-devices)
- [Getevent - Android Open Source Project](https://source.android.com/devices/input/getevent)
- [linux - Difference between CLOCK_REALTIME and CLOCK_MONOTONIC? - Stack Overflow](https://stackoverflow.com/questions/3523442/difference-between-clock-realtime-and-clock-monotonic)
- [include/linux/input.h - kernel/msm.git - Git at Google](https://android.googlesource.com/kernel/msm.git/+/android-msm-hammerhead-3.4-kk-r1/include/linux/input.h)
- [android - ADB Shell Input Events - Stack Overflow](https://stackoverflow.com/questions/7789826/adb-shell-input-events/8483797#8483797)
- [Android - Inactivity/Activity regardless of top app - Stack Overflow](https://stackoverflow.com/questions/18882331/android-inactivity-activity-regardless-of-top-app)
- [dumpsys - Android Developers](https://developer.android.com/studio/command-line/dumpsys)
- [Year in a word: Doomscrolling](https://www.ft.com/content/797ff58c-ab23-4197-9938-2bce8be43ff7)
