class Body
{
  int x, y; // x-y coordinates
  int dir; //direction
  
  Body (int x, int y, int dir)
  {
    this.x = x;
    this.y = y;
    this.dir = dir;
    isOccupied[y][x] = true;
    show ();
  }
  
  void show ()
  {
    fill (SNAKE_COLOR);
    square (x*DIM, y*DIM, DIM);
  }
}
