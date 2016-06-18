import javax.swing.*;
import java.awt.event.KeyEvent;
import java.awt.*;
import processing.awt.PSurfaceAWT.SmoothCanvas;

// The basis for this program is the code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.

//setup the program parameters as constants.
//
static final String cDataFileName ="TestSet1_proc2func.csv"; // The standard datafile with example data 

static final String cImageDir = "/image";                   //the image submap to save screenshots to. This must be a submap of the data map.

int filterindex=2;                                           //choose 0 tm 9 for prefined filters which is active on startup.

static final int cRestDistTo = 20;                           //no clue what the function of this one is.

static final int cformwidth = 1600;                          //total formwidth of the application, can be no larger than the screen, no scrollbars are possible
static final int cformheight = 600;                          //total formheight of the application,  can be no larger than the screen, no scrollbars are possible

static final int cInfoPanelwidth = 150;                      //width of the infopanel on the right of the form.
static final int cFormPadding = 32;                          //margin used 
static final int cFormLevelMin = 0 ;                         //top y coordinate of the levelbands 
static final int cFormLevelMax = cformheight- cFormPadding;  //bottom y coordinate of the levelbands.

static final int cHierFromMin = 0 ;                          //top y coordinate for the hierarchie fromband
static final int cHierFromMax = cformheight/2;               //bottom y coordinate for the hierarchie fromband
static final int cHierToMin = cformheight/2;                 //top y coordinate for the hierarchie to band
static final int cHierToMax = cformheight- cFormPadding;     //bottom y coordinate for the hierarchie to band

//init the type values used in the datafile
static final String cPackageBody = "PACKAGE BODY";   
static final String cProcedure = "PROCEDURE";
static final String cFunction = "FUNCTION";
static final String cView = "VIEW"; 
static final String cPackage="PACKAGE";
static final String cType="TYPE";
static final String cTrigger = "TRIGGER";
static final String cMaterializedView="MATERIALIZED VIEW";
static final String cTable= "TABLE"; 
static final String cSequence="SEQUENCE";

//init id's used in the program for the types
static final int cPackageBodyID= 0;        
static final int cProcedureID = 1;
static final int cFunctionID = 2;
static final int cViewID = 3; 
static final int cPackageID = 4;
static final int cTypeID = 5;
static final int cTriggerID = 6;
static final int cMaterializedViewID = 7;
static final int cTableID = 8; 
static final int cSequenceID = 9;

//init the colors
static final color selectColor = #FF3030;
static final color fixedColor  = #FF8080;
static final color edgeColor   = #000000;

static final color cPackageBodyColor      = #B6834F; 
static final color cProcedureColor        = #D0D0FF; 
static final color cFunctionColor         = #31B331;  
static final color cViewColor             = #8182AD;  
static final color cPackageColor          = #A12416;  
static final color cTypeColor             = #FFD49C;  
static final color cTriggerColor          = #FF8131;  
static final color cMaterializedViewColor = #005100; 
static final color cTableColor            = #CFD1EA;   
static final color cSequenceColor         = #990000;  

//Init the mnemonics, used as encrypedname with a number as postfix 
static final String cProcedurmnem         = "proc";
static final String cFunctionmnem         = "func";
static final String cPackagemnem          = "pack";
static final String cTablemnem            = "tabl";
static final String cTriggermnem          = "trig";
static final String cSequencemnem         = "seq";
static final String cViewmnem             = "view";
static final String cTypemnem             = "typ";
static final String cMaterializedViewmnem = "mview";
static final String cPackageBodymnem      = "packb";


//direction constants
static final String cFrom = "F";
static final String cTo = "T";
static final String cNone = "";
//search constants
static final int cNoWildCard = 0;
static final int cLeftWildCard = 1;
static final int cRightWildCard = 2;
static final int cLeftRightWildCard = 3;

//einde instellingen

//definition of system flags
boolean flgfreeze;           //indicates that the screen should be freezed
boolean flgshowselected;     //indicates that only the selected nodes and edges should be shown
boolean flgshowall;          //indicates that all nodes and edges should be shown
boolean flglogscale;         //indicates if the nodesize is lineair or logscale
boolean flgprocesdraw;       //indicates that the screen should not be painted
boolean flgcntrlkey;         //indicates that the ctlr key is pressed
boolean flgaltkey;           //indicates that the alt key is pressed
boolean flgShowLabels;       //indicates the draw proces that the labels should be show.
boolean flgShowLabelBckGrnd; //indicates that the background of the labels is show
boolean flgsearchmode;       //Indicates that a search is going on.
boolean flgencrypt;          //Indicates that the names of the objects are encryped

//flag indicating that the function key is pressed
boolean flgAltF1toggle;
boolean flgAltF2toggle;
boolean flgAltF3toggle;
boolean flgAltF5toggle;
boolean flgAltF6toggle;
boolean flgAltF7toggle;

//flag indicating that the ctrl key and the function key is pressed
boolean flgCtrlF1toggle;
boolean flgCtrlF2toggle;
boolean flgCtrlF3toggle;
boolean flgCtrlF5toggle;
boolean flgCtrlF6toggle;
boolean flgCtrlF7toggle;

//init arrays
static color[]  nodecolor = new color[10];      //array with the nodecolors, indexed by node type
static int[]    bandypos  = new int[10];        //the y coordinates of the bands
static PImage[] icons     = new PImage[10];     //array withe the icon images of the nodes, indexed by node type

