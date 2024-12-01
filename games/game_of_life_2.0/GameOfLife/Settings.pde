class Settings
{
  int LEN, X, Y;
  boolean isVisible;
  PImage icon = loadImage ("ic_settings.png");
  
  Settings (int x, int y, int len)
  {
    LEN=len;
    X=x;
    Y=y;
  }
  
  void show () 
  {
    isVisible = true;
    
    icon.resize (LEN, 0);
    image (icon, X - LEN/2, Y - LEN/2);
  }
  
  boolean isPressed ()
  {
    return (mouseX >= X - LEN/2 && mouseX <= X + LEN/2 && mouseY >= Y - LEN/2 && mouseY <= Y + LEN/2);
  }
}
