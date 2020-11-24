String filename = "/home/ilich/sketchbook/photos/srilanka.jpg";

PImage img;

int xmargin;
int ymargin;
int distance;

void setup() {
    
  randomSeed(0);
  size(600, 600);
  background(255, 255, 255);

  img = loadImage(filename);

  if (img.height > img.width) {
    img.resize(0, height);
  } else {
    img.resize(width, 0);
  }
  xmargin = (width - img.width)/2;
  ymargin = (height - img.height)/2;
  distance = height/10;

  //tint(255, 60);
  //image(img, xmargin, ymargin);
//  filter(GRAY);

  int i;
  for (i=0; i<10000; i++) {
    _draw();
  }
  saveImage(i);
}

void _draw() {
  int size = int(random(10, 100));
  int r = size/2;
  
  int x1 = int(random(xmargin+r, width - xmargin-r));
  int y1 = int(random(ymargin+r, height - ymargin-r));
  
  fill(extractColorFromImage(img, x1-r -xmargin,y1 -r-ymargin, size,size), 75);
  //rotate(random(0,TWO_PI));
  noStroke();
  arc(x1, y1, size, size, 0, QUARTER_PI+PI, CHORD);
}

void saveImage(int frame) {
  PImage partialSave = get(
    floor(xmargin), 
    floor(ymargin), 
    img.width, 
    img.height);

  println("saving", frame);

  String[] pathComponents = filename.split("/");
  pathComponents[pathComponents.length-1]="random-circles-"+frame+"-"+pathComponents[pathComponents.length-1];

  partialSave.save(String.join("/", pathComponents));
}

void mouseClicked() {
  saveImage(frameCount);
}

color extractColorFromImage(PImage img, int x, int y, int x2, int y2) {
  println(x,y,x2,y2);
  PImage imgChunk = img.get(x,y,x2,y2);

  if (imgChunk.pixels.length ==0) {
    //println(x, y, x2, y2);
    return #ffffff;
  }
  
  //image(imgChunk,50,50);

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
