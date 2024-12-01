class Dino 
{
  final int WIDTH, HEIGHT;
  final float X, DEFAULT_Y;
  final float STARTING_VX, STARTING_VY;
  final float INCREASE_VX, INCREASE_VY;
  final float LIMIT_VX;
  
  float Y, vx, vy = 0;
  int iconIndex, immunityCount = 0;
  boolean isVisible = true;

  Dino() 
  {
    this.WIDTH = dinoIcon[0].width;
    this.HEIGHT = dinoIcon[0].height;
    
    // set up dino's coordinates 
    this.X = width * 0.06;
    this.DEFAULT_Y = height * 0.7;
    this.Y = -height;
    
    // set up dino's speed
    this.STARTING_VX = width * 0.01;
    this.STARTING_VY = height * 0.052;
    this.vx = this.STARTING_VX;

    this.INCREASE_VX = width * 2.5E-6;
    this.INCREASE_VY = height * 0.004;
    
    this.LIMIT_VX = width * 0.025;
  }

  void show() 
  {
    if (isJumping()) 
    {
      vy += INCREASE_VY;
      Y = min (Y + vy, DEFAULT_Y);
      iconIndex = 2; // jumping dino icon
    } 
    else if (frameCount % 8 == 0)
    {
      // create dino's animation when running
      iconIndex = iconIndex == 0 ? 1 : 0;
    }
    
    if (!startMenu && vx < LIMIT_VX) 
    {
      vx += INCREASE_VX;
    }
    
    if (immunityCount > 0) // i.e. if immunity is guaranteed after taking damage
    {
      immunityCount -= 1;
      
      if (immunityCount % (FPS/6) == 0) 
      {
        isVisible = (immunityCount % FPS != 0); // dino is appearing after 0.167 seconds.
      }
      
      if (immunityCount == 0) 
      {
        isVisible = true;
      }
    }
    
    if (life == 0) // i.e. if dino is dead --> game over
    {
      isVisible = true;
      iconIndex = 3;
    }
    
    if (isVisible) 
    {
      // draw dino's icon
      image (dinoIcon[iconIndex], X - (WIDTH * 0.5), Y - (HEIGHT * 0.5));
    }
  }

  void jump() 
  {
    vy = -STARTING_VY;
    Y += vy; // make dino jump
  }

  boolean isJumping() 
  {
    return Y < DEFAULT_Y;
  }

  void immunity() 
  {
    immunityCount = 2*FPS; // guarantee damage immunity for 2 seconds
    isVisible = false;
  }

  boolean damageAllowed() 
  {
    return immunityCount == 0;
  }
}
