/********************
  Représente une cellule dans une matrice
  
********************/
class Cell {
  // Positions et dimension visuelles
  int x; 
  int y;
  int w;
  int h;
  
  // Position matricielle
  int i;
  int j;
  
  color fillColor;
  
  int pulseInterval = 0;
  int pulseAcc = 0;
  
  float alphaInc = 0;
  int currentAlpha = 255;
  
  Cell (int _x, int _y) {
    init (_x, _y, 50, 50);
  }
  
  Cell (int _x, int _y, int _w, int _h) {
    init (_x, _y, _w, _h);
  }
  
  void init(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    
    fillColor = color (random (255), random (255), random (255));
    
  }
  
  void setFillColor (color c) {
    fillColor = c;
    memFillColor = c; 
  }
    
  void setPulseInterval (int interval) {
    pulseInterval = interval;
    
    if (pulseInterval > 0) {
      alphaInc = (pulseInterval * 1.0) / 256.0;
    } else {
      alphaInc = 0;
    }
  }
  
  // Retourne un string avec la couleur RGB en format "R G B"
  String toStringAs3bpp() {
    return int(red (fillColor)) + " " + int(green (fillColor)) + " " + int(blue (fillColor));
  }
  
  // Retourne un string avec la couleur int en format "valeur"
  String toStringAs1bpp() {
    return "" + fillColor;
  }
 
  color getFillColor() {
    return fillColor;
  }
  
  // Permet d'afficher la cellule
  void display () {
    pushMatrix();
      translate (x, y);
      fill (fillColor);
      alpha(currentAlpha);
      stroke (0);
      rect (0, 0, w, h);
    popMatrix();
  }
  
  color memFillColor; 
  
  void update(float delta) {
 //<>//
  }
  
}
