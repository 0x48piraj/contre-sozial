# Contre Sozial
<p align="center">
    <img alt="Contre Sozial" src="https://raw.githubusercontent.com/0x48piraj/Contre-Sozial/www/assets/images/contre-sozial-banner.png"><br>
    <i>Breaking the doomscrolling cycle with Contre Sozial.</i>
</p>

### Description

Contre Sozial tries to eliminate the biggest problem in social media networks, that is, doomscrolling using the power of machine learning algorithms.

#### Stratagem
1. Record a series of scroll events.
2. Train a machine learning model to predict a set of the scroll event patterns.
3. Detect foreground running overlay activities simultaneously ([Current Activity - android-TopActivity](https://github.com/109021017/android-TopActivity))

### Problems in getting global touch events

- Putting a transparent layout which covers the phone screen and then receive the touch events and dynamically removing the glass so that the event could be passed to below the glass and then dynamically inserting the glass again. But the drawback was that it require two times tap which is not feasible (first tap would give the touch coordinates and second would be passed below).

- Using the flag `FLAG_WATCH_OUTSIDE_TOUCH` ([Monitor Screen Touch Event in Android](http://jhshi.me/2014/11/09/monitor-screen-touch-event-in-android/index.html)) but getting touch coordinates as (0,0) as the Android framework imposes security that no other process can get touch points inside other process.

- Running command `adb shell getevent -l` through code but it does not accepts touch events (although, using `adb shell sendevent` enables one to send global touch events.

- Using shell script with `getevent` command, writing the touch events to a file then parsing the touch events to get readable coordinates. **[Working]**

### References

- [How to use ADB to send touch events to device using sendevent command?](https://stackoverflow.com/questions/3437686/how-to-use-adb-to-send-touch-events-to-device-using-sendevent-command)
- [send touch events to a device via adb [duplicate]](https://stackoverflow.com/questions/4386449/send-touch-events-to-a-device-via-adb)
- [Automating Input Events on Android](https://www.rightpoint.com/rplabs/automating-input-events-abd-keyevent)
- [Is it possible to produce continuous swipe action on the touchscreen, with adb, on Android?](https://www.xspdf.com/resolution/50358620.html)
- [Year in a word: Doomscrolling](https://www.ft.com/content/797ff58c-ab23-4197-9938-2bce8be43ff7)
