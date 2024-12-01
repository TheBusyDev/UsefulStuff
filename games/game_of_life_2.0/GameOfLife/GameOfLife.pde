GameBoard gameBoard;

Button startButton;
Button pauseButton;
Button quitButton;
Button menuButton;

Settings setIcon;

Entry[] entry;

boolean android;

boolean menu;
boolean settings;
boolean game;

boolean pause = true;
boolean zoom = false;
boolean first_touch = false;

int delay_ms;

void setup ()
{
  size (400, 850);
  //size (displayWidth, displayHeight);
  android = false;
    
  orientation (PORTRAIT);
  
  startButton = new Button (width/2, height*2/3, "START!");
  pauseButton = new Button (width/4, height*19/20, "PAUSE");
  quitButton = new Button (width*3/4, height*19/20, "QUIT");
  menuButton = new Button (width/2, height*19/20, "MENU");
  
  setIcon = new Settings (width*14/15, width/15, height/25);
  
  entry = new Entry [4];
    
  entry[0] = new Entry ("Cell Generator", new String[] {"Default", "Random", "Manual"}, 0);
  entry[1] = new Entry ("Cells in a row", new String[] {"50", "80", "100", "133", "200", "400"}, 1);
  entry[2] = new Entry ("Chance to find an alive cell (random mode)", new String[] {"1:2", "1:3", "1:5", "1:10", "1:20"}, 2);
  entry[3] = new Entry ("Refresh rate (milliseconds)", new String[] {"25", "50", "100", "200"}, 3);
  
  mainMenu ();
}

void draw ()
{
  if (!pause)
  {
    delay (delay_ms);
    gameBoard.update ();
  }
}

void mouseDragged ()
{
  if (game && pause)
  {
    if (!zoom)
      gameBoard.showZoomArea ();
    else
      gameBoard.changeCell ();
  }
}

void mouseReleased ()
{
  if (game && pause && !zoom)
  {
    if (!first_touch)
      zoom = gameBoard.zoom ();
    else
      first_touch = false;
  }
}

void mousePressed ()
{
  if (menu)
  {
    if (startButton.isPressed ()) // start button
    {
      menu = false;
      startGame ();
    }
      
    if (setIcon.isPressed ())
    {
      menu = false;
      settingsMenu ();
    }
  }
  
  if (settings)
  {
    for (int i=0; i < entry.length; i++)
      for (int j=0; j < entry[i].option.length; j++)
        if (entry[i].option[j].isPressed ())
        {
          entry[i].saveEntry (j);
          settingsMenu ();
        }
    
    if (menuButton.isPressed ())
    {
      settings = false;
      mainMenu ();
    }
  }
  
  if (game)
  {
    if (pause && !first_touch)
    {
      if (!zoom)
        gameBoard.showZoomArea ();
      else
        gameBoard.changeCell ();
    }
    
    if (pauseButton.isPressed ()) // pause button
    {
      pause = !pause;
      
      if (pause)
        pauseButton.TXT = "RESUME";
      else
      {
        zoom = false;
        gameBoard.printBoard ();
        pauseButton.TXT = "PAUSE";
      }
      
      pauseButton.show ();
    }
      
    if (quitButton.isPressed ()) // quit button
    {
      game = false;
      pause = true;
      zoom = false;
      mainMenu ();
    }
  }
}

void mainMenu ()
{
  menu = true;
  
  clear ();
  background (0);
  
  fill (255);
  textAlign (CENTER);
  textSize (height/30);
  text ("GAME\nOF LIFE", width/2, height/3);
  
  startButton.show ();
  setIcon.show ();
}

void startGame ()
{
  game = true;
  
  clear ();
  background (0);
  
  gameBoard = new GameBoard ();
  
  delay_ms = Integer.parseInt (entry[3].selected);
  
  switch (entry[0].selected)
  {
    case "Default": 
      gameBoard.setup ();
      pause = false;
      break;
      
    case "Random":
      StringBuilder max_value = new StringBuilder (entry[2].selected);
      max_value.delete (0, 2); // delete "1:" --> example: 1:2 --> 2
      gameBoard.rand (Integer.parseInt (max_value.toString ()));
      
      pause = false;
      break;
      
    case "Manual":
      first_touch = true; // fix a bug: if Start button is pressed on Manual mode, the board is instantly zoomed in
  }
  
  if (pause)
    pauseButton.TXT = "RESUME";
  else
    pauseButton.TXT = "PAUSE";
        
  pauseButton.show ();
  quitButton.show ();
}

void settingsMenu ()
{
  settings = true;
  
  clear ();
  background (0);
  
  menuButton.show ();
  
  for (int i=0; i < entry.length; i++)
    entry[i].show ();
}
