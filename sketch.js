var imgUrl = "eiffeltower.jpg";
var img;
var edges = [];
var counter = 0;

function preload() {
  img = loadImage(imgUrl);
}


function setup() {
  createCanvas(img.width, img.height);
  pixelDensity(1);
  image(img, 0, 0);
  filter(THRESHOLD, 0.26);
  loadPixels();
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      var index = (x + y * width)*4;
      if (pixels[index] !== pixels[index+4]) {
        set(x, y, color(0, 255, 0));
        edges[counter] = [x, y]
        counter++
      }
    }
  }
  updatePixels();
}
