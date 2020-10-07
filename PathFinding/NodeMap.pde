import java.security.*;
/********************
  Énumération des directions
  possibles
  
********************/
enum Direction {
  EAST, SOUTH, WEST, NORTH
}

/********************
  Représente une carte de cellule permettant
  de trouver le chemin le plus court entre deux cellules
  
********************/
class NodeMap extends Matrix {
  Node start;
  Node end;
  int Final_H;
  ArrayList <Node> path = new ArrayList <Node>();
  
  boolean debug = false;
  
  NodeMap (int nbRows, int nbColumns) {
    super (nbRows, nbColumns);
  }
  
  NodeMap (int nbRows, int nbColumns, int bpp, int width, int height) {
    super (nbRows, nbColumns, bpp, width, height);
  }
  
  void init() {
    
    cells = new ArrayList<ArrayList<Cell>>();
    
    for (int j = 0; j < rows; j++){
      // Instanciation des rangees
      cells.add (new ArrayList<Cell>());
      
      for (int i = 0; i < cols; i++) {
        Cell temp = new Node(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        
        // Position matricielle
        temp.i = i;
        temp.j = j;
        
        cells.get(j).add (temp);
      }
    }
    
    println ("rows : " + rows + " -- cols : " + cols);
  }
   Boolean getstartCelliswalkable(int i, int j)
  {
    Node find = (Node)cells.get(j).get(i);
    if(find.isWalkable)
    {
      return true;
    }
    return false;
  }  /*
    Configure la cellule de départ
  */
  void setStartCell (int i, int j) {
    
    if (start != null) {
      start.isStart = false;
      start.setFillColor(baseColor);
    } 
    
    start = (Node)cells.get(j).get(i);
    start.isStart = true;
    
    start.setFillColor(color (127, 0, 127));
  }
  
  /*
    Configure la cellule de fin
  */
  void setEndCell (int i, int j) {
    
    if (end != null) {
      end.isEnd = false;
      end.setFillColor(baseColor);
    }
    
    end = (Node)cells.get(j).get(i);
    end.isEnd = true;
    
    end.setFillColor(color (127, 127, 0));
    
    print("End cell is :" + i + j);
  }
  
  /** Met a jour les H des cellules
  doit etre appele apres le changement du noeud
  de debut ou fin
  */
  void updateHs() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node current = (Node)cells.get(j).get(i); 
        current.setH( calculateH(current));
      }
    }
  }
  
  // Permet de generer aleatoirement le cout de deplacement
  // entre chaque cellule
  void randomizeMovementCost() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        
        int cost = parseInt(random (0, cols)) + 1;
        
        Node current = (Node)cells.get(j).get(i);
        current.setMovementCost(cost);
       
      }
    }
  }
  
  // Permet de generer les voisins de la cellule a la position indiquee
  void generateNeighbours(int i, int j) {
    Node c = (Node)getCell (i, j);
    if (debug) println ("Current cell : " + i + ", " + j);
    
    
    for (Direction d : Direction.values()) {
      Node neighbour = null;
      
      switch (d) {
        case EAST :
          if (i < cols - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i + 1, j);
          }
          break;
        case SOUTH :
          if (j < rows - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j + 1);
          }
          break;
        case WEST :
          if (i > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i - 1, j);
          }
          break;
        case NORTH :
          if (j > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j - 1);
          }
          break;
      }
      
      if (neighbour != null) {
        if (neighbour.isWalkable) {
          c.addNeighbour(neighbour);
        }
      }
    }
  }
  
  /**
    Génère les voisins de chaque Noeud
    Pas la méthode la plus efficace car ça
    prend beaucoup de mémoire.
    Idéalement, on devrait le faire au besoin
  */
  void generateNeighbourhood() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        generateNeighbours(i, j);
      }
    }
  }
    boolean GetneighboursOpenlist(ArrayList <Node> openList, Node neighbour)
  {
    
     for(Node node : openList)
     {
             if(node == neighbour)
                return true;

     }
   return false;
  }
  /*
    Permet de trouver le chemin le plus court entre
    deux cellules
  */
  void findAStarPath () {
    // TODO : Complétez ce code
    int prime_g = 0;
    if (start == null || end == null) {
      println ("No start and no end defined!");
      return;
    }
    
    // TODO : Complétez ce code
    Node currentNode;
    
    ArrayList <Node> OpenNodelist = new ArrayList <Node>();
    ArrayList <Node> CloseNodelist = new ArrayList <Node>();    
      
    
    // Appelez generatePath si le chemin est terminé
    // TODO : Complétez ce code
    
    OpenNodelist.add(start);
    
    while((OpenNodelist.size() > 0) && (end.parent == null)){
     
      currentNode = getLowestCost(OpenNodelist);
      
      if(currentNode == end)
          continue;
      
      
      OpenNodelist.remove(currentNode);
      CloseNodelist.add(currentNode); 
     
     for(Node node : currentNode.neighbours){
 
        if(CloseNodelist.contains(node))
            continue;
        
        if(node.isWalkable){
          prime_g = calculateCost(currentNode, node);
           if(!GetneighboursOpenlist(OpenNodelist, node))
              OpenNodelist.add(node);
               else if(prime_g >= node.getG())
                continue;
                
            node.parent = currentNode;
            node.G = prime_g;
        }
      }
      

      if(end.parent != null)
          generatePath();   
      
    }
  }
  
  /*
    Permet de générer le chemin une fois trouvée
  */
  void generatePath () {
    // TODO : Complétez ce code
    print("generate Path \n");
    Node Parent;
    Parent = end.parent;
    int i = 0;
    while(Parent.parent != null){
       print(i++ + "/n");
      Final_H = calculateH(Parent);
      path.add(Parent);
      Parent = Parent.parent;
    }
  }
  
  /**
  * Cherche et retourne le noeud le moins couteux de la liste ouverte
  * @return Node le moins couteux de la liste ouverte
  */
  private Node getLowestCost(ArrayList<Node> openList) {
    // TODO : Complétez ce code
    Node lowestNode = openList.get(0);
    for(Node node : openList) {
      
      if(node.getF() < lowestNode.getF())
        lowestNode = node;
      
    }
    
    return lowestNode;
  }
  

  
 /**
  * Calcule le coût de déplacement entre deux noeuds
  * @param nodeA Premier noeud
  * @param nodeB Second noeud
  * @return
  */
  private int calculateCost(Node nodeA, Node nodeB) {
    // TODO : Complétez ce code
    int prime_G;
    
    prime_G = nodeA.getG() + nodeB.movementCost;    
    
    return prime_G;
  }
  
  /**
  * Calcule l'heuristique entre le noeud donnée et le noeud finale
  * @param node Noeud que l'on calcule le H
  * @return la valeur H
  */
  private int calculateH(Node node) {
    // TODO : Complétez ce code
    
    return Math.abs(node.j-end.j) + Math.abs(end.i - node.i);
  }
  
  String toStringFGH() {
    String result = "";
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        Node current = (Node)cells.get(j).get(i);
        
        result += "(" + current.getF() + ", " + current.getG() + ", " + current.getH() + ") ";
      }
      
      result += "\n";
    }
    
    return result;
  }
  
  // Permet de créer un mur à la position _i, _j avec une longueur
  // et orientation données.
  void makeWall (int _i, int _j, int _length, boolean _vertical) {
    int max;
    
    if (_vertical) {
      max = _j + _length > rows ? rows: _j + _length;  
      
      for (int j = _j; j < max; j++) {
        ((Node)cells.get(j).get(_i)).setWalkable (false, 0);
      }       
    } else {
      max = _i + _length > cols ? cols: _i + _length;  
      
      for (int i = _i; i < max; i++) {
        ((Node)cells.get(_j).get(i)).setWalkable (false, 0);
      }     
    }
  }
}
