function printWindow () {
   bV = parseInt(navigator.appVersion)
   if (bV >= 4) window.print()
} // end function printWindow

function openWindow ( url, width, height, options, name ) {
  if ( ! width ) width = 640;
  if ( ! height ) height = 420;
  if ( ! options ) options = "scrollbars=yes,menubar=yes,toolbar=yes,location=yes,status=yes,resizable=yes";
  if ( ! name ) name = "outsideSiteWindow";
  var newWin = window.open( url, name, "width=" + width + ",height=" + height + "," + options );
} // end function openWindow

function jumpMenu (targ,selObj,restore) { //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
} // end function jumpMenu

/* Get X-coordinate of an object */
function getPageOffsetLeft (el) {
  var ol=el.offsetLeft;
  while ((el=el.offsetParent) != null) { ol += el.offsetLeft; }
  return ol;
} // end function getPageOffsetLeft

/* Get Y-coordinate of an object */
function getPageOffsetTop (el) {
  var ot=el.offsetTop;
  while((el=el.offsetParent) != null) { ot += el.offsetTop; }
  return ot;
} // end function getPageOffsetTop

/*Functions for TopNav Hovering*/
function topNavHover(topnav) {
	topnav = document.getElementById(topnav);
	topnav.style.backgroundColor = "#DBE4F5" ;
}

function topNavHoverOff(topnav) {
	topnav = document.getElementById(topnav);
	topnav.style.backgroundColor = "" ;
}

function mouseover(thisEl, thisImg, thisRollOver) {
	var prevSrc = thisImg.src;
	thisImg.src = thisRollOver;
	thisEl.onmouseout = function () {thisImg.src = prevSrc;}
}

function compMatch() {

    // not all documents have the response form we detect Salutation
    if (document.getElementById("Salutation") == null) {
        return true;
    }

    // not all response forms have the Company_or_University field
    if (document.getElementById("Company_or_University") == null) {
        return true;
    }

    var compValue = document.getElementById("Company_or_University").value;

    // not all response forms have the nr_Department field
    if (document.getElementById("Department") != null) {
        if (document.getElementById("Department").value == "") {
            var subjects = ["college" , "univ" ];
            for (var i in subjects) {
                var pattern = new RegExp(subjects[i], "i");
                if (pattern.test(compValue)) {
                    if (confirm (
                        "Please provide your department name. "+
                        "You have submitted a company/university address that typically requires "+
                        "a department name in order for the post office and your organization's mail room "+
                        "to deliver the materials you are requesting. "+
                        "Click 'OK' to go back and specify a department or "+
                        "click 'cancel' to submit the form without a department.")) {
                        document.getElementById("Department").focus();
                        return false;
                    }
                }
            }
        }
    }
    // not all response forms have the Mail_stop field
    if (document.getElementById("Mail_stop") != null) {
        if (document.getElementById("Mail_stop").value == "") {
            var subjects = ["air force", "bae", "boeing", "daimlerchrysler", "delphi", "ford", "general motors", "gm", "honeywell",
                "ibm", "jet propulsion", "lockheed", "mit lincoln", "nasa", "navair", "naval air", "naval research", "raytheon", "Richardson", "sun micro", "visteon" ];
            for (var i in subjects) {
                var pattern = new RegExp(subjects[i], "i");
                if (pattern.test(compValue)) {
                    if (confirm (
                        "Please provide your mail stop. "+
                        "You have submitted an address for a company that typically requires "+
                        "a mail stop in order for the post office and your organization's mail room "+
                        "to deliver the materials you are requesting. "+
                        "Click 'OK' to go back and specify a mail stop or "+
                        "click 'Cancel' to submit the form without a mail stop.")){
                        document.getElementById("Mail_stop").focus();
                        return false;
                    }
                }
            }
        }
    }
    return true;
} // end function compMatch

function sizeTables () {
  var bodyTables = document.getElementById("mainbody").getElementsByTagName("table");
  var rightCol = document.getElementById("rightcol");
  var rightColHeight = rightCol.offsetHeight;
  var rcolY = getPageOffsetTop(rightCol);
  var rcolTotal = (rcolY + rightColHeight);
  for (i=0; i<bodyTables.length; i++) {
    if (bodyTables[i].offsetWidth > 420 && getPageOffsetTop(bodyTables[i]) < rcolTotal && document.getElementById("leftnavcol")) {
      bodyTables[i].width = 420 ;
    }// end if
  } // end for
} // end function sizeTables

/* OnLoad Firing */
onload = function () {
  if (navigator.appName == "Microsoft Internet Explorer") {
    if ( document.getElementById("mainbody") && document.getElementById("rightcol") ) {
      sizeTables();
    } // end if
  } // end if
} // end anonymous function
