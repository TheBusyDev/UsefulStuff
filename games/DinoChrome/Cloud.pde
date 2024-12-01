class Cloud 
{
  final float INCREASE_X;
  float X, Y;

  Cloud (int index) 
  {
    this.INCREASE_X = width * 0.0003;
    this.X = cloudIcon.width * (index * 2 + random(1));
    this.Y = (height * 0.1) + (cloudIcon.height * random(7.5));
  }

  void show() 
  {
    if (X > -cloudIcon.width) // i.e. if the cloud is still visible
    {
        X -= INCREASE_X;
    } 
    else // move the cloud to the right side
    {
        X = width;
        Y = (height * 0.1) + (cloudIcon.height * random(7.5));
    }
    
    image (cloudIcon, X, Y);
  }
}
