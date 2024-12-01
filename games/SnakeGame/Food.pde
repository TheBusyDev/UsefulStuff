class Food
{
  PImage foodIcon;
  int x, y; // x-y coordinates
  boolean isEaten;
  
  Food ()
  {
    foodIcon = loadImage ("apple.png");
    foodIcon.resize (DIM, DIM);
    isEaten = false;
  }
  
  void generate (boolean isEaten)
  {
    this.isEaten = isEaten;
    
    do
    {
      x = rand.nextInt(COL);
      y = rand.nextInt(ROW);
    } while (isOccupied[y][x] || (x == head.x && y == head.y));
    
    image (foodIcon, x*DIM, y*DIM);
  }
}
