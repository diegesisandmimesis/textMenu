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

	// The accepted input strings.  This needs to be a List whose
	// elements are the valid inputs.  E.g., something like
	// [ 'start', 'restore', 'quit' ] or whatever.
	// The return value from showMenu() will be one of these strings
	// or nil on error.
	menuOptions = nil

	// Boolean flag.  If set, an empty line (that is, the player just
	// hits return) is also accepted.  Useful if you want to present
	// a menu of options but also have a default (like a startup menu
	// where you just have to hit return to start the game normally)
	allowBlank = nil

	_showMenu() {
		cls();
		"<<menuText>> ";
	}

	showMenu() {
		local cmd, r;

		_showMenu();

		for(;;) {
			"<<menuPrompt>>";
			cmd = inputManager.getInputLine(nil, nil);

			r = parseInput(cmd);
			if(r != nil)
				return(r);

			_showMenu();
		}
	}

	parseInput(txt) {
		local kw, r;

		if(!txt)
			return(nil);

		if(allowBlank && (rexMatch('<space>*$', txt) != nil))
			return('');

		if(rexMatch('<space>*(<alpha>+)<space>*$', txt) != nil) {
			kw = rexGroup(1)[3].toLower();
		} else {
			return(nil);
		}

		r = nil;
		menuOptions.forEachAssoc(function(k, v) {
			if(r != nil) return;
			if(k.startsWith(kw)) {
				r = k;
				handleMatch(v);
			}
		});

		return(r);
	}

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

	anyKeyToContinue(txt?, prompt?) {
		if(txt)"<<txt>>";
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

