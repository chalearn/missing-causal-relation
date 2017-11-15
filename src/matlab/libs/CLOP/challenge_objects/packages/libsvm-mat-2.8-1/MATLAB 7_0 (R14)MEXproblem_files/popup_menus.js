/*Killer OO JS Menu Script by Pete Smith Version 1.1*/

var menu_script_loaded = true;

function Menu(label){
	this.items = new Array();
	this.actions = new Array();

//Now, make the container of menus
//Automatically add it to the array of menus
    this.label = label;

//methods for this object
	this.html = Html;
	this.showMenu = showMenu;
	this.hideMenu = hideMenu;
}


Menu.prototype.addMenuItem = function addMenuItem(label, action) {
    this.items[this.items.length] = label;
    this.actions[this.actions.length] = action;

}

function Html(){
	var output = new String();
	output += '<div id="'+this.label+'" class="menu_lay" onmouseover="thisMenu.showMenu()" onmouseout="thisMenu.hideMenu()">';
	//output += this.label;
	for (var a in this.actions){
            if (this.actions[a]){
		        output += '\n<div class="menuitem" onmouseover="onMenuItemOver(this)" onmouseout="onMenuItemOut(this)" onclick="location.href=\''+this.actions[a]+'\'">';
        		output += '&nbsp;<a href="'+ this.actions[a]+ '">';
        		output += this.items[a]+ '</a>&nbsp;'
        		output += '</div>\n';
    	    } else {
          	output += '\n<div class="info_lay">'+this.items[a]+'</div>';
    	    }
	}
	output += '</div>\n\n';
return output;
}




function fireMenu( menu_id, thisLink, orient ) {
	thisMenu = window.menus[menu_id];
	thisLink.onmouseout = function(){  thisLink.style.backgroundColor=''; thisMenu.hideMenu();}
	hideAllMenus();

	thisMenu.showMenu();
		positionMenu(thisLink,orient);

		

	//

	//DD detection Section
	//Now we get the rendered position coords, and attach to the object.
	thisMenu.coords = getMyCoords(document.getElementById(thisMenu.label));
	//Now we loop over all, attaching coords only if IE
 if (document.all) {
      for (var i in document.all){
      if (document.all[i].type == "select-one" || document.all[i].type == "select-multiple") {
         document.all[i].coords = getMyCoords(document.all[i]);
             if ( doICollide (thisMenu , document.all[i]) ) {
                 hideObject(document.all[i]);
             }
         }
      }
    }
}

function showHiddenDD(){
   if (document.all){
      for (var i in document.all){
         if (document.all[i].type == "select-one" || document.all[i].type == "select-multiple" && document.all[i].style.visibility == "hidden") {
            showObject(document.all[i]);
         }
      }
   }
}

function hideObject(hideObject){
    hideObject.style.visibility = "hidden";
}

function showObject(showObject){
    showObject.style.visibility = "visible";
}


function getMyCoords(getObject){
   coords = new Object();
   coords.width = getObject.offsetWidth;
   coords.height = getObject.offsetHeight;
   coords.oLeft = getPageOffsetLeft(getObject);
   coords.oTop = getPageOffsetTop(getObject);
   return coords;
}

function doICollide(object1 , object2) {
    //First we find out if the A coord is within the object2.
    if (object1.coords.oLeft < object2.coords.oLeft + object2.coords.width && object2.coords.oLeft < object1.coords.oLeft + object1.coords.width ) {
        if (object1.coords.oTop < object2.coords.oTop + object2.coords.height && object2.coords.oTop < object1.coords.oTop + object1.coords.height ) {
            return true;
        }
    }
}

function positionMenu(thisObject,orient){
//Get x and y position of the link
	coords = getMyCoords(thisObject);
//Now calculate the Height and Width
	linkHeight = thisObject.offsetHeight;
	linkWidth = thisObject.offsetWidth;
	switch(orient) {
		case "r":
			oLeft = coords.oLeft + linkWidth;
			oTop = coords.oTop;
		break;
		default:
			oLeft = coords.oLeft;
			oTop = coords.oTop + linkHeight;
		break;
	}
	//Now we position the menu
	document.getElementById(thisMenu.label).style.left = oLeft + "px";
	document.getElementById(thisMenu.label).style.top = oTop + "px";
    //We only want to position to left edge of block level elements, and only handles the shorties.
    if ( thisObject.tagName != "A" && document.getElementById(thisMenu.label).offsetWidth < thisObject.offsetWidth ) {
	    document.getElementById(thisMenu.label).style.width = thisObject.offsetWidth + 15;
    }

}

function hideAllMenus(){
	for (var a in window.menus) {
		document.getElementById(window.menus[a].label).style.display = "none";
	}
	showHiddenDD();
}

function showMenu(){
	if (window.hideMenuTimer) window.clearTimeout(hideMenuTimer);
	document.getElementById(thisMenu.label).style.display = "block";
}

function hideMenu(){
	hideMenuTimer = setTimeout("document.getElementById('"+thisMenu.label+"').style.display = 'none'; showHiddenDD();",850);
}


function onMenuItemOver(thisMenuItem){
	thisMenuItem.className = "menuitem_hover";
}

function onMenuItemOut(thisMenuItem){
	thisMenuItem.className = "menuitem";
}

function addMenu(menu){
	//The array that holds the menu objects is menus
	if (!window.menus) window.menus = new Array();
	window.menus[menu.label] = menu;
	//window.menus[window.menus.length] = menu;
}

function makeMenus(){
	if (!document.getElementById("menuContainer")){
		container = document.createElement("DIV");
		container.id = "menuContainer"
	}
document.body.appendChild(container) ;
//Now, put our nice html in da laya playa.
  container.innerHTML = complete_html;

}

function printMenus(){
var h = new String();
	for (var c in window.menus) {
		h += menus[c].html();
	}
return h;
}