HashMap nodeTable ;    //associative array with the nodes index by nodename,node type and direcion (to/from)
Node[] nodes ;         //array of node objects
Edge[] edges ;         //array of edge objects

//various variables
int nodeCount;
int edgeCount;
int nodeMinRelCount,nodeMaxRelCount, tablerows;
int nodeFromMinRelCount,nodeFromMaxRelCount;
int nodeToMinRelCount,nodeToMaxRelCount;
int nodeMinLevel, nodeMaxLevel;
String dataFileName;

//right mouse popumenu variables
PopUpMenu popup;
SmoothCanvas canvas;

//filter variables
String[] stndfilters = new String[10];
String activeStndFilter;
String activeSrchFilter;

//associative integer arrays presenting the hierarchical laysers in the graphics
IntDict frombands;
IntDict fromBandsMinx;
IntDict fromBandsMaxx;

IntDict levelbands;
IntDict levelBandsMinx;
IntDict levelBandsMaxx;

//associative string array holding the crypto nameas of the objects
StringDict type2memnonic;

//string to hold the types search tekst
String searchtekst;
Node selection; 
//holds the text font used in the information boxes.
PFont font;

/**
* The settings function is executed on application start.
* Here the application parameters are set.
**/
void settings(){

  //set the system flags
  flglogscale = false;      //nodesize is lineair 
  flgprocesdraw = false;    //don't draw because the graphics system isn't initialized yet
  flgsearchmode = false;    //the searchmode is not active.
  flgencrypt = false;       //default the objects names are shown.
  
  size(cformwidth, cformheight); 
  nodeCount = 0;
  edgeCount = 0;
  searchtekst ="";
//init the node colors  
  nodecolor[cPackageBodyID]      = cPackageBodyColor; 
  nodecolor[cProcedureID]        = cProcedureColor; 
  nodecolor[cFunctionID]         = cFunctionColor;  
  nodecolor[cViewID]             = cViewColor;  
  nodecolor[cPackageID]          = cPackageColor;  
  nodecolor[cTypeID]             = cTypeColor;  
  nodecolor[cTriggerID]          = cTriggerColor;  
  nodecolor[cMaterializedViewID] = cMaterializedViewColor ; 
  nodecolor[cTableID]            = cTableColor;   
  nodecolor[cSequenceID]         = cSequenceColor;  

// setup the type band positions
  bandypos[cPackageBodyID]      = 200 ; 
  bandypos[cProcedureID]        = 300 ; 
  bandypos[cFunctionID]         = 0;  
  bandypos[cViewID]             = 450;  
  bandypos[cPackageID]          = 550;  
  bandypos[cTypeID]             = 0;  
  bandypos[cTriggerID]          = 0;  
  bandypos[cMaterializedViewID] = 0; 
  bandypos[cTableID]            = 500;   
  bandypos[cSequenceID]         = 0 ;  

//loading of the icons
  icons[cPackageBodyID]      = loadImage( "icons/package.gif"); 
  icons[cProcedureID]        = loadImage( "icons/procedure.gif"); 
  icons[cFunctionID]         = loadImage( "icons/function.gif"); 
  icons[cViewID]             = loadImage( "icons/view.gif"); 
  icons[cPackageID]          = loadImage( "icons/package.gif"); 
  icons[cTypeID]             = loadImage( "icons/type.gif"); 
  icons[cTriggerID]          = loadImage( "icons/trigger.gif"); 
  icons[cMaterializedViewID] = loadImage( "icons/materializedview.gif"); 
  icons[cTableID]            = loadImage( "icons/table.gif"); 
  icons[cSequenceID]         = loadImage( "icons/sequence.gif"); 

//defintion of the standard filters
  stndfilters[0]="["+cProcedure+"]";
  stndfilters[1]="["+cFunction+"]";
  stndfilters[2]="["+cProcedure+"]["+cFunction+"]";
  stndfilters[3]="["+cFunction+"]["+cTable+"]";
  stndfilters[4]="["+cPackage+"]["+cTable+"]";
  stndfilters[5]="["+cProcedure+"]["+cFunction+"]["+cTable+"]";
  stndfilters[6]="["+cPackage+"]";
  stndfilters[7]="["+cProcedure+"]["+cFunction+"]["+cPackage+"]";
  stndfilters[8]="["+cPackage+"]["+cTable+"]";
  stndfilters[9]="["+cTrigger+"]["+cTable+"]["+cSequence+"]";

//definition of the mnemonics
  type2memnonic = new StringDict();
  type2memnonic.set(cProcedure       , cProcedurmnem);
  type2memnonic.set(cFunction        , cFunctionmnem);
  type2memnonic.set(cPackage         , cPackagemnem);
  type2memnonic.set(cTable           , cTablemnem);
  type2memnonic.set(cTrigger         , cTriggermnem);
  type2memnonic.set(cSequence        , cSequencemnem);
  type2memnonic.set(cView            , cViewmnem);
  type2memnonic.set(cType            , cTypemnem);
  type2memnonic.set(cMaterializedView, cMaterializedViewmnem);
  type2memnonic.set(cPackageBody     , cPackageBodymnem);

//init the active filter to start with
  activeStndFilter = new String(stndfilters[filterindex]);
  activeSrchFilter   = "";

  flgAltF1toggle = false;
  flgAltF2toggle = false;
  flgAltF3toggle = false;
  flgAltF5toggle = false;
  flgAltF6toggle = false;
  flgAltF7toggle = false;
  
//init the ctrl function flags  
  flgCtrlF1toggle = false;
  flgCtrlF2toggle = false;
  flgCtrlF3toggle = false;
  flgCtrlF5toggle = false;
  flgCtrlF6toggle = false;
  flgCtrlF7toggle = false;
// init datafilename
  dataFileName = cDataFileName;
}

