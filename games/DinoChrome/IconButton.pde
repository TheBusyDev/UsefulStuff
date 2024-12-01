class IconButton 
{
  float bottom, top, left, right;
  PImage icon;
  boolean isVisible = false;

  IconButton (String imgSrc, float left, float top, float w, float h) 
  {
    this.icon = loadImage (imgSrc);
    this.icon.resize ((int) w, (int) h);
    
    // set up coordinates
    this.left = left;
    this.right = this.icon.width + left;
    this.top = top;
    this.bottom = this.icon.height + top;
  }  

  void show() 
  {
    isVisible = true;
    image (icon, left, top);
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
