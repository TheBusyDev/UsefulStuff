class Button
{
  int RAD, LEN, X, Y;
  String TXT;
  boolean isVisible;
  
  Button (int x, int y, String txt)
  {
    RAD = height/30;
    LEN = width/3;    
    X=x;
    Y=y;
    TXT=txt;
  }
  
  void show ()
  {
    isVisible = true;
    
    fill (0, 0, 255);
    noStroke ();
    circle (X - LEN/2, Y, RAD*2);
    circle (X + LEN/2, Y, RAD*2);
    rect (X - LEN/2, Y - RAD, LEN, RAD*2);
    
    fill (255);  
    textAlign (CENTER);
    textSize (RAD);
    text (TXT, X, Y + RAD/3);
  }
  
  boolean isPressed ()
  {
    return (mouseX >= X - (LEN/2 + RAD) && mouseX <= X + (LEN/2 + RAD) && mouseY >= Y - RAD && mouseY <= Y + RAD);
  }
}
