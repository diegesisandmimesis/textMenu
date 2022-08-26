
textMenu
Version 1.0
Copyright 2022 Diegesis & Mimesis, distributed under the MIT License



ABOUT THIS LIBRARY

This is a module for implementing simple "multiple choice" text menus
in TADS3.  This is designed for, for example, option menus to be displayed
when the game is started.



USAGE

In general you'll want to declare the menu as an instance of the TextMenu
class and include all of the menu configuration in the declaration:

	myMenu: TextMenu
		menuText = "<br><b>Menu Title</b><br><br>
			<b>FOO</b> is the only option</br>
			<b>QUIT</b> to exit<br><br><br> "

		menuOptions = static [
			'foo' -> &handleFoo,
			'quit' -> &handleQuit
		]

		handleFoo() {
			enterToContinue('This is placeholder text\n ', true);
			showMenu();
		}
		handleQuit() {
			// This space intentionally left blank
		}
	;

You can then display/run the menu via

	myMenu.showMenu();

This will display the menu text (defined in myMenu.menuText) and then
prompt the player for input.  This is case, that will look something like:

	Menu Title

	FOO is the only option
	QUIT to exit


	>

If the player enters (in this example) "foo" (or any substring that matches
the start of "foo"...so "f" or "fo") the method myMenu.handleFoo() will be
called (displaying the text "This is placeholder text" and then prompting the
player to hit enter to continue) and then the menu will be displayed and it
will wait for input again.

If the player enters any non-matching string, the menu will display the
menu text again and then wait for another input.

If the player enters "quit" (in this example) myMenu.handleQuit() will be
called, and then control will be returned to whereever myMenu.showMenu()
was originally called from.


A more complete and fully-commented example can be found in demo/sample.t.

LIBRARY CONTENTS

The files in the library are:

	textMenu.t
		The source for the library itself.

	textMenu.tl
		The library file for the library.

	LICENSE.txt
		This file contains a copy of the MIT License, which is
		the license this library is distributed under.

	demo/makefile.t3m
		Makefile for the sample "game".

	demo/sample.t
		A sample "game" that illustrates the library's functions.

	doc/README.txt
		This file
