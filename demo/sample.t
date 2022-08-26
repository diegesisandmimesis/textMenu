#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" that illustrates the
// functionality of the textMenu library
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

versionInfo:    GameID
        name = 'textMenu Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the textMenu library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is a simple test game that demonstrates the features
		of the textMenu library.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;

// No game world, we never get past the startup menu

// The startup menu object
mainMenu:	TextMenu
	// The default menu prompt is a single ">".  We change this to
	// two of them just to illustrate that we can.
	menuPrompt = '&gt;&gt;'

	// This is the menu text.  It's just printed as a literal before
	// handling player input.
	menuText = "<br><b>textMenu Test</b><br><br>
		<b>ABOUT</b> for information about this game<br>
		<b>FOO</b> for some filler text<br>
		<b>BAR</b> for an inline function<br>
		<b>QUIT</b> to exit<br><br><br> "

	// This is the trickiest bit.  Here we map input strings to
	// handlers--functions/methods that we'll call if the player
	// inputs the given string at the menu prompt.
	// Most of the time we just want to declare this in the form
	// of the first property in this example:
	//	'about' -> &aboutMethod,
	// This means that if the player inputs the string "about",
	// we'll call the method aboutMethod() on the menu object (this
	// object).
	// We can also use an inline function, as illustrated in the
	// third property ('bar') below.
	menuOptions = static [
		'about'	-> &aboutMethod,
		'foo'	-> &fooMethod,
		'bar'	-> function() {
			enterToContinue('Bar.\n ', true); returnToMenu();
		},
		'quit'	-> &quitMethod
	]

	// In our first example method we call someone else to display
	// some text (in this case versionInfo.showAbout() to show the
	// game's ABOUT text) and then call self.enterToContinue() to
	// prompt the player to hit enter to continue.
	// enterToContinue() just waits for the player to hit enter/return,
	// optionally displaying some text and/or a prompt first.  See
	// the next example for an alternate usage.
	// After pausing via enterToContinue() we display the menu again
	// by calling returnToMenu().
	// If we DON'T call returnToMenu() again, we'll end up returning
	// control to our caller (whatever place in the code decided to
	// show this menu in the first place), effectively exiting the
	// menu.
	aboutMethod() {
		versionInfo.showAbout();
		enterToContinue(nil, true);
		returnToMenu();
	}

	// In this case we're using enterToContinue() to display some
	// text (instead of calling an external method, as above).
	fooMethod() {
		enterToContinue('This is some "foo" text.\n ', true);
		returnToMenu();
	}

	// In this case we don't call returnToMenu() again, which means
	// we'll be exiting the menu.  Since in this example we're
	// called from gameMain.newGame(), we'll end up falling off
	// the end, which will end the game.  Which is fine, because
	// in this example there's no game to actually start.
	quitMethod() {
		"Quitting the game\n ";
	}
;

gameMain:       GameMainDef
	newGame() {
		mainMenu.showMenu();
	}
;
