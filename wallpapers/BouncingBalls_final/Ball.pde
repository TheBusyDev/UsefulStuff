class Ball
{
  PGraphics icon;
  int dim;
  int x, y, vx, vy;
  int MIN_X, MAX_X, MIN_Y, MAX_Y;
  float alpha;
  
  Ball (int index)
  {
    // get ball icon from 'ballIcon' array
    icon = ballIcon[ index % ICONS_NUM ];
    // draw ball dimension randomly
    dim = MIN_DIM + rand.nextInt (MAX_DIM - MIN_DIM);
    
    // set minimum and maximum values for ball coordinates
    MIN_X = dim/2;
    MAX_X = width - dim/2;
    MIN_Y = dim/2;
    MAX_Y = height - dim/2;
    
    // set ball speed randomly - zero values are not accepted
    do
    {
      vx = -MAX_SPEED + rand.nextInt (2*MAX_SPEED+1);
      vy = -MAX_SPEED + rand.nextInt (2*MAX_SPEED+1);
    }
    while (vx == 0 && vy == 0);
  }
  
  void initialize ()
  {
    x = setX (mouseX);
    y = setY (mouseY);
    alpha = 255; // set maximum opacity
  }
  
  void show ()
  {
    tint (255, alpha); // set icon transparency
    image (icon, x, y, dim, dim);
    
    x = setX (x + vx);
    y = setY (y + vy);
    alpha -= DECREASE_ALPHA;
  }
  
  boolean isHidden ()
  {
    return alpha < 0;
  }
  
  int setX (int val)
  {
    if (val < MIN_X)
    {
      vx *= -1;
      return MIN_X;
    }
    else if (val > MAX_X)
    {
      vx *= -1;
      return MAX_X;
    }
    
    return val;
  }
  
  int setY (int val)
  {
    if (val < MIN_Y)
    {
      vy *= -1;
      return MIN_Y;
    }
    else if (val > MAX_Y)
    {
      vy *= -1;
      return MAX_Y;
    }
    
    return val;
  }
}
