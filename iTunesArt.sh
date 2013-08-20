#!/bin/bash
osascript -e '
set thefile to ((path to pictures folder as string) & "longo_mom_l.jpg") as alias

on appIsRunning(appName)
    tell application "System Events" to (name of processes) contains appName
end appIsRunning

try

    tell application "System Events"
        set theDesktops to a reference to every desktop
        if not (item 2 of theDesktops exists) then
            return
        end if
    end tell
    if(appIsRunning("iTunes")) then
        tell application "iTunes"
            if(artwork 1 of current track exists) then
                set timeStr to minutes of (current date)
                set tf to ((path to pictures folder as string) & "artwork" & timeStr & ".png")
                do shell script "touch  " & quoted form of (posix path of tf)
                set thefile to tf as alias
                set thefilehandle to open for access thefile with write permission
                write (get raw data of artwork 1 of current track) to thefilehandle starting at 0
                close access thefilehandle
                do shell script "/usr/local/bin/convert " & (quoted form of (posix path of tf)) & " -background black -geometry 1080x1080 -gravity northwest -extent 1920x1080 " & (quoted form of (posix path of tf))
            end if
        end tell
    end if
    tell application "System Events"
        set theDesktops to a reference to every desktop
        set picture of item 2 of theDesktops to thefile
    end tell
end try';
