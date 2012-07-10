window.onload = function() {
	// check to see that the browser supports the getElementsByTagName method
	// if not, exit the loop 
	if (!document.getElementsByTagName) {
		return false; 
	} 
	// create an array of objects of each link in the document 
	var popuplinks = document.getElementsByTagName("a");
	// loop through each of these links (anchor tags) 	
	for (var i=0; i < popuplinks.length; i++) {	
		// if the link contains the class of "popup"...
		var haystack = popuplinks[i].className;
		var needle = "popup";
		if (haystack.indexOf(needle) != -1) {	
			// add an onclick event on the fly to pass the href attribute	
			// of the link to our second function, openPopUp 	
			popuplinks[i].onclick = function() {	
			openPopUp(this.getAttribute("href"));	
			return false; 	
			} 	
		}
	} 
} 

function openPopUp(linkURL) {
	popwindow=window.open(linkURL,'_blank','height=600,width=600,menubar=no,scrollbars=yes,toolbar=no,status=no,resizable=yes');
	if (window.focus) {
		popwindow.focus()
	}
}