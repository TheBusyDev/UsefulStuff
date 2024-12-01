class Head
{
  int x, y; // x-y coordinates
  int dir; //direction
  
  Head (int x, int y, int dir)
  {
    this.x = x;
    this.y = y;
    this.dir = dir;
  }
  
  void show ()
  {
    image (headIcon[dir], x*DIM, y*DIM);
  }
  
  void move ()
  {
    body.add (new Body (x, y, dir));
    
    if (dir == up)
    {
      if (y == 0)
        y = ROW-1;
      else
        y--;
    }
    else if (dir == right)
    {
      if (x == COL-1)
        x = 0;
      else
        x++;
    }
    else if (dir == down)
    {
      if (y == ROW-1)
        y = 0;
      else
        y++;
    }
    else // if (dir == left)
    {
      if (x == 0)
        x = COL-1;
      else
        x--;
    }
    
    show ();
  }
}
