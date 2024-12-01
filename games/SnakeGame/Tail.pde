class Tail
{
  int x, y; // x-y coordinates
  int dir; //direction
  
  Tail (int x, int y, int dir)
  {
    this.x = x;
    this.y = y;
    this.dir = dir;
  }
  
  void show ()
  {
    image (tailIcon[dir], x*DIM, y*DIM);
  }
  
  void move ()
  {
    if (food.isEaten)
    {
      food.isEaten = false;
      score++;
      return;
    }
    
    fill (BG_COLOR);
    square (x*DIM, y*DIM, DIM);
    isOccupied[y][x] = false;
    
    x = body.get(0).x;
    y = body.get(0).y;
    dir = body.get(0).dir;
    body.remove (0);
    show ();
  }
}
