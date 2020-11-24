String filename = "/home/ilich/sketchbook/photos/steve-mccurry-1.jpg";

PImage img;

int xmargin;
int ymargin;
int distance;

void setup() {
    
  randomSeed(0);
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
  
  for (i=0; i<800; i++) {
    _draw(i);
  }
  saveImage(i);
}

void _draw(int i) {
  int size = int(random(10, distance));
  
  int x1 = int(random(0, img.width-size));
  int y1 = int(random(0, img.height-size));
  
  println(x1,y1,size, "->", i);
  
  color c = extractColorFromImage(img, x1,y1, size,size);
  fill(c, 75);
  stroke(c, 120);
  strokeWeight(3);
  square(x1, y1, size);
}

void saveImage(int frame) {
  PImage partialSave = get(
    floor(xmargin), 
    floor(ymargin), 
    img.width, 
    img.height);

  println("saving", frame);

  String[] pathComponents = filename.split("/");
  pathComponents[pathComponents.length-1]="random-squares-"+frame+"-"+pathComponents[pathComponents.length-1];

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
