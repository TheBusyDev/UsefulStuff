class GameBoard
{
  final int COL = Integer.parseInt (entry[1].selected); // COL must be >= 50
  final int LEN = width / COL;
  final int ROW = ((height*18/20)/LEN);
  
  final int ZOOM_COL = 20;
  final int ZOOM_LEN = width / ZOOM_COL;
  final int ZOOM_ROW = (height*18/20)/ZOOM_LEN;
  int X1 = 0, Y1 = 0;
  
  int i, j;
  spot[][] board = new spot[ROW][COL];
  
  class spot
  {
    boolean alive = false;
    boolean change = false;
  }
  
  GameBoard ()
  {
    for (i=0; i<ROW; i++)
      for (j=0; j<COL; j++)
        board[i][j] = new spot ();
  }
  
  void setup ()
  {    
    String[] startingBoard = loadStrings ("game_of_life.board");
    
    noStroke ();
    
    int x = (ROW - startingBoard.length)/2;
    int y = (COL - startingBoard[0].length())/2;
    
    // print gameBoard for the first time    
    for (i=0; i < startingBoard.length; i++)
      for (j=0; j < startingBoard[i].length (); j++)
      {
        board[ i + x ][ j + y ].alive = (startingBoard[i].charAt(j) == 'x');
        printCell (board[ i + x ][ j + y ].alive, i + x, j + y, LEN);        
      }
  }
  
  void rand (int max_value)
  {
    for (i=0; i<ROW; i++)
      for (j=0; j<COL; j++)
        if ((int) random (0, max_value) == 0) // (1 : max_value) odds to find an alive cell
        {
          board[i][j].alive = true;
          printCell (true, i, j, LEN);
        }
  }
  
  void update ()
  {
    int neighbours;
    
    for (i=0; i<ROW; i++)
      for (j=0; j<COL; j++)
      {
        neighbours = countNeighbours (i, j);
        
        if ( (board[i][j].alive && (neighbours < 2 || neighbours > 3)) || (!board[i][j].alive && neighbours == 3) ) // game rules
          board[i][j].change = true;
      }
      
      for (i=0; i<ROW; i++)
        for (j=0; j<COL; j++)
          if (board[i][j].change)
          {
            board[i][j].alive = !board[i][j].alive;
            printCell (board[i][j].alive, i, j, LEN);
            board[i][j].change = false;
          }
  }
  
  void printCell (boolean alive, int row, int col, int len)
  {
    if (alive) // a new cell is born
      fill (255);
    else // another cell died
      fill (0);
      
    square (len*col, len*row, len);
  }
  
  void printBoard ()
  {
    fill (0);
    noStroke ();
    rect (0, 0, width, ROW*LEN);
    
    for (i=0; i<ROW; i++)
      for (j=0; j<COL; j++)
        if (board[i][j].alive)
          printCell (true, i, j, LEN);
  }
  
  int countNeighbours (int row, int col)
  {
    int k, l, count=0;
    
    for (k = -1; k <= +1; k++)
      for (l = -1; l <= +1; l++)
        if ( (k != 0 || l != 0) && (row+k >= 0 && row+k < ROW) && (col+l >= 0 && col+l < COL) && board[row+k][col+l].alive )
          count++;
        
    return count;    
  }
  
  void showZoomArea ()
  {
    int x1, y1, x2, y2;
    int row = mouseY/LEN, col = mouseX/LEN;
    
    // delete the previous rectangle    
    for (i=Y1; i <= Y1+ZOOM_ROW; i++)
      for (j=X1; j <= X1+ZOOM_COL; j++)
        if (i != ROW && j != COL)
          printCell (board[i][j].alive, i, j, LEN);
    
    if (row>=0 && row<ROW && col>=0 && col<COL)
    {
      if (col-ZOOM_COL/2 <= 0)
      {
        x1 = 0;
        x2 = ZOOM_COL*LEN;
        
        X1 = 0;
      }
      else if (col+ZOOM_COL/2 >= COL)
      {
        x2 = COL*LEN - 1;
        x1 = (COL - ZOOM_COL)*LEN;
        
        X1 = COL - ZOOM_COL;
      }
      else
      {
        x1 = (col-ZOOM_COL/2)*LEN;
        x2 = (col+ZOOM_COL/2)*LEN;
        
        X1 = col - ZOOM_COL/2;
      }
      
      
      if (row-ZOOM_ROW/2 <= 0)
      {
        y1 = 0;
        y2 = ZOOM_ROW*LEN;
        
        Y1 = 0;
      }
      else if (row+ZOOM_ROW/2 >= ROW)
      {
        y2 = ROW*LEN - 1;
        y1 = (ROW - ZOOM_ROW)*LEN;
        
        Y1 = ROW - ZOOM_ROW;
      }
      else
      {
        y1 = (row-ZOOM_ROW/2)*LEN;
        y2 = (row+ZOOM_ROW/2)*LEN;
        
        Y1 = row - ZOOM_ROW/2;
      }
      
      stroke (67, 255, 253);
      line (x1, y1, x1, y2);
      line (x1, y2, x2, y2);
      line (x2, y2, x2, y1);
      line (x2, y1, x1, y1);
      noStroke ();
    } 
  }
  
  boolean zoom ()
  {
    int row = mouseY/LEN, col = mouseX/LEN;  
    
    if (row>=0 && row<ROW && col>=0 && col<COL)
    {
      fill (0);
      noStroke ();
      rect (0, 0, width, ROW*LEN);
      
      for (i=Y1; i< Y1 + ZOOM_ROW; i++)
        for (j=X1; j < X1 + ZOOM_COL; j++)
          if (board[i][j].alive)
            printCell (true, i - Y1, j - X1, ZOOM_LEN);
            
      return true;
    }
    
    return false;
  }  
  
  void changeCell ()
  {
    int row = mouseY/ZOOM_LEN + Y1, col = mouseX/ZOOM_LEN + X1;
    
    if (row >= Y1 && row < Y1+ZOOM_ROW && col >= X1 && col < X1+ZOOM_COL)
    {
      board[row][col].alive = !board[row][col].alive;
      printCell (board[row][col].alive, row - Y1, col - X1, ZOOM_LEN);
    }    
  }
}
