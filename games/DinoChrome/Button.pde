class Button 
{
  float LEN, RAD;
  float X, Y;
  float bottom, top, left, right;
  boolean isVisible = false;
  String txt;
  
  Button (float X, float Y, String txt) 
  {
    this.RAD = height * 0.05;
    this.LEN = width * 0.15;
    this.X = X;
    this.Y = Y;
    this.txt = txt;
    this.left = X - ((this.LEN * 0.5) + this.RAD);
    this.right = X + (this.LEN * 0.5) + this.RAD;
    this.top = Y - this.RAD;
    this.bottom = Y + this.RAD;
  }
  
  void show() 
  {
    isVisible = true;
    
    // draw button contour
    fill (FG_COLOR);
    circle (X - (LEN * 0.5), Y, RAD * 2);
    circle (X + (LEN * 0.5), Y, RAD * 2);    
    rect (X - (LEN * 0.5), Y - RAD, LEN, RAD * 2);
    
    // write text on the button
    fill (BG_COLOR);
    textAlign (CENTER);
    text (txt, X, Y + (RAD * 0.5));
  }
  
  void hide() 
  {
    isVisible = false;
  }
  
  boolean isPressed() 
  {
    return isVisible && mouseX > left && mouseX < right && mouseY > top && mouseY < bottom;
  }
}
