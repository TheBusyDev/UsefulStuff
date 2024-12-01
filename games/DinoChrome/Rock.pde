class Rock 
{
  final float LEN, STARTING_Y;
  float X, Y;

  Rock() 
  {
    this.LEN = height * 0.008;
    this.STARTING_Y = horizon.Y + horizon.H;
    this.X = rand.nextInt (width + 1);
    this.Y = this.STARTING_Y + (this.LEN * rand.nextInt(8));
  }

  void show() 
  {
    if (X > -LEN) 
    {
        X -= dino.vx;
    } 
    else 
    {
        X = width;
        Y = STARTING_Y + (LEN * rand.nextInt(8));
    }
    
    fill (FG_COLOR);
    square (X, Y, LEN);
  }
}