/**
* initializes the rightmouse popup menu
* sets the canvas variabele to the canvas or null
* and initializes the popupmenu.
**/
void init_popupmenu(){
  String clsname;
  Object obj;
  obj     = getSurface().getNative(); //get draw surface renderer
  clsname = obj.getClass().getName();  //<>//
  if (clsname.indexOf("SmoothCanvas") > 0) {
     canvas=(SmoothCanvas) obj;
  }  else canvas = null;
 
 popup = new PopUpMenu(this);

}


/**
* setup init settings at application runtime.
**/
void setup() {
    flgprocesdraw = false;
//
  println("setup()");
  println("activeFilter: " + activeStndFilter);

  nodeCount = 0;
  edgeCount = 0;
  nodes = new Node[100];
  edges = new Edge[500]; 
  nodeTable = new HashMap();

  loadData();
  //find min and max relation count
  find_minmaxrelcount();
  //find min and max level of the nodes
  find_MinMaxNodeLevel();
  
//if ratio > 100 than set the log flag to draw on log scale 
  if ((nodeMaxRelCount/nodeMinRelCount) > 100) flglogscale =true;

//find and collect the from bands in a dictionary
  findFromBands();
  findLevelBands();

//print the dictionary as 2 arrays
//  printArray(frombands.keyArray());
//  printArray(frombands.valueArray());
  font = createFont("SansSerif", 10);
  flgfreeze = false;
  flgshowselected = false;
  flgshowall = true;
  flgShowLabels = true;
  flgShowLabelBckGrnd = false;
  flgprocesdraw = true;

  //init the popup menu
  init_popupmenu();

  println("einde setup");
}

//vertaald de string type naar een type id 
int getTypeID(String type){
  if (type.equals(cPackage)) return cPackageID;
  if (type.equals(cPackageBody)) return cPackageID; //cPackageBodyID;
  if (type.equals(cProcedure)) return cProcedureID;
  if (type.equals(cFunction)) return cFunctionID;
  if (type.equals(cView)) return cViewID;
  if (type.equals(cType)) return cTypeID;
  if (type.equals(cTrigger)) return cTriggerID;
  if (type.equals(cMaterializedView)) return cMaterializedViewID;
  if (type.equals(cTable)) return cTableID;
  if (type.equals(cSequence)) return cSequenceID;
  return -1;
}

//vertaald de  type id naar een string  
String getTypeName(int type){
  if (type == cPackageBodyID) return cPackageBody;
  if (type == cProcedureID) return cProcedure;
  if (type == cFunctionID) return cFunction;
  if (type == cViewID) return cView;
  if (type == cPackageID) return cPackage;
  if (type == cTypeID) return cType;
  if (type == cTriggerID) return cTrigger;
  if (type == cMaterializedViewID) return cMaterializedView;
  if (type == cTableID) return cTable;
  if (type == cSequenceID) return cSequence;
  return "";
}



//filtert de types, true als types aan het filter voldoen.
boolean filter(String typeFrom,String typeTo ){
  if (typeFrom.equals(cPackageBody)) typeFrom =cPackage;
  if (typeTo.equals(cPackageBody)) typeTo =cPackage;
  return  activeStndFilter.contains('['+typeFrom+']') &&  activeStndFilter.contains('['+typeTo+']');
}

//filtert de types, true als types aan het filter voldoen.
boolean srchfilter(String nodetype ){
  if (activeSrchFilter.length() > 0) {
     return  activeSrchFilter.contains('['+nodetype+']');
  } else return true;
}

//filter de circular reference between package and package body out.
// returns true if there is no circular reference
boolean filterPackageRef(String pObjName,String pObjType,String pRefObjName,String pRefObjType){
  boolean packCircRef;
  packCircRef = pObjName.equals(pRefObjName) && getTypeID(pObjType)==getTypeID(pRefObjType);
  return !packCircRef;
}

/**
* loads the data from the datafile and creates the edges and nodes
* which pass the filter criteria.
**/
void loadData() {
println("loadData()");
Table table;
String objname, objtype,objnamecryp,refobjname,refobjtype,refobjnamecryp;
int fromObjtypeID, toObjtypeID, encrypcounter;
table = loadTable(dataFileName, "header, csv");
tablerows = table.getRowCount();
encrypcounter = 0;

  for (TableRow row : table.rows()) {
    
    objname = row.getString("NAME");
    objtype = row.getString("TYPE");
    refobjname = row.getString("REFERENCED_NAME");
    refobjtype = row.getString("REFERENCED_TYPE");
//  encrypt the node names
    objnamecryp    = type2memnonic.get(objtype) + String.valueOf(encrypcounter);
    encrypcounter++;
    refobjnamecryp = type2memnonic.get(refobjtype) + String.valueOf(encrypcounter);
    encrypcounter++;

//  check if the names should be encrypted
    //filter de objecttypes, indien voldoen dan opnemen in de graph
    if (filterPackageRef(objname,objtype,refobjname,refobjtype)){
        if (filter(objtype,refobjtype)) {
          fromObjtypeID = getTypeID(objtype);
          toObjtypeID = getTypeID(refobjtype);
          addEdge(objname,fromObjtypeID,objnamecryp, refobjname, toObjtypeID,refobjnamecryp); 
          println("addEdge(" + objname +","+ fromObjtypeID +"," + refobjname + "," + toObjtypeID + ")");
        } //if
    } //if
 }//for
 println("nodeCount: " + nodeCount);
 println("einde loadData()");
 //showlevels();
} //loaddata

