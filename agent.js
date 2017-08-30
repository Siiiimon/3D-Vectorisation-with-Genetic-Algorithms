var Agent = function() {
  this.position = createVector(20, 20);
  this.velocity = createVector(0, 0);
  this.acceleration = createVector(0, 0);
  this.maxspeed = 5;
  this.maxforce = 0.1;

  this.applyForce = function(f) {
    this.acceleration.add(f);
  };

  this.seek = function(target) {
    var desired = p5.Vector.sub(target,this.position);
    var d = desired.mag();
    if (d < 100) {
      var m = map(d,0,100,0,this.maxspeed);
      desired.setMag(m);
    } else {
      desired.setMag(this.maxspeed);
    }
    var steer = p5.Vector.sub(desired,this.velocity);
    steer.limit(this.maxforce);
    this.applyForce(steer);
  };

  this.update = function() {
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.maxspeed);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  };

  this.display = function() {
    noStroke();
    fill(0, 255, 0);
    ellipse(this.position.x, this.position.y, 1, 1);
  };
};
