class Particle {
PVector center;
float radius;
float lifespan;
Cylinder cylinder ;

Particle(PVector center, float radius) {
  this.center = center.copy();
  this.lifespan = 255;
  this.radius = radius;
   cylinder = new Cylinder();

}

void run() {
  display();
}

// Method to display
void display() {
 cylinder.draw(center.x,center.y);
}
// Is the particle still useful?
// Check if the lifetime is over.

boolean isDead() {
  
    if(mover.checkCylinderCollision(center)){
        return true;
      } else {
        return false;
  }
}

}
