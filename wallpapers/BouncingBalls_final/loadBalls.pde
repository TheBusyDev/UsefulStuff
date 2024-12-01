void loadBalls ()
{
  for (i=0; i < BALLS_NUM; i++)
  {
    ball[i] = new Ball (i);
    println ("Ball #" + (i+1) + " created");
  }
}
