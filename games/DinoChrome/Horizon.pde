class Horizon 
{
  final float H, Y;

  Horizon() 
  {
    this.Y = dino.DEFAULT_Y + (dino.HEIGHT * 0.4);
    this.H = height * 0.005;
  }

  void show() 
  {
    fill (FG_COLOR);
    rect (0, Y, width, H);
  }
}