//finds the min and max count of the number of relations of the nodes.
void find_minmaxrelcount(){
  nodeMinRelCount=Integer.MAX_VALUE;
  nodeToMinRelCount=Integer.MAX_VALUE;
  nodeMaxRelCount=0;
  nodeToMaxRelCount = 0;

  for (int i = 0; i < nodeCount; i++) {
    if (nodes[i].toNodeCount==0){
      //this node is a to node
      nodeMinRelCount= min(nodeMinRelCount,nodes[i].count);
      nodeMaxRelCount= max(nodeMaxRelCount,nodes[i].count);
    } else {
      //this node is a from node with to nodes
      nodeToMinRelCount= min(nodeToMinRelCount,nodes[i].toNodeCount);
      nodeToMaxRelCount= max(nodeToMaxRelCount,nodes[i].toNodeCount);
    } //if
     
  } //for
  //println("nodeToMaxRelCount: " + nodeToMinRelCount,"nodeToMaxRelCount: " + nodeToMaxRelCount);
}


void find_MinMaxNodeLevel() {
  nodeMinLevel = Integer.MAX_VALUE;
  nodeMaxLevel = 0;
  for (int i = 0; i < nodeCount; i++) {
    if (nodes[i].level > nodeMaxLevel) nodeMaxLevel = nodes[i].level;
    if (nodes[i].level < nodeMinLevel) nodeMinLevel = nodes[i].level;
  }
};

/**
* Determines the searchmode on the presence and position of the wildcard symbol
* @param psearch the text to search for in the label.
* @return the searchmodus or -1 if psearch is empty
*/
int getSearchMode(String psearch) {
  int searchmode, wildcardpos;
  if (psearch.length()>0) {
      searchmode = cNoWildCard;
      if (psearch.codePointAt(0) == '*') {
        searchmode=cLeftWildCard;
      }; 
      if (psearch.codePointAt(psearch.length()-1) == '*'){
        if (searchmode == cLeftWildCard) {
           searchmode=cLeftRightWildCard;
        } else searchmode=cRightWildCard;
      } 
  } else searchmode =-1;

  return searchmode;
  };
    

/**
*checks if the label of the nodes contains the searchtext
*and set the selected flg if so. The procedure knows 3 searchmodus.
*node label must be equal to the searchtext (<text>) default
*node label must start with the searchtext ( <text>* )
*node label must end with the serachtext ( *<text> )
* 
*@param psearch the text to search for in the label.
*/
void find_searchtekstInLabel(String psearch){
  int searchmode;
  boolean flgRightType, flgTxtFound;
  String searchTxt;
if (!psearch.isEmpty()){
  //determine the searchmode 
  searchmode = getSearchMode(psearch);
  searchTxt = trim(psearch.replace('*', ' ')); //<>//
  for (int i = 0; i < nodeCount; i++) {
//    println(nodes[i].label);

    flgRightType = srchfilter(getTypeName(nodes[i].objectTypeID));
    switch (searchmode){
    case cNoWildCard: flgTxtFound = nodes[i].label.equalsIgnoreCase(searchTxt); break;
    case cLeftWildCard: flgTxtFound = nodes[i].label.endsWith(searchTxt); break;
    case cRightWildCard: flgTxtFound = nodes[i].label.startsWith(searchTxt); break;
    case cLeftRightWildCard: flgTxtFound = nodes[i].label.contains(searchTxt); break;
    default: flgTxtFound = false; 
    }
     nodes[i].selected = flgRightType && flgTxtFound;
} //for
// set the selectionrelated for the nodes found
  SetSelectionRelatedNodes();
} else {
  //searchtext is empty so no selection 
  unSelectAll();
  flgshowall=true;
  flgshowselected=false;
}

}


//print alle levels van de nodes.
void showlevels(){
  for (int i = 0; i < nodeCount; i++) {
    println(nodes[i].label + " level: " + nodes[i].level);
  }
}

/**
* calulates the uniform string key from a numeric key value
**/
String strkey(int key){
  String strkey = str(key);
  return "00000".substring(strkey.length()) + strkey;  
}


