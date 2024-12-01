class Button
{
  PGraphics buttonIcon;
  float x, y; // x-y coordinates
  
  Button ()
  {
    final int LEN = width/4; // rectangle length
    final int DIAM = height/15; // circle diameter
    
    x = width*0.5;
    y = height*0.5;
    
    buttonIcon = createGraphics (LEN+DIAM, DIAM);
    buttonIcon.beginDraw ();
    buttonIcon.noStroke ();
    buttonIcon.fill (SNAKE_COLOR);
    buttonIcon.rectMode (CENTER);
    buttonIcon.rect (buttonIcon.width*0.5, buttonIcon.height*0.5, LEN, DIAM);
    buttonIcon.ellipseMode (CENTER);
    buttonIcon.circle (DIAM*0.5, buttonIcon.height*0.5, DIAM);
    buttonIcon.circle (DIAM*0.5 + LEN, buttonIcon.height*0.5, DIAM);
    buttonIcon.endDraw ();
  }
  
  boolean isPressed ()
  {
    return (mouseX > x - buttonIcon.width*0.5 && mouseX < x + buttonIcon.width*0.5 && mouseY > y - buttonIcon.height*0.5 && mouseY < y + buttonIcon.height*0.5);
  }
  
  void show (String txt)
  {
    image (buttonIcon, x - buttonIcon.width*0.5, y - buttonIcon.height*0.5);
    fill (BG_COLOR);
    text (txt, x, y);
  }
}
