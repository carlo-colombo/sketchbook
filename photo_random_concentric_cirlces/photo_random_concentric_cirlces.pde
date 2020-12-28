//String filename = "/home/ilich/sketchbook/photos/s-l400.jpg";
//String filename = "/home/ilich/sketchbook/photos/srilanka.jpg";
//String filename = "/home/ilich/sketchbook/photos/srilanka2.jpg";
//String filename = "/home/ilich/sketchbook/photos/IMG_20180530_221450-EFFECTS.jpg";
//String filename = "/home/ilich/sketchbook/photos/iceland.jpg";
//String filename = "//home/ilich/sketchbook/photos/santa3.jpg";
String filename = "/home/ilich/sketchbook/photos/IMG_20191201_151800.jpg";

int seed = 2;

PImage img;

int xmargin;
int ymargin;
int distance;
int iterations = 150;

void setup() {

  randomSeed(seed);
  size(1800  , 1800);

  img = loadImage(filename);

  if (img.height > img.width) {
    img.resize(0, height);
  } else {
    img.resize(width, 0);
  }
  xmargin = (width - img.width)/2;
  ymargin = (height - img.height)/2;
  distance = height/12;

  /* tint(255, 60);
     image(img, xmargin, ymargin);
     filter(GRAY);
  */
  background(extractColorFromImage(img, 0,0,img.width, img.height));


  translate(xmargin, ymargin);

  int i;

  for (i=0; i<iterations; i++) {
    _draw(i);
  }
  saveImage(i);
}

void _draw(int i) {
  int circles = int(random(0,20));
  
  
  int size = circles * 5 * 3;

  int x1 = int(random(size, img.width-size));
  int y1 = int(random(size, img.height-size));

  println(x1,y1,size, "->", i);
  
  
  strokeWeight(5);
  noFill();
  for (int j =0;j< circles; j++){
    int radius = (j+1)*5*3;
    color c = extractColorFromImage(img, x1-radius,y1-radius, radius*2,radius*2);
    
    stroke(c);
    circle(x1,y1, radius*2);
  }
  

  
  //fill(c, 75);
  //stroke(c, 120);
  //square(x1, y1, size);
}

void saveImage(int frame) {
  PImage partialSave = get(
                           floor(xmargin),
                           floor(ymargin),
                           img.width,
                           img.height);

  println("saving", frame);

  String[] pathComponents = filename.split("/");
  pathComponents[pathComponents.length-1]="random-concentric-circles-"+frame+"-"+seed+"-"+pathComponents[pathComponents.length-1];

  partialSave.save(String.join("/", pathComponents));
}

void mouseClicked() {
  saveImage(frameCount);
}

color extractColorFromImage(PImage img, int x, int y, int x2, int y2) {
  PImage imgChunk = img.get(x,y,x2,y2);

  if (imgChunk.pixels.length ==0) {
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
