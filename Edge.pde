// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.

class Edge {
  
  static final int cGoalLen = 50; 
  static final int cRestLen = 0; 
  static final int cRestDistfrom = 20; 
  Node from;
  Node to;
  float len;
  int count;


  Edge(Node from, Node to) {
    this.from = from;
    this.to = to;
    this.len = cGoalLen;
  }
  
  
  void increment() {
    count++;
  }
  
  
  void relax() {
    float vx = to.x - from.x;
    float vy = to.y - from.y;
    float d = mag(vx, vy);
    if (d > cRestLen) {
      
      float f = (len - d) / (d * 3);
      float dx = f * vx;
      float dy = f * vy;
      to.dx += dx;
      to.dy += dy;
      from.dx -= dx;
      from.dy -= dy;
    }
  }

// relax objecten to their own band.each objecttype has its horizontal line in the graph.
//
  void relaxband() {
    float vyto = bandypos[to.objectTypeID] - to.y ;
    float vyfrom = bandypos[from.objectTypeID] - from.y;
    if (abs(vyto) > cRestLen) {
      float f = vyto / (vyto * 10);
      float dy = f * vyto;
      to.dy += dy;
    } else to.dy = 0;
    if (abs(vyfrom) > cRestLen) {
      float f = vyfrom / (vyfrom * 10);
      float dy = f * vyfrom;
      from.dy += dy;
    } else from.dy = 0;
  }

//relax hierarchical based on the number of relations. most relations are positioned downwards. 
//the from object are positioned up and the lower half of the screen. 
  void relaxhierarchical(){
    int nodepos;
    float vyto=0,vyfrom=0;
// bereken de positie van een node vanaf zijn level
// notitie: map geeft NaN als de eerste 3 parameters 1 zijn.
    //float hierposfrom,hierposto;
    //nodepos = nodeMaxLevel-from.level;
    //if (from.level==1 && nodeMinLevel==1 && nodeMaxLevel==1) hierposfrom = cFormLevelMin;
    //else hierposfrom = map(nodepos, nodeMinLevel, nodeMaxLevel, cFormLevelMin, cFormLevelMax );

    //nodepos = nodeMaxLevel-to.level;
    //if (to.level==1 && nodeMinLevel==1 && nodeMaxLevel==1) hierposto = cFormLevelMin;
    //else hierposto = map(nodepos, nodeMinLevel, nodeMaxLevel, cFormLevelMin, cFormLevelMax );

    //vyto = hierposto - to.y ;
    //vyfrom = hierposfrom - from.y;

  nodepos = from.level;

//bereken in welke level band een node valt.
  float vertposminfrom = levelBandsMinx.get(strkey(nodepos));  //   from.count 
  float vertposmaxfrom = levelBandsMaxx.get(strkey(nodepos));  // from.count 
  //controleer of de node zich binnen de band bevind
  if (from.y >= vertposminfrom && from.y <= vertposmaxfrom) {
     vyfrom=0;
  }  else {
           if  (from.y < vertposmaxfrom) vyfrom = vertposmaxfrom - from.y;
           else if (from.y > vertposminfrom) vyfrom = vertposminfrom - from.y;
  }
  nodepos = to.level;
  float vertposminto = levelBandsMinx.get(strkey(nodepos));  //   from.count 
  float vertposmaxto = levelBandsMaxx.get(strkey(nodepos));  // from.count 
  //controleer of de node zich binnen de band bevind
  if (to.y >= vertposminto && to.y <= vertposmaxto) {
     vyto=0;
  }  else {
          if  (to.y < vertposmaxto) vyto = vertposmaxto - to.y;
          else if (to.y > vertposminto) vyto = vertposminto - to.y;
  }
  

  if (abs(vyto) > cRestLen) {
    float f = vyto / (vyto * 10);
    float dy = f * vyto;
    to.dy += dy;
  } else to.dy = 0;
  if (abs(vyfrom) > cRestLen) {
    float f = vyfrom / (vyfrom * 10);
    float dy = f * vyfrom;
    from.dy += dy;
  } else from.dy = 0;




//  position the to nodes left or right to the from node 
//  test if the to.x lays between xminto en xmaxto then the position is ok.
  //if (to.x < to.biggestfrom.xminto || to.x > to.biggestfrom.xmaxto){
  //    if  (to.x < to.biggestfrom.xminto) vxto = to.biggestfrom.xminto - to.x;
  //    else vxto = to.biggestfrom.xmaxto - to.x;
       
  //    if (abs(vxto) > 0) {
  //      float f = vxto / (vxto * 10);
  //      float dx = f * vxto;
  //      to.dx += dx;
  //    } else to.dx = 0;
  //} else to.dx = 0;


    

//// position the to nodes below the biggest from node 
//float vxto = to.biggestfrom.x - to.x;
//if (abs(vxto) > cRestDistTo) {
// float f = vxto / (vxto * 30);
// float dx = f * vxto;
// to.dx += dx;
//} else to.dx = 0;


//  position the from nodes in the centre of the to nodes.
float xc = from.xcentreto;
float vxfrom = xc - from.x;
if (abs(vxfrom) > cRestDistfrom) {
float f = vxfrom / (vxfrom * 30);
float dx = f * vxfrom;
from.dx += dx;
} else from.dx = 0;

////move the from nodes from left to right, low count left high count right.
// float horizonposminfrom = fromBandsMinx.get(strkey(from.toNodeCount));  //   from.count 
// float horizonposmaxfrom = fromBandsMaxx.get(strkey(from.toNodeCount));  // from.count 
// float vxhorfrom = 0 ;
// if  (from.x < horizonposminfrom) vxhorfrom = horizonposminfrom - from.x;
// else if (from.x > horizonposmaxfrom) vxhorfrom = horizonposmaxfrom - from.x;
  
// if (abs(vxhorfrom) > 0) {
//  float f = vxhorfrom / (vxhorfrom * 10);
//  float dx = f * vxhorfrom;
//  from.dx += dx;
// } ;
    
    
////  calculate the new tody if the position is not within the marge
//    if (abs(vyto) > cRestLen) {
//      float f = vyto / (vyto * 30);
//      float dy = f * vyto;
//      to.dy += dy;
//    } else to.dy = 0;
////  calculate the new fromdy if the position is not within the marge
//    if (abs(vyfrom) > cRestLen) {
//      float f = vyfrom / (vyfrom * 30);
//      float dy = f * vyfrom;
//      from.dy += dy;
//    } else from.dy = 0;
     
  }
  
  void draw() {
    float dx,dy;
    if (to.selected || from.selected) {
      stroke(selectColor);
    } else {
      stroke(edgeColor);
    }
    strokeWeight(0.35);
    if (flgshowselected){
      if (to.selected || from.selected) {
        //show an arrow, a very small triangle
//         line(from.x, from.y, to.x, to.y);
         fill(selectColor);
         dx = Math.signum(from.x - to.x);
         dy = Math.signum(from.y - to.y);
         if (dx==0 || dy==0) triangle(from.x-dy, from.y-dx, from.x+dy,from.y+dx, to.x, to.y);
         else if (dx==dy)    triangle(from.x-1, from.y+1, from.x+1,from.y-1, to.x, to.y);        
              else           triangle(from.x-1, from.y-1, from.x+1,from.y+1, to.x, to.y);
      } 
    } else {
      line(from.x, from.y, to.x, to.y);
    }
  }
}