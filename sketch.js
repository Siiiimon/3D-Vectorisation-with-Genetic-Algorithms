var imgUrl = "eiffeltower.jpg";
var img;
var edges = [];
var counter = 0;
var agents = [];
var thresh = 0.12;

function preload() {
  img = loadImage(imgUrl);
}


function setup() {
  createCanvas(img.width, img.height);
  pixelDensity(1);
  image(img, 0, 0);
  filter(THRESHOLD, thresh);
  loadPixels();
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      var index = (x + y * width)*4;
      if (pixels[index] !== pixels[index+4]) {
        edges[counter] = [x, y];
        counter++;
      }
    }
  }
  updatePixels();
  for (var i = 0; i < edges.length; i++) {
    agents[i] = new Agent();
  }
}

function draw() {
  background(255);
  image(img, 0, 0);
  filter(THRESHOLD, thresh);
  fill(255, 0, 0);
  for (var i = 0; i < agents.length; i++) {
    agents[i].seek(createVector(edges[i][0], edges[i][1]));
    agents[i].update();
    agents[i].display();
  }
}
