/*____________________________

      Margro Knoppenbalk
______________________________

E-mail: Margrosoft@hotmail.com
______________________________
*/

var _toolId = 0; var _top = 0;
var _tQueue = new Array();
var _winWidth;
var bImgHiL, bImgHiM, bImgHiR;
var bImgLoL, bImgLoM, bImgLoR;
var bImgL, bImgM, bImgR;
var tImg, tImgCol, tImgHi, tImgColHi;
var isNav4, isIE4;
if (parseInt(navigator.appVersion.charAt(0)) >= 4) {
  isNav4 = (navigator.appName == "Netscape") ? true : false;
  isIE4 = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;
}
function setClip(layer, l, r, t, b) {
  if(isNav4) {
    layer.clip.left = l; layer.clip.right = r;
    layer.clip.top = t;  layer.clip.bottom = b;
  } else {
    layer.style.pixelWidth = r-l;
    layer.style.pixelHeight = b-t;
    layer.style.clip = "rect("+t+","+r+","+b+","+l+")";
  }
}
function Knopbalk(layer, layerCol, closed) {
  this.layer = layer;
  this.layerCol = layerCol;
  if(isIE4) winWidth = document.body.clientWidth;
  else if(isNav4) winWidth = window.innerWidth;
  this.open = !closed;
  this.Name = "knopbalk "+_toolId;
  this.fontIntro = "<FONT FACE='MS Sans Serif,Charcoal,Chicago,Arial,Helvetica' SIZE=1>";
  this.fontOutro = "</FONT>";
  this.sideWidth = 3;
  this.baseHREF = "";
  this.build = toolBuild;
  this.addItem = toolAddItem;
  this.writeButton = _writeButton;
  this.writeText = _writeText;
  this.update = toolUpdate;
  this.setFont = setFont;
  this.show = toolShow;
  this.height = 23;
  this.colHeight = 10;
  this.bgImg = "undefined";
  this.collapsedBgImg = "undefined";
  this.zIndex = 0;
  this.bgColor = "#0022FF";
  this.collapsedBgColor = "#0022FF";
  this.strs = new Array();
  this.tars = new Array();
  this.urls = new Array();
  this.widths = new Array();
  this.id = _toolId;
  if(!layerCol.items) layerCol.items = new Array();
  layerCol.items[layerCol.items.length] = this;
  _tQueue[_toolId++] = this;
}
function toolUpdate() {
  var l = this.layer;
  if(isNav4) {
    l.visibility = "hidden";
    l.bgColor = this.bgColor;
    l.background.src = this.bgImg;
    l.top = _top;
    l.left = 0;
    if(this.open) _top += this.height;
    l = this.layerCol;
    l.visibility = "hidden";
    l.bgColor = this.collapsedBgColor;
    l.background.src = this.collapsedBgImg;
    l.top = _top;
    l.left = 0;
  } else {
    l.style.visibility = "hidden";
    l.style.backgroundColor = this.bgColor;
    l.style.backgroundImage = "url("+this.bgImg+")";
    l.style.pixelTop = _top;
    l.style.pixelLeft = 0;
    if(this.open) _top += this.height;
    
    l = this.layerCol;
    l.style.visibility = "hidden";
    l.style.backgroundColor = this.collapsedBgColor;
    l.style.backgroundImage = "url("+this.collapsedBgImg+")";
    l.style.pixelTop = _top;
    l.style.pixelLeft = 0;    
  }
}
function setFont(i, j) {
  this.fontIntro = i;
  this.fontOutro = j;
}
function toolExpand(id) {
  _tQueue[id].open = !_tQueue[id].open;
  if(isNav4) {
    if(_tQueue[id].open) _tQueue[id].layer.visibility = "inherit";
    else _tQueue[id].layer.visibility = "hidden";
  } else {
    if(_tQueue[id].open) _tQueue[id].layer.style.visibility = "inherit";
    else _tQueue[id].layer.style.visibility = "hidden";
  }
  _tQueue[id].show();
}
function toolAddItem(str, url, width, target) {  
  this.strs[this.strs.length] = str;
  this.tars[this.tars.length] = target;
  this.urls[this.urls.length] = url;
  this.widths[this.widths.length] = width || 75;
}
function _sI(id, i, type) {
  var img1, img2, img3;
  if(isIE4) {
    var img1 = eval("document.all.img"+id+i+"1;");
    img2 = eval("document.all.img"+id+i+"2;");
    img3 = eval("document.all.img"+id+i+"3;");
  } else {
    img1 = eval('_tQueue['+id+'].layer.document.layers.text'+id+'.document.images['+(3*i)+'];');
    img2 = eval('_tQueue['+id+'].layer.document.layers.text'+id+'.document.images['+(3*i+1)+'];');
    img3 = eval('_tQueue['+id+'].layer.document.layers.text'+id+'.document.images['+(3*i+2)+'];');
  }
  if(type == "button") {
    img1.src = bImgL.src;
    img2.src = bImgM.src;
    img3.src = bImgR.src;
  } else if(type == "button_hi") {
    img1.src = bImgHiL.src;
    img2.src = bImgHiM.src;
    img3.src = bImgHiR.src;
  } else {
    img1.src = bImgLoL.src;
    img2.src = bImgLoM.src;
    img3.src = bImgLoR.src;
  }
}
function _writeButton() {
  var x = 0;
  var l;
  if(isNav4) l = eval('this.layer.document.layers.text'+this.id+';');
  else if(isIE4) l = eval('this.layer.document.all.text'+this.id+';');
  var str = ""; 
  str += "<TABLE HEIGHT="+this.height+" WIDTH="+window.innerWidth+" BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD WIDTH=5 NOWRAP></TD>\n";
  for(var i = 0; i < this.strs.length; i++) {
    str += "<TD WIDTH="+this.widths[i]+" NOWRAP VALIGN=MIDDLE>";
    if(this.urls[i]) {
      str += "<A HREF='"+this.urls[i]+"'";
      if(this.tars[i]) str += " TARGET='main'";            //'"+this.tars[i]+"'"
      str += " ONMOUSEOVER='_sI("+this.id+","+i+",\"button_hi\")'";
      str += " ONMOUSEOUT='_sI("+this.id+","+i+",\"button_lo\")'";
      str += " ONMOUSEDOWN='_sI("+this.id+","+i+",\"button\")'";
      str += " ONMOUSEUP='_sI("+this.id+","+i+",\"button_hi\")'";
      str += ">";
    }
    str += "<IMG SUPPRESS=\"TRUE\" NAME=\"img"+this.id+i+"1\" WIDTH="+this.sideWidth+" HEIGHT="+(this.height-2)+" BORDER=0 SRC='"+bImgLoL.src+"' VSPACE=1>";
    str += "<IMG SUPPRESS=\"TRUE\" NAME=\"img"+this.id+i+"2\" WIDTH="+(this.widths[i]-2*this.sideWidth)+" HEIGHT="+(this.height-2)+" BORDER=0 SRC='"+bImgLoM.src+"' VSPACE=1>";
    str += "<IMG SUPPRESS=\"TRUE\" NAME=\"img"+this.id+i+"3\" WIDTH="+this.sideWidth+" HEIGHT="+(this.height-2)+" BORDER=0 SRC='"+bImgLoR.src+"' VSPACE=1>";
    if(this.urls[i]) str += "</A>\n";
    str += "</TD>";
    x += this.widths[i];
  }
  str += "<TD NOWRAP WIDTH="+(window.innerWidth-x)+">&nbsp;</TD>";
  str += "</TR></TABLE>";
  if(isNav4) {
    l.document.open();
    l.document.write(str);
    l.document.close();
  } else
    l.innerHTML = str;
}
function _writeText() {
  var x = 0;
  var l = this.layer;
  var str = "";
  str += "<DIV ID='text"+this.id+"' NAME='text"+this.id+"'></DIV>";
  str += "<A HREF='javascript:toolExpand("+this.id+");'";
  if(isNav4) str += " ONMOUSEOVER='document.images[0].src=tImgHi.src' ONMOUSEOUT='document.images[0].src=tImg.src'";
  str += ">";
  str += "<IMG SUPPRESS=TRUE WIDTH=9 HEIGHT="+(this.height-2)+" VSPACE=1 ONMOUSEOVER='this.src=tImgHi.src' ONMOUSEOUT='this.src=tImg.src' HSPACE=1 BORDER=0 SRC='"+tImg.src+"' ALIGN=LEFT ALT=\""+this.Name+"\">";
  str += "</A>\n";
  str += "<TABLE CELLPADDING=0 HEIGHT="+this.height+" WIDTH="+window.innerWidth+" BORDER=0 CELLSPACING=0><TR><TD WIDTH=5></TD>\n";
  for(var i = 0; i < this.strs.length; i++) {
    str += "<TD WIDTH="+this.widths[i]+" NOWRAP ALIGN=CENTER VALIGN=MIDDLE>";
    if(this.fontIntro) str += this.fontIntro;
    str += this.strs[i];
    if(this.fontOutro) str += this.fontOutro;
    str += "</TD>";
    x += this.widths[i];
  }
  str += "<TD WIDTH="+(window.innerWidth-x)+">&nbsp;</TD>";
  str += "</TR></TABLE>\n";
  if(isNav4) {
    l.document.open();
    l.document.write(str);
    l.document.close();
  } else
    l.innerHTML = str;
}
function toolShow() {
  var t = 0;
  for(var i = 0; i < _tQueue.length; i++) {
    if(_tQueue[i].open) {
      if(isNav4) _tQueue[i].layer.top = t;
      else _tQueue[i].layer.style.pixelTop = t;
      t += _tQueue[i].height;
    }
  }
  _top = t;
  _updateCol(this.layerCol);
  this.shown = true;
}
function _updateCol(l) {
 if(isNav4) l.top = _top;
  else l.style.pixelTop = _top;
  var str = "";
  for(var i = 0, j = 0; i < l.items.length; i++) {
    if(l.items[i].open == true) continue;
    str += "<A HREF='javascript:toolExpand("+l.items[i].id+");'";
    if(isNav4) str += " ONMOUSEOVER='document.images["+j+"].src=tImgColHi.src' ONMOUSEOUT='document.images["+j+"].src=tImgCol.src'";
    str += ">";
    str += "<IMG ONMOUSEOVER='this.src=tImgColHi.src' ONMOUSEOUT='this.src=tImgCol.src' WIDTH=39 SUPPRESS=TRUE HEIGHT=10 VSPACE=0 HSPACE=0 BORDER=0 SRC='"+tImgCol.src+"' ALT=\""+l.items[i].Name+"\" ALIGN=LEFT>";
   str += "</A>\n";
    j++;
  }
  if(isNav4) {
    l.document.open();
    l.document.write(str);
    l.document.close();  
    if(j > 0) l.visibility = "inherit";
    else l.visibility = "hidden";
  } else {
    l.innerHTML = str;
    if(j > 0) l.style.visibility = "inherit";
    else l.style.visibility = "hidden";
  }
}
function toolBuild() {
  if(this.bgImg == "undefined")
    this.bgImg = this.baseHREF + "medium.gif";
  if(this.collapsedBgImg == "undefined")
    this.collapsedBgImg = this.baseHREF + "medium_col.gif";
  if(!bImgHiL) {
    bImgHiL = new Image(); bImgHiL.src = this.baseHREF + "button_hiL.gif";
    bImgHiM = new Image(); bImgHiM.src = this.baseHREF + "button_hiM.gif";
    bImgHiR = new Image(); bImgHiR.src = this.baseHREF + "button_hiR.gif";
    bImgLoL = new Image(); bImgLoL.src = this.baseHREF + "button_loM.gif";
    bImgLoM = new Image(); bImgLoM.src = this.baseHREF + "button_loM.gif";
    bImgLoR = new Image(); bImgLoR.src = this.baseHREF + "button_loR.gif";
    bImgL = new Image();   bImgL.src = this.baseHREF + "button_hiL.gif";                    //buttonL.gif, M, R
    bImgM = new Image();   bImgM.src = this.baseHREF + "button_hiM.gif";
    bImgR = new Image();   bImgR.src = this.baseHREF + "button_hiR.gif";            //tot hier
    tImg = new Image();     tImg.src = this.baseHREF + "thumb.gif";
    tImgCol = new Image();  tImgCol.src = this.baseHREF + "thumb_col.gif";
    tImgHi = new Image();   tImgHi.src = this.baseHREF + "thumb_hi.gif";
    tImgColHi = new Image();tImgColHi.src = this.baseHREF + "thumb_col_hi.gif";
  }
  if(!this.shown) {
    setClip(this.layerCol, 0, winWidth, 0, this.colHeight);
    setClip(this.layer, 0, winWidth, 0, this.height);
    this.update(); this.show();
  }
  this.writeText();
  if(isNav4) {
    this.layer.zIndex = this.zIndex;
    this.layerCol.zIndex = this.zIndex;
    var buttonLayer = eval('this.layer.document.layers.text'+this.id+';');
    buttonLayer.top = 0;
    buttonLayer.left = 10;
    buttonLayer.clip.width = window.innerWidth - 10;
    this.writeButton();
    if(this.open) this.layer.visibility = "inherit";
    else this.layer.visibility = "hidden";
  } else if(isIE4) {
    this.layer.style.zIndex = this.zIndex;
    this.layerCol.style.zIndex = this.zIndex;
    var buttonLayer = eval('document.all.text'+this.id+';');
    buttonLayer.style.pixelTop = 0;
    buttonLayer.style.pixelLeft = 10;
    setClip(buttonLayer, 0, winWidth-10, 0, this.height);
    this.writeButton();
    if(this.open) this.layer.style.visibility = "inherit";
    else this.layer.style.visibility = "hidden";
  }
}
