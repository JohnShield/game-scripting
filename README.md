# game-scripting
This project is just a hobby project to automate playing web games.

Basic Description:
The script provides a way to autoclick on detection of color on your screen.
This is useful for autoclicking in web games, where you need to click
various icons or buttons in various sequences to progress in the game.
The script was designed to play a game automatically in a corner 
of your screen while you're watching movies, reading websites, or just 
working on things.

Requires:
It uses autohotkey, which is mouse and keyboard control software that runs scripts on your computer. 

Development Level:
Still a bit rough as many of the advanced features require editing the script. 
Without editing/understanding the code, it allows automatic button pushing in 
game, while allowing the computer to be easily used to browse the internet.

At some point it would be good to provide extra user interface, so that all the
functionality can be used without looking at or editing the script.

Quickstart:
1. Install autohotkey off the official website
2. Run the script "Game Scripting.ahk" by double clicking
3. Check script is running by seeing a little info bubble with roughly 
        "Run: Idle:3000 (mouse x,mouse y) Click Locations:"
4. Arrange the game window to the sizing and location on your screen where
   you can comfortably let it run automatically. 
        Eg. Leave the game full screen if you don't want to multi-task. 
        Otherwise have the game in a corner of your screen.
5. Move your mouse over the first button, press F4. 
        You should see a new line appear showing a click trigger. The
        information is: mouse X, mouse Y, expected pixel color, current pixel
        color, (allowable difference, only settable by editing the script), the
        color difference OR "true" when there is a match.
6. Check that the new click trigger is "true" for the button you want 
   automatically clicked. 
        The trigger is based on color and location. If you're not seeing "true",
        it may be because the button changes color when your mouse is over it.
        You can check to see if your trigger becomes true when you hover your 
        mouse is over the button. If that's the case, then move your mouse away.
        Press F3 and select "Color Trigger: re-add with current color". 
        This readds the last trigger with the current color.
7. Press F2 to toggle the auto-clicking on and off. F1 will always turn the
   auto-clicking off.
8. While the script is running you can add more triggers by pressing F4. 
        Note that the script detects user activity and does not click if you 
        have typed or moved the mouse in the last few seconds. This allows you
        to browse websites or do other other things while letting the script 
        play the game for you.

Advanced Instructions:
* You can save the triggers you have created by opening up the script file and 
  then pressing F3, then select "Color Trigger: typeout". This will paste all 
  your current triggers into the script. It is recommended to paste at the 
  start of the file, otherwise you may paste inside a function.
* You can modify the triggers you have pasted to have leeway on the color. This
  is useful because the color of the button or hotspot may change slightly in 
  the game. The color triggers show the differences between expected color and
  current color, and you can replace the 0x0 (last value in the saved trigger)
  with the allowable color variances. There are 3 color values for red green 
  blue. Google "hex color code" for more info.
* The triggers uses x and y coordinates. For webgames, the browser window may
  move causing all your triggers to be in the wrong locations. That's why 
  there's the "WinMove Zero" option in the F3 menu. This moves the browser 
  window to a fixed location that corresponds with your saved triggers. The 
  x and y defaults can be changed within the script file, look for the 
  "WinMoveZero()" function and edit the coordinates.
* If you're okay at autohotkey scripting, you may want to do custom operations
  on a trigger. For example, if you want to add delays, display things, auto
  type, or click in a different location. Look in the script for the 
  "doEvent(x, y, index)", it's currently turned off, but if you change the
  conditional on the index you can use it to run the "customEvent" functions.

