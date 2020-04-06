class Particle {
PVector center;
float radius;
float lifespan;
Cylinder cylinder ;

/*
*@brief Constructor for Particle
*@param center 
*@param radius
*/
Particle(PVector center, float radius) {
  this.center = center.copy();
  this.lifespan = 255;
  this.radius = radius;
   cylinder = new Cylinder();

}

void run() {
  display();
}


/* 
*@brief Method to display
*/
void display() {
 cylinder.draw(center.x,center.y);
}

/*
*@brief Check if the lifetime of a particle is over
*@return true if partcile is not useful anymore, false otherwise
*/
boolean isDead() {
  
    if(mover.checkCylinderCollision(center)){
        return true;
      } else {
        return false;
  }
}

}
