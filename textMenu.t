#charset "us-ascii"
//
// textMenu.t
//
//	This is a module for implementing simple "multiple choice" text
//	menus in TADS3.
//
#include <adv3.h>
#include <en_us.h>

// Module ID for the library
textMenuModuleID: ModuleID {
	name = 'textMenu Library'
	byline = 'Diegesis & Mimesis'
	version = '1.0'
	listingOrder = 99
}

class TextMenu: object
	// The menu text.  This is the whole thing, not counting the input
	// prompt--the library just prints it, it doesn't do any parsing or
	// formatting.
	menuText = nil

	// The input prompt, displayed at the bottom of the menu text
	menuPrompt = '\b&gt;'

	// The accepted input strings.  This needs to be a LookupTable whose
	// keys are the valid inputs and whose values are functions or
	// methods to be called when the player enters that string.
	// E.g., something like
	//
	// menuOptions = static [
	//	'start'	-> &startMethod,
	//	'quit'	-> &quitMethod
	// ]
	//
	// The method should be defined on the TextMenu instance.
	menuOptions = nil

	// Boolean flag.  If set, the screen is cleared via cls() before
	// the menu is displayed.
	menuClear = true

	// Boolean flag.  If set, an empty line (that is, the player just
	// hits return) is also accepted.  Useful if you want to present
	// a menu of options but also have a default (like a startup menu
	// where you just have to hit return to start the game normally)
	allowBlank = nil

	// Flag set by returnToMenu()
	// Tells the main showMenu() loop to run through the loop again.
	_menuFlag = nil

	// Helper method that clears the screen and displays the menu text.
	_showMenu() {
		if(menuClear == true)
			cls();
		"<<menuText>> ";
	}

	// Entry point for external callers.  This displays the menu text
	// and gets player input.
	showMenu() {
		local cmd, r;

		for(;;) {
			// Show the menu text and prompt
			_showMenu();
			"<<menuPrompt>>";

			// Get a line of input from the player
			cmd = inputManager.getInputLine(nil, nil);

			// Figure out if the player input matched a keyword,
			// and if so if we're done or if we need to display
			// the menu again.
			r = parseInput(cmd);
			if((r != nil) && !_menuFlag)
				return(r);

			// Reset the return-to-menu flag
			_menuFlag = nil;
		}
	}

	// Called by keyword handlers if they want to return to the menu
	// after they're done doing whatever they're going to do.
	// If this ISN'T called by a handler, then control will return
	// to the caller (whoever invoked showMenu()), exiting the menu.
	returnToMenu() {
		_menuFlag = true;
	}

	// Parse the player input.
	parseInput(txt) {
		local kw, r;

		// If we got a null argument somehow, bail.
		if(!txt)
			return(nil);

		// If the allowBlank flag is set, check to see if we
		// have a blank line and handle it and return if we do.
		if(allowBlank && (rexMatch('<space>*$', txt) != nil)) {
			handleDefault();
			return('');
		}

		// Check to see if the contents of the line look like a
		// single word.
		if(rexMatch('<space>*(<alpha>+)<space>*$', txt) != nil) {
			// Save the value of the single word
			kw = rexGroup(1)[3].toLower();
		} else {
			// Didn't get something that looked like a word, bail.
			return(nil);
		}

		// Now go through all the defined menuOptions and see if
		// our saved word matches any of them.
		r = nil;
		menuOptions.forEachAssoc(function(k, v) {
			if(r != nil) return;
			if(k.startsWith(kw)) {
				// Remember the match.
				r = k;

				// Call whatever callback function is defined
				// for this option in menuOptions.
				handleMatch(v);
			}
		});

		// Return our match, or nil if we didn't get one.
		return(r);
	}

	// Handle the special case where the player doesn't enter anything
	// and just hits return.
	// Only ever used if the allowBlank flag is set.
	handleDefault() {
	}

	// Figure out what kind of value we got as a callback and call it if
	// possible.
	handleMatch(v) {
		switch(dataTypeXlat(v)) {
			case TypeProp:
				self.(v)();
				break;
			case TypeFuncPtr:
				v();
				break;
		}
	}

	// Wait for the player to hit a key.
	// First arg is an optional text literal to print before the prompt.
	// Second arg is either boolean true or a string.  If it's boolean
	// true, the default prompt will be displayed (after the text given
	// in the first arg, if any).  If it's a string, it is displayed as
	// a prompt.
	// The key pressed by the player is silently discarded.
	anyKeyToContinue(txt?, prompt?) {
		if(txt) "<<txt>>";
		if(prompt == true) {
			"<br><br>Press <b>any key</b> to continue ";
		} else if(prompt) {
			"<<prompt>> ";
		}

		for(;;) {
			inputManager.getKey(nil, nil);
			return;
		}
	}

	// Wait for the player to hit return.
	// First arg is an optional text literal to print before the prompt.
	// Second arg is either boolean true or a string.  If it's boolean
	// true, the default prompt will be displayed (after the text given
	// in the first arg, if any).  If it's a string, it is displayed
	// as a prompt.
	// Any text input by the player (on the input line, before hitting
	// enter) is silently discarded.
	enterToContinue(txt?, prompt?) {
		if(txt) "<<txt>>";
		if(prompt == true) {
			"<br><br>[<b>Enter</b>] to continue ";
		} else if(prompt) {
			"<<prompt>> ";
		}
		for(;;) {
			inputManager.getInputLine(nil, nil);
			return;
		}
	}
;

