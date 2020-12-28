String filename = "/home/ilich/sketchbook/photos/IMG_20180101_120004.jpg";

PImage img;

int xmargin;
int ymargin;
int distance;
int seed = 3;

void setup() {
  randomSeed(seed);
  size(3600 , 3600);
  background(255, 255, 255);

  img = loadImage(filename);

  if (img.height > img.width) {
    img.resize(0, height);
  } else {
    img.resize(width, 0);
  }
  xmargin = (width - img.width)/2;
  ymargin = (height - img.height)/2;
  distance = height/30;

  int i;
  for (i=0; i<=49*height; i++) {
    _draw();
  }
  saveImage(i);
}

void _draw() {
  int x1 = int(random(xmargin, width - xmargin));
  int y1 = int(random(ymargin, height - ymargin));

  int x2 = int(random(max(x1-distance, xmargin), min(x1+distance, width - xmargin)));
  int y2 = y1 + (x2-x1);
  
 /* if (random(1)>0.5){
  x2 = x2 - 2*(x2-x1);
  }*/  
  
  strokeWeight(36);
  strokeCap(PROJECT);
  stroke(extractColorFromImage(img, x1 - xmargin, y1 - ymargin, x2- xmargin, y2- ymargin));
  if (x1==x2 && y1 == y2) return;
  line(x1, y1, x2, y2);
}

void saveImage(int frame) {
  PImage partialSave = get(
    floor(xmargin), 
    floor(ymargin), 
    img.width, 
    img.height);

  println("saving", frame);

  String[] pathComponents = filename.split("/");
  pathComponents[pathComponents.length-1]="random-lines2-"+frame+"-"+seed+"-"+pathComponents[pathComponents.length-1];

  partialSave.save(String.join("/", pathComponents));
}

void mouseClicked() {
  saveImage(frameCount);
}

color extractColorFromImage(PImage img, int x, int y, int x2, int y2) {
  int minx = min(x, x2);
  int miny = min(y, y2);

  PImage imgChunk = img.get(minx, miny, max(x, x2)-minx, max(y, y2) - miny);

  if (imgChunk.pixels.length ==0) {
    //println(x, y, x2, y2);
    return #ffffff;
  }

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
