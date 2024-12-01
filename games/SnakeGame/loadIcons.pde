void loadIcons () 
{
  for (int i=0; i < 4; i++)
  {
    // create snake head
    headIcon[i] = createGraphics (DIM, DIM);
    headIcon[i].beginDraw ();
    headIcon[i].background (BG_COLOR);
    headIcon[i].noStroke ();
    headIcon[i].fill (SNAKE_COLOR);
    headIcon[i].ellipseMode (CENTER);
    headIcon[i].circle (DIM*0.5, DIM*0.5, DIM);
    headIcon[i].rectMode (CENTER);
    
    headIcon[i].fill (SNAKE_COLOR);
    
    switch (i)
    {
      case up: 
        headIcon[i].rect (DIM*0.5, DIM*0.75, DIM, DIM*0.5);
        break;
      case right: 
        headIcon[i].rect (DIM*0.25, DIM*0.5, DIM*0.5, DIM); 
        break;
      case down: 
        headIcon[i].rect (DIM*0.5, DIM*0.25, DIM, DIM*0.5); 
        break;
      case left: 
        headIcon[i].rect (DIM*0.75, DIM*0.5, DIM*0.5, DIM); 
        break;
    }
    
    // draw snake eyes
    if (i == up || i == down)
    {
      headIcon[i].fill (255);
      headIcon[i].circle (DIM*0.25, DIM*0.5, DIM*0.4);
      headIcon[i].circle (DIM*0.75, DIM*0.5, DIM*0.4);
      headIcon[i].fill (0);
      headIcon[i].circle (DIM*0.25, DIM*0.5, DIM*0.2);
      headIcon[i].circle (DIM*0.75, DIM*0.5, DIM*0.2);
    }
    else // if (i == right || i == left)
    {
      headIcon[i].fill (255);
      headIcon[i].circle (DIM*0.5, DIM*0.25, DIM*0.4);
      headIcon[i].circle (DIM*0.5, DIM*0.75, DIM*0.4);
      headIcon[i].fill (0);
      headIcon[i].circle (DIM*0.5, DIM*0.25, DIM*0.2);
      headIcon[i].circle (DIM*0.5, DIM*0.75, DIM*0.2);
    }

    headIcon[i].endDraw (); 
    
    // create snake tail
    tailIcon[i] = createGraphics (DIM, DIM);
    tailIcon[i].beginDraw ();
    tailIcon[i].background (BG_COLOR);
    tailIcon[i].noStroke ();
    tailIcon[i].fill (SNAKE_COLOR);
    tailIcon[i].ellipseMode (CENTER);
    tailIcon[i].circle (DIM*0.5, DIM*0.5, DIM);
    tailIcon[i].rectMode (CENTER);
    
    switch (i)
    {
      case up: tailIcon[i].rect (DIM*0.5, DIM*0.25, DIM, DIM*0.5); break;
      case right: tailIcon[i].rect (DIM*0.75, DIM*0.5, DIM*0.5, DIM); break;
      case down: tailIcon[i].rect (DIM*0.5, DIM*0.75, DIM, DIM*0.5); break;
      case left: tailIcon[i].rect (DIM*0.25, DIM*0.5, DIM*0.5, DIM); break;
    }
    
    tailIcon[i].endDraw (); 
  }
  
  /*// create food icon
  foodIcon = createGraphics (DIM, DIM);
  foodIcon.beginDraw ();
  foodIcon.noStroke ();
  foodIcon.fill (FOOD_COLOR);
  foodIcon.ellipseMode (CENTER);
  foodIcon.circle (DIM*0.5, DIM*0.5, DIM);
  foodIcon.endDraw ();*/
}
