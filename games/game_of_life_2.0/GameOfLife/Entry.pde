class Entry
{
  String title;
  Option[] option;
  String selected;
  int Y;
  int txtSize = height/50;
  int LEN, RAD = txtSize*3/4;
  int i;
  
  class Option
  {
    String name;
    int num;
    int X;
    
    Option (String s, int n, int len)
    {
      name=s;
      num=n;
      X = width*(num+1)/(len+1);
    }
    
    boolean isPressed ()
    {
      return (mouseX >= X - (LEN/2+RAD) && mouseX <= X + (LEN/2+RAD) && mouseY >= Y + txtSize*3 && mouseY <= Y + txtSize*3 + 2*RAD);      
    }  
  }
  
  Entry (String tit, String[] op, int num)
  {    
    title = tit;  
    Y = num * 5 * txtSize;
    LEN = width / (op.length+3);
    File entryFile = dataFile (title + ".entry");
    
    option = new Option[op.length];
    
    for (i=0; i < op.length; i++)
      option[i] = new Option (op[i], i, op.length);
    
    if (!entryFile.isFile ())
      saveEntry (0);
      
    loadEntry ();
  }
  
  void saveEntry (int sel_num)
  {
    if (android)
      saveStrings (title + ".entry", new String[] {option[sel_num].name});
    else
      saveStrings ("./data/" + title + ".entry", new String[] {option[sel_num].name});
  }
  
  void loadEntry ()
  {
    String[] sel;
    
    if (android)
      sel = loadStrings (title + ".entry");
    else
      sel = loadStrings ("./data/" + title + ".entry");
    
    selected = sel[0];
  }    
    
  void show ()
  {
    loadEntry ();
    
    fill (255);
    textAlign (CENTER);
    textSize (txtSize);
    text (title + ":", width/2, Y + 2*txtSize);
    
    for (i=0; i < option.length; i++)
    {
      if (option[i].name.equals (selected))
      {
        fill (0, 0, 255);
        noStroke ();
        
        rect (option[i].X - LEN/2, Y + txtSize*3, LEN, RAD*2);
        circle (option[i].X - LEN/2, Y + txtSize*3 + RAD, RAD*2);
        circle (option[i].X + LEN/2, Y + txtSize*3 + RAD, RAD*2);
      }
      
      fill (255);
      text (option[i].name, option[i].X, Y + 4*txtSize);
    }
  }
}