void findFromBands(){
String tocount;
//populate the frombands dictionary
//key is the number of to nodes, the value the number of occurences 
  println("findFromBands()");

  frombands = new IntDict();
  
  for (int i = 0; i < nodeCount; i++) {
    if (nodes[i].toNodeCount > 0) { 
       tocount = strkey(nodes[i].toNodeCount);
       if (!frombands.hasKey(tocount)){
          frombands.set(tocount,0);
       }//if
       frombands.increment(tocount);
    } //if
  } //for
// sort the keys asc alfabetically
  frombands.sortKeys();
//calculate the min and max x coordinate of the band
int bandsize;
float banddx=0,x=0;
int weightedcount = getWeighedBandCount();
fromBandsMinx = new IntDict() ;
fromBandsMaxx = new IntDict() ;
String[] keys = frombands.keyArray();
 for (int i=0;i<keys.length;i++){
    bandsize = frombands.get(keys[i]) * Integer.parseInt(keys[i]);
    banddx = map(float(bandsize),0.0,float(weightedcount),0.0, float(cformwidth-cInfoPanelwidth));
    println(i,keys[i],banddx,x);
    fromBandsMinx.set(keys[i],int(cInfoPanelwidth+x));
    x = x + banddx;
    fromBandsMaxx.set(keys[i],int(cInfoPanelwidth + x));
 }
 println("eind findFromBands");
 };

void findLevelBands(){
String level;
//populate the levelbands dictionary
//key is the level of to nodes, the value the number of occurences 
  println("findLevelBands()");

  levelbands = new IntDict();
  
  for (int i = 0; i < nodeCount; i++) {
       level = strkey(nodes[i].level);
       if (!levelbands.hasKey(level)){
          levelbands.set(level,0);
       }//if
       levelbands.increment(level);
  } //for
// sort the keys asc alfabetically
  levelbands.sortKeys();
//
//calculate the min and max y coordinate of the band
//
int bandsize;
float banddy=0,y=cformheight;
int weightedcount = getWeighedLevelBandCount();
levelBandsMinx = new IntDict() ;
levelBandsMaxx = new IntDict() ;
String[] keys = levelbands.keyArray();
 for (int i=0;i<keys.length;i++){
    bandsize = levelbands.get(keys[i]); 
    banddy = map(float(bandsize),0.0,float(weightedcount),0.0, cformheight); //float(cFormLevelMax-cFormLevelMin));
//    println(i,keys[i],banddy,y);
    levelBandsMaxx.set(keys[i],int(y));
    y = y - banddy;
    levelBandsMinx.set(keys[i],int(y));
    println(keys[i],levelBandsMinx.get(keys[i]), levelBandsMaxx.get(keys[i]));
 }
 println("eind findLevelBands");
 };



void addEdge(String fromLabel,int fromObjectTypeID,String fromLabelcryp, String toLabel, int toObjectTypeID,String toLabelcryp) {

  // Zoek node, indien niet bestaat dan aanmaken.
  Node from = findNode(fromLabel,fromObjectTypeID,cFrom,fromLabelcryp);
  from.setType(fromObjectTypeID);
  
  Node to = findNode(toLabel,toObjectTypeID,cFrom,toLabelcryp);
  to.setType(toObjectTypeID);

  //zoek de edge en indien gevonden verhoog de gebruikteller en eindig de procedure
  //meerdere refs zijn nu mogelijk omdat package body = package
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      println("edge gevonden voor fromnode: " + from.label + ". to node: " +to.label);
      edges[i].increment();
      return;
    }
  } 
//geen edge gevonden dus toevoegen  
  
  
  //check and set the biggestfrom node
  if (to.biggestfrom == null) to.biggestfrom = from;
  else
    if (from.count > to.biggestfrom.count ) to.biggestfrom = from;
  
  //add the 'to' node to the from node list
  from.addToNode(to);
  //add the 'from' node to the to node list
  to.addFromNode(from);
  
  //increment the link count of the nodes
  from.increment();
  to.increment();
  
  //zoek de edge en indien gevonden verhoog de gebruikteller en eindig de procedure
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      edges[i].increment();
      return;
    }
  } 
//geen edge gevonden dus toevoegen  
  Edge e = new Edge(from, to);
  e.increment();
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
  
  
  //bepaal het level van de to en de from nodes
  //behandel geval 2 nieuwe nodes.
  if (to.level == 0  && from.level==0) {from.setLevel(1);  from.incLevel(0, new StringList(from.label));}
  else { // to node behoort tot een bestaande tak
         if (to.level >= from.level){
             from.incLevel(to.level, new StringList(from.label));
         }
  }
  //if (from.level >1 || to.level>1) println("From: " + from.label +", level: "+ from.level +", to: " + to.label + ", level: " + to.level);
}



Node findNode(String label, int type, String pdir, String namecryp) {
  label = label.toLowerCase();
  Node n = (Node) nodeTable.get("["+label+Integer.toString(type)+pdir+"]");
  if (n == null) {
    return addNode(label,type,pdir,namecryp);
  }
  return n;
}


Node addNode(String label,int type,String pdir,String pnamecryp) {
  Node n = new Node(label);
  n.objectTypeID = type;
  n.labelencrypt = pnamecryp; 
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put("["+label+Integer.toString(type)+pdir+"]", n);
  nodes[nodeCount++] = n;  
  println("addNode("+ n.label+ ","+ type + pdir+")" + "nodeCount: " + nodeCount);
  return n;
}

int getWeighedBandCount(){
  int result=0;
  String[] keys = frombands.keyArray();
  int[] vals = frombands.valueArray();
   for (int i=0;i<frombands.size();i++){
      //println(i,keys[i],vals[i]);
      result = result + vals[i] * Integer.parseInt(keys[i]);
   }
 return result;
}

