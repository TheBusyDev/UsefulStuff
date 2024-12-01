class Moon 
{
  final float INCREASE_X;

  float X, Y;
  PImage moonIcon;

  Moon() 
  {
      this.INCREASE_X = width * 0.0001;
      this.X = width;
      this.Y = height * 0.2;
      this.moonIcon = loadImage ("moon.png");
      this.moonIcon.resize (height/10, 0);
  }

  void show() 
  {
      X = X > -moonIcon.width ? X - INCREASE_X : width;
      image (moonIcon, X, Y);
  }
}
