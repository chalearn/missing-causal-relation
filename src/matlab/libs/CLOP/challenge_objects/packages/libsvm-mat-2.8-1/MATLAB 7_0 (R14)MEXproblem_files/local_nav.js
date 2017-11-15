/* Local Navigation Menu Script */
/* By Peter Smith Version 1 */

/* ShowMe toggles the currently selected menu, image */
function showMe (index) {
  // if IE 5.X, IE 6.X , Moz, DOM
  if (document.getElementById) {
    var menutrs = document.getElementById("leftnav").getElementsByTagName("tr");
    //First, we toggle the one we selected
    for (a=0; a < menutrs.length; a++) {
      br = new RegExp(index + "-");
      if ( menutrs[a].id.match(br) ) {
        menutrs[a].className = ( menutrs[a].className !=  "hid") ? "hid" : "";
      } // end if
    } // end for
    //Now, we toggle the image and titles
    img = document.getElementById("limg-" + index);
    img.src = ( img.src.match("collapse.gif") ) ? "/includes/images/local_nav/expand.gif" : "/includes/images/local_nav/collapse.gif" ;
    img.alt = ( img.alt != "Hide Section" ) ? "Hide Section" : "Show Section";
    link = img.parentNode;
    link.title = ( link.title !=  "Hide Section") ? "Hide Section" : "Show Section";
  } // end if
} // end function showMe