int getWeighedLevelBandCount(){
  int result=0;
  String[] keys = levelbands.keyArray();
  int[] vals = levelbands.valueArray();
   for (int i=0;i<levelbands.size();i++){
      //println(i,keys[i],vals[i]);
      result = result + vals[i]; // * Integer.parseInt(keys[i]);
   }
 return result;
}


void drawFrombands(){
float banddx=0;
stroke(0,0,0);
String[] keys = frombands.keyArray();
for (int i=0; i<keys.length; i++){
    fill(204,102,0,(100 *i)/keys.length); //orange i> dan kleur lichter
    banddx = float( fromBandsMaxx.get(keys[i]) - fromBandsMinx.get(keys[i]));
    rect(fromBandsMinx.get(keys[i]),0, banddx,cformheight);
 }
}

void drawLevelbands(){
float banddy=0;
int recwidth = cformwidth - cInfoPanelwidth ;

stroke(0,0,0);
String[] keys = levelbands.keyArray();
for (int i=0; i<keys.length; i++){
    fill(204,102,0,(100 *(i+1))/keys.length); //orange i> dan kleur lichter
    banddy = float( levelBandsMaxx.get(keys[i]) - levelBandsMinx.get(keys[i]));
    rect(cInfoPanelwidth,levelBandsMinx.get(keys[i]), recwidth, banddy);
 }
}

/**
* draws the infopanel at the left on the screen.
*/
void drawInfoPanel(){
//background for the panel
   stroke(0);
   fill(153);
   rect(0,0,cInfoPanelwidth,cformheight);
// filename
   fill(0);
   textAlign(LEFT);
   text("Filename:",5,30);
   fill(255,255,255);
   text(dataFileName,5,40);
//rowcount   
   fill(0);
   text("Rowcount:",5,55);
   fill(255,255,255);
   text(tablerows,5,65);
//nr nodes
   fill(0);
   text("Nr. of nodes:",5,80);
   fill(255,255,255);
   text(nodeCount,5,90);
//nr relations
   fill(0);
   text("Nr. of relations:",5,105);
   fill(255,255,255);
   text(edgeCount,5,115);
//min node relations
   fill(0);
   text("Min Node relations:",5,130);
   fill(255,255,255);
   text(nodeMinRelCount,5,140);
//max node relations
   fill(0);
   text("Max Node relations:",5,155);
   fill(255,255,255);
   text(nodeMaxRelCount,5,165);
//selected node info
   fill(0);
   text ("Selected node:",5,180);
   if (selection != null) {
     fill(0);
     text("Label:",5,195);
     fill(255,255,255);
     text(selection.label,5,205);
     
     fill(0);
     text("Objecttype:",5,220);
     fill(255,255,255);
     text( getTypeName(selection.objectTypeID),5,230);

     fill(0);
     text("Nr. relations:",5,245);
     fill(255,255,255);
     text( selection.count,5,255);

     fill(0);
     text("Level:",5,270);
     fill(255,255,255);
     text( selection.level,5,280);
     
   } else {
       fill(153);
       stroke(153);
       rect(5,195,cInfoPanelwidth-5,100);
   };
//show search tekst
  stroke(0);
  fill(255);
  rect(0,319,cInfoPanelwidth,26);
  fill(128,128,128);
  textAlign(LEFT, CENTER);
  if (searchtekst=="") text("Type to search", 3, 331);
  else {fill(0,0,0); text(searchtekst, 3, 331);}

  textAlign(LEFT, BASELINE);
// to and from legenda background
  noStroke();
  fill(255);
  rect(0,350,cInfoPanelwidth,15);
  fill(0,64,64,25.0);
  rect(0,350,cInfoPanelwidth,15);

  fill(255);
  rect(0,470,cInfoPanelwidth,15);
  fill(0,64,64,50.0);
  rect(0,470,cInfoPanelwidth,15);
//to and from legenda text
  fill(0);
  text("Type filter: ",5,362);
  fill(255,255,255);
  text(activeStndFilter.replace("][","]\n["),5,362,cInfoPanelwidth-5,135);
  fill(0);
  text("Search type filter: " ,5,482);
  fill(255,255,255);
  text(activeSrchFilter.replace("][","]\n["),5,482,cInfoPanelwidth-5,135);


//display legenda
  fill(0);
//  String legenda = "f - freeze/unfreeze\ns - show all or show only selected relation\nh - show all or show only selection\nu - unselect all\n0-9 select filter.";
//  String legenda = "ctrl-f: freeze/unfreeze\nctrl-s: show all or show only selected relation\nctrl-h: show all or show only selection\nctrl-u: unselect all\nctrl-0..9: select filter\nctrl-t: toggle text\nctrl-b: show label background.";
    String legenda = "alt-i: show legenda.";
  text(legenda,5,300,cInfoPanelwidth-5, 155);

  
};


