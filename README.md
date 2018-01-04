# mediaplayer_lag_ios-11.2_demo

## Issue

The Media Player framework on iOS 11.2 comes with massive drops in app performance, blocking the main thread for massive intervals at a time.

Below is a video demonstrating this project with two devices: one running iOS 11.2.1, the other running iOS 11.0.0.

https://www.youtube.com/watch?v=TlKdZIIoMu0

## Discovery

I am the developer of [Lignite Music](http://www.lignitemusic.com), a third-party music app for iOS/watchOS. 

Recently we noticed an influx of reports of immense lag within our app, despite us not making any signifigant changes to our app's codebase.

After investigating the issue, we found that the massive blocking was not our fault but instead was Apple's bug. 

## What this demo project does

0. It queues and plays your entire music library
1. It runs an NSTimer on the main thread which updates a label every 100 milliseconds, containing the current track's playback time

This demo project contains the exact code I have used to test this issue. 

## Expected result of the demo project

On devices running iOS 11.2, after playing music, there is a ~1s lag initially. The label will quickly update, only to be faced by another hang, which in my tests can last from anywhere between 4 and 12 seconds.

When pausing app execution to see what exactly is causing the hanging, one should get an indistinct trace beginning with `mach_msg_trap`.

# [![Hang stack trace](https://raw.githubusercontent.com/edwinfinch/mediaplayer_lag_ios-11.2_demo/master/stacktrace.png)](#)

The line which is viewable within the project, as you may notice in that stack trace, leads to the `updateLagTestLabelText` function where the label is updated. This has nothing to do with the lag, so this "clue" is more of a red herring than anything.

I have tested this on two other devices, one running iOS 11.0 and one running iOS 9.3.5, both of which the hangs I have described above do not occur whatsoever.
