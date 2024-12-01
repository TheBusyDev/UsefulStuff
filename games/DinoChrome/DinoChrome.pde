import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import java.io.FileNotFoundException; 
import java.util.Random;

Random rand = new Random();

final int BG_COLOR = 60; // background color
final int FG_COLOR = 255; // foreground color
final int SECOND_FG_COLOR = 200; // second foreground color
final int FPS = 60; // frame per second
final int MAX_SCORE = 9999, MAX_LIFE = 3;

int bestScore, life;
float score;
boolean startMenu;

// declare all the essential elements
Dino dino;
Horizon horizon;
Moon moon;
Cactus[] cactus = new Cactus[2];
Rock[] rock = new Rock[25];
Cloud[] cloud = new Cloud[6];

// define buttons
Button startButton;
Button menuButton;
IconButton exitButton;
IconButton menuIconButton;

// define images
PImage[] dinoIcon;
PImage[] cactusIcon;
PImage cloudIcon;
PImage heart;



void setup() 
{
  size (850, 400);
  //fullScreen();
  orientation (LANDSCAPE);
  frameRate (FPS);
  noStroke();
  
  // load icons for each initialized element
  loadDinoIcons();
  loadCactusIcons();
  loadBestScore();
  
  initializeGame();
  
  // initalize each element
  horizon = new Horizon();
  moon = new Moon();
  menuButton = new Button (width * 0.5, height * 0.4, "MENU");
  startButton = new Button (width * 0.5, height * 0.4, "START");
  menuIconButton = new IconButton ("back_icon.png", width * 0.025, height * 0.025, 0, height * 0.075);
  exitButton = new IconButton ("exit_icon.png", width * 0.025, height * 0.025, 0, height * 0.075);
  
  // load icons
  cloudIcon = loadImage ("cloud.png");
  cloudIcon.resize(0, (height * 5) / 100);
  
  heart = loadImage("heart.png");
  heart.resize(0, (height * 5) / 100);
  
  // initialize each elements for 'rock' array
  for (int i=0; i < rock.length; i++)
  {
    rock[i] = new Rock();
  }
  
  // initialize each element from 'cloud' array
  for (int i=0; i < cloud.length; i++)
  {
    cloud[i] = new Cloud(i);
  }
  
  // load font
  textFont (createFont ("font.ttf", height * 0.05));
 }
 
 

void draw() 
{
  int i;
  
  // draw background elements
  background (BG_COLOR);
  horizon.show();
  moon.show();
  
  for (i=0; i < rock.length; i++)
  {
    rock[i].show();
  }
  
  for (i=0; i < cloud.length; i++)
  {
    cloud[i].show();
  }
  
  // show startMenu
  if (startMenu) 
  {
    startButton.show();
    exitButton.show();
  } 
  else // play the game
  {
    menuIconButton.show();
    
    // check for collisions on each created cactus
    for (i=0; i < cactus.length; i++)
    {
      if (dino.damageAllowed()) 
      {
        // collision receives dino and cactus coordinates as inputs
        if (collision (dino.X - (dino.WIDTH * 0.25), dino.X + (dino.WIDTH * 0.25), dino.Y - (dino.HEIGHT * 0.25), dino.Y + (dino.HEIGHT * 0.25), cactus[i].left, cactus[i].right, cactus[i].top, cactus[i].bottom)) 
        {
          life--;
          dino.immunity();
        }
      }
    }
    
    // draw each cactus
    cactus[0].show (cactus[1].right);
    cactus[1].show (cactus[0].right);
    
    // compute score
    score = min (score + (dino.vx / (width * 0.03)), MAX_SCORE);
    
    // print 'game over'
    if (life == 0 || score == MAX_SCORE) 
    {
        gameOver();
    }
  }
  
  // draw dino
  dino.show();
  
  // print best score
  fill (SECOND_FG_COLOR);
  textAlign (LEFT);
  text ("HI: " + String.format("%04d", bestScore), width * 0.5, height * 0.075);
  
  // print current score
  fill (FG_COLOR);
  text (String.format ("%04d", (int) score), width * 0.75, height * 0.075); 
  
  // print remaining life
  text (life, width * 0.94, height * 0.075);
  image (heart, width * 0.90, height * 0.02); // show heart before remaining life
}



void keyPressed() 
{
  // make dino jump (if he is not still jumping)
  if (!startMenu && (dino.Y + dino.HEIGHT * 0.5) > horizon.Y) 
  {
    dino.jump();
  }
}



public void mousePressed() 
{
  // make dino jump (if he is not still jumping)
  if (!startMenu && (dino.Y + dino.HEIGHT * 0.5) > horizon.Y) 
  {
    dino.jump();
  }
  
  // manage the displayed buttons
  if (startButton.isPressed()) 
  {
    startButton.hide();
    exitButton.hide();
    startMenu = false;
  }
  
  if (exitButton.isPressed()) 
  {
    exit();
  }
  
  // if one of the following buttons are pressed, initialize the game
  if (menuButton.isPressed() || menuIconButton.isPressed()) 
  {
    menuButton.hide();
    menuIconButton.hide();
    initializeGame();
    loop();
  }
}



void initializeGame() 
{
    score = 0;
    life = MAX_LIFE;
    startMenu = true;
    dino = new Dino();
    
    // generate new cactuses
    cactus[0] = new Cactus();
    cactus[0].generate(width * 0.5);
    
    cactus[1] = new Cactus();
    cactus[1].generate (cactus[0].right);
}



public void loadBestScore() 
{
  try 
  {
    Scanner scan = new Scanner (dataFile("best_score.txt"));
    bestScore = scan.nextInt();
    scan.close();
  } 
  catch (FileNotFoundException e) 
  {
    bestScore = 0;
  }
}



void saveBestScore() 
{
  try 
  {
    FileWriter writeToFile = new FileWriter (dataFile("best_score.txt"));
    writeToFile.write (Integer.toString(bestScore));
    writeToFile.close();
  } 
  catch (IOException e) 
  {
      e.printStackTrace();
  }
}



void loadDinoIcons() 
{
  dinoIcon = new PImage[]{loadImage("dino_1step.png"), loadImage("dino_2step.png"), loadImage("dino_jumping.png"), loadImage("dino_dead.png")};
  
  for (int i=0; i < dinoIcon.length; i++)
  {
    dinoIcon[i].resize((width * 9) / 100, 0);
  }
}



public void loadCactusIcons() 
{
  cactusIcon = new PImage[9];
  
  for (int i=0; i < cactusIcon.length; i++)
  {
    cactusIcon[i] = loadImage("cactus" + (i + 1) + ".png");
    cactusIcon[i].resize(0, dinoIcon[0].height);
  }
}



void gameOver() 
{
  fill (SECOND_FG_COLOR);
  textAlign (CENTER);
  text(score == MAX_SCORE ? "LEVEL 1 COMPLETED!" : "GAME OVER", width * 0.5, height * 0.25);
  
  menuButton.show();
  
  if (score > bestScore) 
  {
    // save new best score
    bestScore = (int) score;
    saveBestScore();
  }
  
  noLoop();
}



public boolean collision (float rectOneLeft, float rectOneRight, float rectOneTop, float rectOneBottom, float rectTwoLeft, float rectTwoRight, float rectTwoTop, float rectTwoBottom) 
{
  // check for collision for each corner of the hitbox
  return rectOneRight > rectTwoLeft && rectOneLeft < rectTwoRight && rectOneBottom > rectTwoTop && rectOneTop < rectTwoBottom;
}