/**
* draws the screen
*/
void draw() {
  //if (record) {
  //  beginRecord(PDF, "output.pdf");
  //}
//paint Infopanel and the to and from background
  background(255);
  drawInfoPanel();
//paint Infopanel and the to and from background
  fill(0,64,64,25.0);
  rect(cInfoPanelwidth,0,width-cInfoPanelwidth,height);
  //fill(0,64,64,50.0);
  //rect(cInfoPanelwidth,cHierFromMax,width-cInfoPanelwidth,height);
  textFont(font);  
  smooth();
  
  if (flgprocesdraw) {
     // drawFrombands();
      drawLevelbands();      
      for (int i = 0 ; i < edgeCount ; i++) {
    //    edges[i].relax();
    //    edges[i].relaxband();
        edges[i].relaxhierarchical();
    }
      for (int i = 0; i < nodeCount; i++) {
      nodes[i].relax();
      }
      for (int i = 0; i < nodeCount; i++) {
       nodes[i].update();
      }
      for (int i = 0 ; i < edgeCount ; i++) {
        edges[i].draw();
      }
      for (int i = 0 ; i < nodeCount ; i++) {
        nodes[i].draw();
      }
  } //if
  
  //if (record) {
  //  endRecord();
  //  record = false;
  //}
}

void freeze(boolean flgfreeze){
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].fixed=flgfreeze;
  }
}

void unSelectAll(){
  for (int i = 0; i < nodeCount; i++) {
      nodes[i].selected = false;
  }
}


//set hide property of a node.
//hide it when not connected to a selected node.
void SetSelectionRelatedNodes(){
  //reset flag for all nodes
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].SelectionRelated=false;
  }
  
  //set flag for the nodes in the selection
  for (int i = 0 ; i < edgeCount ; i++) {
    if (edges[i].to.selected){
        edges[i].to.SelectionRelated = false;
        edges[i].from.SelectionRelated = true;
    }
    if (edges[i].from.selected){
        edges[i].to.SelectionRelated = true;
        edges[i].from.SelectionRelated = false;
    }
  }
}


 void handleCtrlKeyOpties(int pkeyCode){
   String filteritem;
   if (pkeyCode==(int)char('F')){
      flgfreeze = !flgfreeze;
      freeze(flgfreeze);
    }
    if (pkeyCode==(int)char('S')){
      flgshowselected = !flgshowselected;
      flgshowall = !flgshowselected;
    }
    if (pkeyCode==(int)char('H')){
      flgshowall = !flgshowall;
    }
    if (pkeyCode==(int)char('U')){
       unSelectAll();
       searchtekst = "";
       selection = null;
       flgsearchmode=false;
       flgshowall=true;
       flgshowselected=false;
    }
    if (pkeyCode==(int)char('B')) flgShowLabelBckGrnd = !flgShowLabelBckGrnd;
    if (pkeyCode==(int)char('T')) flgShowLabels = !flgShowLabels;
    if (pkeyCode==(int)char('G')) {
        flglogscale = !flglogscale;
        setup();
    }
    if (pkeyCode==(int)char('E')) {
        flgencrypt = !flgencrypt;
    }
    //handle function keys
    if (pkeyCode==KeyEvent.VK_F1) { 
    filteritem = "["+cProcedure+"]";
    flgCtrlF1toggle = !flgCtrlF1toggle;
    adjustStndFilter(filteritem,flgCtrlF1toggle);
    setup();
    }
    else if (pkeyCode==KeyEvent.VK_F2) {
      filteritem = "["+cFunction+"]";
      flgCtrlF2toggle = !flgCtrlF2toggle;
      adjustStndFilter(filteritem,flgCtrlF2toggle);
      setup();
    }
    else if (pkeyCode==KeyEvent.VK_F3) {
      filteritem = "["+cPackage+"]";
      flgCtrlF3toggle = !flgCtrlF3toggle;
      adjustStndFilter(filteritem,flgCtrlF3toggle);
      setup();
    }
    else if (pkeyCode==KeyEvent.VK_F5) {
      filteritem = "["+cTrigger+"]";
      flgCtrlF5toggle = !flgCtrlF5toggle;
      adjustStndFilter(filteritem,flgCtrlF5toggle);
      setup();
    }
    else if (pkeyCode==KeyEvent.VK_F6) {
      filteritem = "["+cTable+"]";
      flgCtrlF6toggle = !flgCtrlF6toggle;
      adjustStndFilter(filteritem,flgCtrlF6toggle);
      setup();
    }
    else if (pkeyCode==KeyEvent.VK_F7) {
      filteritem = "["+cSequence+"]";
      flgCtrlF7toggle = !flgCtrlF7toggle;
      adjustStndFilter(filteritem,flgCtrlF7toggle);
      setup();
    }
    //handle text keystroke
    if (pkeyCode >= 48 && pkeyCode <= 57) {
      filterindex = pkeyCode - 48;
      activeStndFilter = stndfilters[filterindex];
      setup();
    }
 };

void adjustSrchFilter(String pfilteritem, boolean pflgactive){
if (pflgactive) activeSrchFilter = activeSrchFilter + pfilteritem;
else activeSrchFilter = activeSrchFilter.replace(pfilteritem,"");
}


void adjustStndFilter(String pfilteritem, boolean pflgactive){
 if (pflgactive) activeStndFilter = activeStndFilter + pfilteritem;
 else activeStndFilter = activeStndFilter.replace(pfilteritem,"");
}


