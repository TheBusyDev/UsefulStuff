void drawBorders ()
{
  // draw borders
  fill (BORDER_COLOR);
  rect (-DIM, -DIM, DIM, height+DIM);
  rect (-DIM, -DIM, width+DIM, DIM);
  rect (COL*DIM, 0, DIM, height);
  rect (0, ROW*DIM, width, DIM);
}
