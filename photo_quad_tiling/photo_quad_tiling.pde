import java.nio.file.Path; 
import java.nio.file.Paths; 
import java.util.Arrays;

int sideCells = 20;

float cellPadding = 3;
float deformOffset = 1.0;

String filename = "../photos/<image here>";

void setup() {
  size(600, 600);

  background(255, 255, 255);


  PImage img = loadImage(filename);

  if (img.height > img.width) {
    img.resize(0, height);
  } else {
    img.resize(width, 0);
  }

  int cellSize = height/sideCells;

  int columns = img.width / cellSize;
  int rows = img.height / cellSize;

  float marginLeft = (width - img.width)/2;
  println(width, img.width, img.width, columns, cellSize);
  println(marginLeft);

  float marginTop = (height - img.height)/2; 

  translate(marginLeft, marginTop);
  //image(img,0,0);
  translate(
    (img.width - columns*cellSize)/2, 
    (img.height - rows*cellSize)/2
    );

  println(cellSize, columns, rows);


  int[][] grid = new int[columns][rows];

  //populate grid with 1s
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = 1;
    }
  }

  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      float r = random(1);
      if (r < 0.3 && grid[i][j] != 0 && i < (columns-1) && grid[i+1][j] == 1) { // sideways rect
        grid[i][j] = 2;
        grid[i+1][j] = 0;
      } else if (r < 0.6 && grid[i][j] != 0 && j < (rows-1) && grid[i][j+1] == 1) { // standing rect
        grid[i][j] = 3;
        grid[i][j + 1] = 0;
      } else if (r < 0.8 && grid[i][j] != 0 && i < (columns-1) && j < (rows-1) && grid[i+1][j] == 1 && grid[i][j+1] == 1 && grid[i + 1][j + 1] == 1) { // big square
        grid[i][j] = 4;
        grid[i+1][j] = 0;
        grid[i][j + 1] = 0;
        grid[i + 1][j + 1] = 0;
      } else { // small square
        // noop
      }
    }
  }

  float cellWidth = cellSize;
  float cellHeight = cellSize;

  //draw quads
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      float x = (i * cellWidth);
      float y = (j * cellHeight);

      float startX = x + cellPadding;
      float startY = y + cellPadding;
      float shortWidth = x + cellWidth - cellPadding;
      float shortHeight = y + cellHeight - cellPadding;
      float longWidth = x + cellWidth * 2 - cellPadding;
      float longHeight = y + cellHeight * 2 - cellPadding;

      if (grid[i][j] != 0) {
        fill(extractColorFromImage(img, rows, columns, grid[i][j], i, j));
      }
      if (grid[i][j] == 1) {
        filledQuad(startX, startY, shortWidth, startY, shortWidth, shortHeight, startX, shortHeight);
        emptyQuad(startX, startY, shortWidth, startY, shortWidth, shortHeight, startX, shortHeight);
      } else if (grid[i][j] == 2) {
        filledQuad(startX, startY, longWidth, startY, longWidth, shortHeight, startX, shortHeight);
        emptyQuad(startX, startY, longWidth, startY, longWidth, shortHeight, startX, shortHeight);
      } else if (grid[i][j] == 3) {
        filledQuad(startX, startY, shortWidth, startY, shortWidth, longHeight, startX, longHeight);
        emptyQuad(startX, startY, shortWidth, startY, shortWidth, longHeight, startX, longHeight);
      } else if (grid[i][j] == 4) {
        filledQuad(startX, startY, longWidth, startY, longWidth, longHeight, startX, longHeight);
        emptyQuad(startX, startY, longWidth, startY, longWidth, longHeight, startX, longHeight);
      }
    }
  }

  PImage partialSave = get(
    floor(marginLeft), 
    floor(marginTop), 
    img.width, 
    img.height);

  String[] pathComponents = filename.split("/");
  pathComponents[pathComponents.length-1]="quad-"+pathComponents[pathComponents.length-1];

  partialSave.save(String.join("/", pathComponents));
  noLoop();
}

void filledQuad(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  noStroke();
  quad(
    x1 + random(-deformOffset, deformOffset), 
    y1 + random(-deformOffset, deformOffset), x2 + random(-deformOffset, deformOffset), y2 + random(-deformOffset, deformOffset), x3 + random(-deformOffset, deformOffset), y3 + random(-deformOffset, deformOffset), x4 + random(-deformOffset, deformOffset), y4 + random(-deformOffset, deformOffset));
}

void emptyQuad(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  stroke(80);
  strokeWeight(1.25);
  strokeJoin(ROUND);
  noFill();
  quad(x1 + random(-deformOffset, deformOffset), y1 + random(-deformOffset, deformOffset), x2 + random(-deformOffset, deformOffset), y2 + random(-deformOffset, deformOffset), x3 + random(-deformOffset, deformOffset), y3 + random(-deformOffset, deformOffset), x4 + random(-deformOffset, deformOffset), y4 + random(-deformOffset, deformOffset));
}

color extractColorFromImage(PImage img, int rows, int columns, int gridValue, int x, int y) {
  int h = img.height/rows;
  int w = img.width/columns;

  switch(gridValue) {
  case 2:
    w = w *2;
    break;
  case 3:
    h = h *2;
    break;
  case 4:
    h = h *2;
    w = w *2;
    break;
  }


  PImage imgChunk = img.get(x*img.height/rows, y*img.width/columns, h, w );
  imgChunk.loadPixels();
  int r = 0, g = 0, b = 0;
  for (int i=0; i<imgChunk.pixels.length; i++) {
    color c = imgChunk.pixels[i];
    r += c>>16&0xFF;
    g += c>>8&0xFF;
    b += c&0xFF;
  }
  r /= imgChunk.pixels.length;
  g /= imgChunk.pixels.length;
  b /= imgChunk.pixels.length;

  return color(r, g, b);
}