void handleAltKeyOpties(int pkeyCode){
  String filteritem;
  String filename;
  if (pkeyCode== (int)char('I')) {handleLegendDialog();flgaltkey=false;}
  if (pkeyCode==(int)char('S')) {
    cursor(WAIT);
    Toolkit.getDefaultToolkit().beep();
    filename = "." +cImageDir +"/"+ dataFileName.substring(0,dataFileName.length()-4) + Integer.toString(frameCount) + ".png";  
    save(filename);
    cursor(ARROW);
  }
  if (pkeyCode== (int)char('F')) {
     flgaltkey=false;
     //open filedialog and on ok there is a new file choosen.
     if (handleFileOpenDialog()==JFileChooser.APPROVE_OPTION) setup();
  }
  if (pkeyCode==KeyEvent.VK_F1) {  //<>//
    filteritem = "["+cProcedure+"]";
    flgAltF1toggle = !flgAltF1toggle;
    adjustSrchFilter(filteritem,flgAltF1toggle);
   find_searchtekstInLabel(searchtekst);
  }
  else if (pkeyCode==KeyEvent.VK_F2) {
    filteritem = "["+cFunction+"]";
    flgAltF2toggle = !flgAltF2toggle;
    adjustSrchFilter(filteritem,flgAltF2toggle);
    find_searchtekstInLabel(searchtekst);
  }
  else if (pkeyCode==KeyEvent.VK_F3) {
    filteritem = "["+cPackage+"]";
    flgAltF3toggle = !flgAltF3toggle;
    adjustSrchFilter(filteritem,flgAltF3toggle);
    find_searchtekstInLabel(searchtekst);
  }
  else if (pkeyCode==KeyEvent.VK_F5) {
    filteritem = "["+cTrigger+"]";
    flgAltF5toggle = !flgAltF5toggle;
    adjustSrchFilter(filteritem,flgAltF5toggle);
    find_searchtekstInLabel(searchtekst);
  }
  else if (pkeyCode==KeyEvent.VK_F6) {
    filteritem = "["+cTable+"]";
    flgAltF6toggle = !flgAltF6toggle;
    adjustSrchFilter(filteritem,flgAltF6toggle);
    find_searchtekstInLabel(searchtekst);
   }
  else if (pkeyCode==KeyEvent.VK_F7) {
    filteritem = "["+cSequence+"]";
    flgAltF7toggle = !flgAltF7toggle;
    adjustSrchFilter(filteritem,flgAltF7toggle);
    find_searchtekstInLabel(searchtekst);
   }
};

void handleTextKey(int pkeyCode){
     if (pkeyCode==8) {if (!searchtekst.isEmpty()) {searchtekst=searchtekst.substring(0,searchtekst.length()-1);};}
     else { if (pkeyCode >= 45) searchtekst+= key;}
     flgsearchmode = (searchtekst.length()>0);
     find_searchtekstInLabel(searchtekst);
};


/**
* This procedure opens the legenda window.
**/
void handleLegendDialog(){
  Legenda lgdnd = new Legenda();
  lgdnd.setVisible(true);
  //JOptionPane.showMessageDialog(frame, "Eggs are not supposed to be green.");
}

/**
* This procedure opens the file choose dialog and updates the
* datafilename var with the selected filename.
**/
int handleFileOpenDialog(){
//Create a file chooser
final JFileChooser fc = new JFileChooser();

fc.setCurrentDirectory(new File( this.sketchPath() + "\\data"));
int returnVal = fc.showOpenDialog(null);

if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();
    dataFileName = file.getName();
   } //if
   return returnVal;
}



boolean record;

void keyPressed() {
//  int keyvalue = int(key);
    //println("key: " + key );
    //println("keycode" + keyCode);

  switch (keyCode){
  case CONTROL: flgcntrlkey =true;break; 
  case ALT: flgaltkey =true;break;
  default: { if (flgcntrlkey) handleCtrlKeyOpties(keyCode);
             else if (flgaltkey) handleAltKeyOpties(keyCode);
                  else handleTextKey(keyCode);
           } //end default
  }; //end switch
}; //end keypressed
  

 
void keyReleased(){
  if (keyCode==CONTROL) flgcntrlkey =false;
  if (keyCode== ALT) flgaltkey= false;
}

/**
* handel de rechtermuis popupmenu af.
**/
void procesmenuItem(int modifier,int pkeycode){
  //proces modifier
  switch (modifier){
  case CONTROL: {flgcntrlkey =true;
                 handleCtrlKeyOpties(pkeycode);
                 flgcntrlkey =false;
                 break; 
                }
  case ALT: {flgaltkey =true;
             handleAltKeyOpties(pkeycode);
             flgaltkey =false;
             break;
            }
  default: handleTextKey(keyCode);
  }
}



void mousePressed() {
  // Ignore anything greater than this distance
  float closest = 20;
  for (int i = 0; i < nodeCount; i++) {
    Node n = nodes[i];
    float d = dist(mouseX, mouseY, n.x, n.y);
    if (d < closest) {
      selection = n;
      closest = d;
    }
  }
  // if the ctrl key is pressed dont set the selected flag the node is just dragged.
    if (mouseButton == LEFT && (!flgsearchmode || (flgsearchmode && selection.SelectionRelated ))) {      //&& selection.SelectionRelated
      if (selection != null && !flgcntrlkey) {
          selection.fixed = true;
          selection.selected = !selection.selected;
          SetSelectionRelatedNodes();
      }
    } else if (mouseButton == RIGHT) {
          //selection.fixed = false;
          println("rmouse button clicked");
          if (canvas != null)  popup.show(canvas.getComponentAt(0,0),mouseX,mouseY);
    }
}


void mouseDragged() {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
  }
}


void mouseReleased() {
  //selection = null;
}