/********************
  Représente une matrice de cellules
  
********************/
abstract class Matrix {
  int x;
  int y;
  int cols;
  int rows;
  
  int cellWidth;
  int cellHeight;
  
  int h, w;
  
  ArrayList<ArrayList<Cell>> cells;
  
  color baseColor = color (0, 127, 0);
  
  int bytePerPixel = 3;
  
  Matrix (int nbRows, int nbColumns) {
    x = 0;
    y = 0;
    
    cols = nbColumns;
    rows = nbRows;
    
    cellWidth = width / cols;
    cellHeight = height / rows;
    
    init();
  }      
  
  Matrix (int nbRows, int nbColumns, int bpp) {
    x = 0;
    y = 0;
    
    cols = nbColumns;
    rows = nbRows;
    bytePerPixel = bpp;
    
    cellWidth = width / cols;
    cellHeight = height / rows;
    
    
    init();
  }
  
  Matrix (int nbRows, int nbColumns, int bpp, int width, int height) {
    x = 0;
    y = 0;
    
    cols = nbColumns;
    rows = nbRows;
    bytePerPixel = bpp;
    
    this.h = height;
    this.w = width;
    
    cellWidth = this.w / cols;
    cellHeight = this.h / rows;
    
    
    init();
  }
  
  Matrix (int nbRows, int nbColumns, int width, int height) {
    x = 0;
    y = 0;
    
    cols = nbColumns;
    rows = nbRows;
    
    this.h = height;
    this.w = width;
    
    cellWidth = this.w / cols;
    cellHeight = this.h / rows;
    
    
    init();
  }
  
  abstract protected void init();
  
  void displayRow (int j) {
    ArrayList<Cell> row = cells.get(j);
    
    for (int i = 0; i < row.size(); i++) {
      Cell current = row.get(i);
      current.display();       
    }
  }
  
  void display () {
    for (int j = 0; j < cells.size(); j++) {
      displayRow(j);
    }
  }
  
  void randomize() {
    for (int j = 0; j < cells.size(); j++) {
      for (int i = 0; i < cells.get(j).size(); i++) {
        Cell current = cells.get(j).get(i);
        
        current.setFillColor(color (random(255), random(255), random(255)));
      }
    }
  }
  
  void setCellColor (int i, int j, color c) {
    cells.get(j).get(i).setFillColor(c);
  }
  
  void update (float delta) {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        cells.get(j).get(i).update(delta);
      }
    }
  }
  
  // Met à jour les couleurs des cellules
  void update (String data) {
    String rawData[] = data.split(" ");
    
    int currentStep = 0; 
    int currentIndex = 0;
        
    for (int j = 0; j < rows; j++) {
      
      currentStep = j * cols;
      
      for (int i = 0; i < cols; i++) {
        
        currentIndex = (currentStep + i) * bytePerPixel;
        
        if (bytePerPixel == 3) {
                    
          int R = int(rawData [currentIndex]);
          int G = int(rawData [currentIndex + 1]);
          int B = int(rawData [currentIndex + 2]);
          
          this.setCellColor(i, j, color (R, G, B));
                                                   
                                        
        } else {
          
          this.setCellColor(i, j, color (parseInt(rawData [currentIndex])));
        }
        
      }
    }
  }
  
  // Met à jour les couleurs des cellules
  void update (byte [] data) {
    int nbValues = data.length;
    
    if (nbValues >= cols * rows) {
      for (int j = 0; j < rows; j++) {
      
        for (int i = 0; i < cols; i++) {

          
          if (bytePerPixel == 3) {
            int r = data[j * cols + i++] & 0xFF;
            int g = data[j * cols + i++] & 0xFF;
            int b = data[j * cols + i] & 0xFF;
            
            this.setCellColor(i, j, color (r, g, b));
          } else {
            int currentIndex = j * cols + i;
            color c = data[currentIndex] & 0xFF;
            
            this.setCellColor(i, j, color (c));
          }
        }
      }
    }
  }
  
  void clear () {
    clear (color (0));
  }
  
  void clear (color c) {
    for (int j = 0; j < cells.size(); j++) {
      for (int i = 0; i < cells.get(j).size(); i++) {
        Cell current = cells.get(j).get(i);
        
        current.setFillColor(c);
      }
    }
  }
  
  int getCellColFromMouse(int x) {
    return int(float(x) / cellWidth);
  }
  
  int getCellRowFromMouse(int y) {
    return int(float(y) / cellHeight);
  }
  
  /**
    Retourne les donnees en format valeur separee par des espaces.
  */
  String toString() {
    String result = "";
    
    for (int j = 0; j < cells.size(); j++) {
      for (int i = 0; i < cells.get(j).size(); i++) {
        Cell current = cells.get(j).get(i);
        
        result += bytePerPixel == 3 ? current.toStringAs3bpp() : current.toStringAs1bpp();
        result += " ";
          
      }
    }
    
    return result;
  }
  
  void setBaseColor (color c) {
    this.baseColor = c;
    clear (c);
  }
  
  Cell getCell (int i, int j) {
    return cells.get(j).get(i);
  }
  
}
