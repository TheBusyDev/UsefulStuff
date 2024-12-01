import java.util.Random;
Random rand = new Random ();

final color BG_COLOR = #08FF96; // background color
final color FG_COLOR = color (0); // foreground color
final color BORDER_COLOR = #02B76A;
final color SNAKE_COLOR = #004B21;
final int up = 0;
final int right = 1;
final int down = 2;
final int left = 3;

int DIM, ROW, COL, X_TRANSLATION, Y_TRANSLATION;
float TOL; // tolerance to change direction
int score;
int mouseX_old, mouseY_old; // mouse position in the previous frame
int deltaX, deltaY, delta;
boolean[][] isOccupied; // isOccupied[i][j] == true if the cell is occupied, false if it's free
boolean startMenu, isChangingDirection;
PGraphics[] headIcon = new PGraphics[4];
PGraphics[] tailIcon = new PGraphics[4];
ArrayList<Body> body = new ArrayList<Body>();
Head head;
Tail tail;
Food food;
Button button;

void setup ()
{
  fullScreen ();
  //size (650, 1000);
  orientation (PORTRAIT);
  background (BG_COLOR);
  frameRate (13);
  noStroke ();
  
  DIM = min (width, height)/20;
  ROW = height/DIM;
  COL = width/DIM;
  X_TRANSLATION = (width % DIM)/2;
  Y_TRANSLATION = (height % DIM)/2;
  TOL = max (width, height)*0.0075;
  // println ("tolerance: " + TOL);
  translate (X_TRANSLATION, Y_TRANSLATION);
  
  isOccupied = new boolean[ROW][COL];
  
  for (int i=0; i < ROW; i++)
    for (int j=0; j < COL; j++)
      isOccupied[i][j] = false;

  loadIcons ();
  drawBorders ();
  
  // draw snake on its starting position
  head = new Head (COL/6, ROW/2, up);
  head.show ();
  
  int len = ROW/4; // body length
  
  for (int i=0; i < len; i++)
    body.add (new Body (head.x, head.y+len-i, head.dir));
  
  tail = new Tail (head.x, body.get(0).y + 1, head.dir);
  tail.show ();
  
  food = new Food ();
  button = new Button ();
  
  textFont (createFont ("font.ttf", min (width, height)*0.05));
  textAlign (CENTER, CENTER);
  
  // show Start Menu
  startMenu = true;
  showText ("Snake\nGame");
  button.show ("Start");
  
  score = 0;
  isChangingDirection = false;
}

void draw ()
{  
  if (mousePressed && !startMenu)
  {
    if (mouseX_old != -1)
    {
      deltaX = mouseX - mouseX_old;
      deltaY = mouseY - mouseY_old;
      delta = max (abs (deltaX), abs (deltaY));
      
      if (delta > TOL)
      {
        if (delta == deltaX && head.dir != left)
            head.dir = right;
        else if (delta == -deltaX && head.dir != right)
            head.dir = left;
        else if (delta == deltaY && head.dir != up)
            head.dir = down;
        else if (head.dir != down)
            head.dir = up;
        
        // println ("dx: " + deltaX + "\ndy: " + deltaY + "\nd:  " + delta);
      }
    }
    
    // update mouse position
    mouseX_old = mouseX;
    mouseY_old = mouseY;
  }
  
  // println ("X_old: " + mouseX_old + "\nY_old: " + mouseY_old); 
    
  translate (X_TRANSLATION, Y_TRANSLATION);
  tail.move ();
  head.move ();
  
  if (!startMenu)
  {
    if (isChangingDirection)
      isChangingDirection = false;
      
    // generate new food if it was eaten
    if (food.x == head.x && food.y == head.y) 
      food.generate (true);
       
    // check gameover
    if (isOccupied[ head.y ][ head.x ])
    {
      showText ("Game over\nScore: " + score);
      noLoop ();
    }
  }
}
  
void keyPressed ()
{
  if (!startMenu && !isChangingDirection)
  {
    if (keyCode == UP && head.dir != down)
      head.dir = up;
    else if (keyCode == RIGHT && head.dir != left)
      head.dir = right;
    else if (keyCode == DOWN && head.dir != up)
      head.dir = down;
    else if (keyCode == LEFT && head.dir != right)
      head.dir = left;
      
    isChangingDirection = true;
  }
}

void mousePressed ()
{
  if (startMenu && button.isPressed ())
  {
    startMenu = false;
    mouseX_old = -1;
    mouseY_old = -1;
    
    // clear the screen and re-draw borders
    background (BG_COLOR);
    drawBorders ();
    
    // re-draw the snake
    head.show ();
    
    for (int i=0; i < body.size (); i++)
      body.get(i).show ();
      
    tail.show ();
    
    // generate new food
    food.generate (false);
  }
}

void mouseReleased ()
{
  // println ("released");
  mouseX_old = -1;
  mouseY_old = -1;
}
