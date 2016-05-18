// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.


class Node {
  float x, y;
  float dx, dy;
  boolean fixed=false;
  boolean selected = false;
  boolean SelectionRelated=false;
  String label;
  int objectTypeID;
  int count,toNodeCount,fromNodeCount;
  int level;
  Node biggestfrom=null;
  Node[] toNodes = new Node[1];
  Node[] fromNodes = new Node[1];
  
  float xminto, xmaxto, xcentreto;

  static final int cDistTo = cRestDistTo + 10; // + the margin 

  Node(String label) {
    this.label = label;
    x = cInfoPanelwidth + random(cformwidth-cInfoPanelwidth);
    y = random(cformheight);
    fixed=false;
    count=0; toNodeCount=0;xminto=x-cRestDistTo; xmaxto=x+cRestDistTo; xcentreto=x;
    level=0; fromNodeCount=0;
  }
  

  void addToNode(Node ptonode) {
    if (toNodeCount == toNodes.length) {
      toNodes = (Node[]) expand(toNodes);
    }
    toNodes[toNodeCount] = ptonode;
    toNodeCount++;
  }

  void addFromNode(Node pfromnode) {
    if (fromNodeCount == fromNodes.length) {
      fromNodes = (Node[]) expand(fromNodes);
    }
    fromNodes[fromNodeCount] = pfromnode;
    fromNodeCount++;
  }

// increments the level of this node and recursive calls all the from nodes of this node
// to increment their level also.
//@param plevel het startlevel
//@param callist de lijst met calling nodes, om recursive loops te voorkomen.
  void incLevel(int plevel, StringList callist){
    if (fromNodeCount>0) {
      println("fromNodeCount>0");
      this.level = ++plevel;
      println("node:" + label + "level: " +level);
      //loop alle from nodes to adjust the level.
      for (int i=0; i< fromNodeCount; i++) {
        //check if node is already in the callist
        if (!callist.hasValue(fromNodes[i].label)) {
            //add this node to the callist
            callist.append(fromNodes[i].label);
            //increment teh levels of all callers of this node.
            fromNodes[i].incLevel(this.level, callist);
        }
    }
    } else {
            this.level = ++plevel;
      }
  }
  
  void setLevel(int plevel){
    this.level = plevel;
  }
  
  void calcToProperties(){
    float xmin= xminto, xmax=xmaxto, xmint = Integer.MAX_VALUE, xmaxt=0;
    int nodecount=0;
    if (toNodeCount>1) {
      //check if the are to nodes with in the marge , if so calculate the min and max x again.
      for (int i=0;  i < toNodeCount; i++){
        //calc the min and max pos of all the to nodes.
        xmint = min(xmint,toNodes[i].x);
        xmaxt = max(xmaxt,toNodes[i].x);
        //check for nodes that are not within the xmin,xmax marge
        if (toNodes[i].x >= xmin || toNodes[i].x <= xmax ) nodecount++;
      } //for
      //determine if the min en max coordinaten should be adjusted.
      //if the range has enough nodes in it then enlarge the min max range by cRestDistTo
      if (nodecount >= (xmax-xmin)/cRestDistTo) {
         xmin = xmin - cDistTo;
         xmax = xmax + cDistTo;
      }
      //calculate the centre of the to nodes
      xcentreto = xmint + (xmaxt-xmint)/2;
      xminto = xmin; xmaxto = xmax;
    } else {
        if (toNodeCount==1) {
           xminto=x; xmaxto=x; 
           xcentreto=toNodes[0].x;
        }
    } //if
  }
  
  
  void increment() {
    count++;
  }
  
  void setType(int type){
      objectTypeID = type;
  }
  
  void relax() {
    float ddx = 0;
    float ddy = 0;

    for (int j = 0; j < nodeCount; j++) {
      Node n = nodes[j];
      if (n != this && (n.objectTypeID == this.objectTypeID)      ) {
        float vx = x - n.x;
        float vy = y - n.y;
        float lensq = vx * vx + vy * vy;
        if (lensq == 0) {
          ddx += random(2);
          ddy += random(2);
        } else if (lensq < 50*100){
          ddx += vx / lensq;
          ddy += vy / lensq;
        }
      }
    }
    float dlen = mag(ddx, ddy) / 2;
    if (dlen > 0) {
      dx += ddx / dlen;
      dy += ddy / dlen;
    }
  }


  void update() {
    if (!fixed) {      
      x += constrain(dx, -5, 5);
      y += constrain(dy, -5, 5);
      
      x = constrain(x, cInfoPanelwidth + cFormPadding, cformwidth - cFormPadding);
      y = constrain(y, cHierFromMin, cHierToMax);
    }
    dx /= 2;
    dy /= 2;
    //update the to properties if this is a from node.
    if (toNodeCount > 0 ) calcToProperties();
  }


  void draw() {
    String txtlabel;
    float labelwidth;
    //show selected nodes(not hiden) or all nodes
    if (flgshowall || SelectionRelated  || selected) {
        fill(nodecolor[objectTypeID]);
        stroke(0);
        strokeWeight(0.5);
        if (flglogscale)  ellipse(x, y, log(count), log(count));
        else  ellipse(x, y, count, count);
    //    float w = textWidth(label);
    
        if (flgShowLabels || selected)  {
          fill(0);
          textAlign(LEFT, TOP);
          
          if (toNodeCount>0){
              txtlabel = label+"("+toNodeCount+")"; 
              labelwidth = textWidth(txtlabel);
            } else {
                txtlabel = label+"("+count+")";
                labelwidth = textWidth(txtlabel);
              }
           if (flgShowLabelBckGrnd) {
              if (selected) fill(255,255,255); else fill(192,192,192);
              rect(x,y,labelwidth,16);
           }
           fill(0,0,0); text(txtlabel, x, y);
           
        };  
        image(icons[objectTypeID],x,y+10);
        
    }
  }
}