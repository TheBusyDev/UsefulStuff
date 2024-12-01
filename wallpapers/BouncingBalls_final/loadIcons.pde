void loadIcons ()
{
  // ball rgb properties
  int r, g, b;
  float alpha;
  
  // ball geometrical properties
  int x, y; // coordinates
  int rad = MAX_DIM/2; // radius
  int center = MAX_DIM/2; // center coordinates
  float distanceToCenter;
  
  for (i=0; i < ICONS_NUM; i++)
  {
    ballIcon[i] = createGraphics (MAX_DIM, MAX_DIM, P2D);
    ballIcon[i].beginDraw ();
    ballIcon[i].loadPixels ();
    
    // draw ball RGB color randomly
    do
    {
      r = rand.nextInt (256);
      g = rand.nextInt (256);
      b = rand.nextInt (256);
    } while (r == R_BG && g == G_BG && b == B_BG);
    
    // generate ball icon
    for (x=0; x <= MAX_DIM; x++)
      for (y=0; y <= MAX_DIM; y++)
      {
        distanceToCenter = sqrt(sq(x - center) + sq(y - center)); // Pythagorean theorem
        
        if (distanceToCenter < rad)
        {
          alpha = distanceToCenter/rad*255; // set alpha channel
          ballIcon[i].pixels[x + y*MAX_DIM] = color (r, g, b, alpha);
        }
      }
    
    ballIcon[i].updatePixels ();
    ballIcon[i].endDraw ();
    println ("Icon #" + (i+1) + " loaded");
  }
}
