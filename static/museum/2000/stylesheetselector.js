// Copyright (c) 2000 [deep]software
// Gemaakt door *aquilla* voor [deep]software. *aquilla* maakt deel uit van de [deep]software Group.

// ------------------------------------------------------------------------
// Functies
// ------------------------------------------------------------------------

function CSSFileSelector(DefaultIEFile) {
	if (navigator.appName == "Netscape") {
		document.write('<LINK REL="stylesheet" TYPE="text/css" HREF="' + DefaultIEFile + '_ns.css">');
	}
	else {
		document.write('<LINK REL="stylesheet" TYPE="text/css" HREF="' + DefaultIEFile + '.css">');
	}
}
