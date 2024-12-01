/*
PI approximation using Leibniz series: 1 - 1/3 + 1/5 - 1/7 + 1/9 - ... = pi/4
*/
color FG_COLOR = 255; // foreground color
color BG_COLOR = color(0, 0, FG_COLOR); // background color
int WEIGHT = 5; // stroke weight
int TEXT_SIZE; // text size to show on screen
double RAD; // circle radius
double CENTER_X, CENTER_Y; // circle center
double DIFF; // difference between 'Math.PI' and the first approximation 'pie'
double DTH = Math.PI/75; // theta discresation step

int num = 4, den = 1; // numerator and denominator used in Leibniz series
float x, y, prev_x, prev_y; // x-, y-component of every point, with their previous values
double pie = 4; // PI initial approximation
double rad; // distance from every point and center, proportional to 'diff/DIFF'
double diff; // difference between 'Math.PI' and the approximation 'pie'
double theta = 0; // center angle 

void setup ()
{ 
  size (600, 800);
  //fullScreen ();
  orientation (PORTRAIT);
  frameRate (60);
  background (BG_COLOR);
  
  fill (BG_COLOR);
  stroke (FG_COLOR);
  strokeWeight (WEIGHT);
  
  // draw external circumference
  CENTER_X = width*0.5;
  CENTER_Y = CENTER_X;
  RAD = (width - WEIGHT)*0.5;
  circle ((float)CENTER_X, (float)CENTER_Y, (float)RAD*2);
  
  // draw center as a point
  point ((float)CENTER_X, (float)CENTER_Y);
  
  strokeWeight (2);
  
  DIFF = Math.abs(pie - Math.PI);
  diff = DIFF;
  rad = RAD;
  prev_x = (float)(CENTER_X + RAD);
  prev_y = (float)CENTER_Y;
  
  TEXT_SIZE = height/21;
  textSize (TEXT_SIZE);
  textAlign (CENTER, BOTTOM);
  rectMode (CORNERS);
  
  // print 'Math.PI' value
  fill (FG_COLOR);
  text (String.format("%.15f", Math.PI), width*0.5, height - TEXT_SIZE);
}

void draw ()
{
  // compute new values of num, den and the new approximation 'pie'
  for (int i=0; i < 9999; i++)
  {
    num *= -1;
    den += 2;
    pie = pie + (double)num/den;
  }
  
  // compute new 'diff' and new 'rad' values
  diff = Math.abs(pie - Math.PI);
  rad = ( -Math.pow(1 - diff/DIFF, Math.pow(10, 7.25)) + 1 ) * RAD; // compute new 'rad' using the following formula: rad = ( -(1-diff/DIFF)^( 10^n ) + 1 ) * RAD
  
  // compute new theta and new x, y coordinates
  theta += DTH; // increase theta value at every step
  x = (float)( CENTER_X + rad*Math.cos(theta) );
  y = (float)( CENTER_Y - rad*Math.sin(theta) );
  
  // draw a line as close to the center as 'pie' is close to 'Math.PI'
  stroke (FG_COLOR);
  line (prev_x, prev_y, x, y);
  
  // delete previous value of 'pie'
  noStroke ();
  fill (BG_COLOR);
  rect (0, height - TEXT_SIZE, width, height);
  
  // print 'pie' value on screen
  fill (FG_COLOR);
  text (String.format("%.15f", pie), width*0.5, height);
  
  prev_x = x;
  prev_y = y;
}
