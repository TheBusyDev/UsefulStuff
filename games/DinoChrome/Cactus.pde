class Cactus 
{
  float bottom, top, left, right;
  PImage selectedCactus;

  void generate (float previousCactusRight) 
  {
    // select and resize cactus icon
    selectedCactus = cactusIcon[ rand.nextInt (cactusIcon.length) ].copy();
    selectedCactus.resize(0, (int) (random(0.7, 1.01) * selectedCactus.height));
    
    // assign boundary values
    left = (random(0.7, 1.01) * width) + previousCactusRight;
    right = left + selectedCactus.width;
    bottom = dino.DEFAULT_Y + dino.HEIGHT * 0.5;
    top = bottom - selectedCactus.height;
  }

  void show (float previousCactusRight) 
  {
    if (right > 0) // i.e. if the cactus is still visible
    {
        left -= dino.vx;
        right -= dino.vx;
    } 
    else if (score < MAX_SCORE - 99) // if the game is still going on and this cactus is not visible anymore --> generate another cactus
    {
        generate (previousCactusRight);
    }
    
    // draw cactus
    image (selectedCactus, left, top);
  }
}
