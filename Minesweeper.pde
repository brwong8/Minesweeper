import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int r = 0; r < NUM_COLS; r++) {
      buttons[i][r] = new MSButton(i, r);
    }
  }

  setMines();
}
public void setMines()
{
  //your code
  for (int i = 0; i < NUM_ROWS*2; i++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    } else i--;
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
for(int r = 0; r < NUM_ROWS;r++){
  for(int c = 0; c < NUM_COLS; c++){
    if(buttons[r][c].clicked==false && !mines.contains(buttons[r][c]))
    return false;
  }
}
return true;
}
public void displayLosingMessage()
{
  //your code here
  for(int i = 0; i < mines.size(); i++)
  if(mines.get(i).clicked == false)
  mines.get(i).mousePressed();
  
  buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel("U");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-1].setLabel(" ");
  buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("L");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("O");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("S");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("E");
}
public void displayWinningMessage()
{
  //your code here
  buttons[NUM_ROWS/2][(NUM_COLS/2-4)].setLabel("Y");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel("U");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-1].setLabel(" ");
  buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("W");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("I");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("N");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r > NUM_ROWS || c > NUM_COLS || r < 0 || c < 0) {
    return false;
  }
  return true;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int i = row-1; i <= row+1; i++) {
    for (int p = col-1; p <= col+1; p++) {
      if (mines.contains(buttons[i][p]) && isValid(i,p)) {
        numMines++;
      }
    if(mines.contains(buttons[row][col]))
    numMines--;
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
      } else {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow,myCol));
    } else {
      for (int i = myRow-1; i < myRow+1; i++) {
        for (int p = myCol-1; p < myCol+1; p++) {
          if (isValid(i, p) && buttons[i][p].clicked == false) {
            buttons[i][p].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
