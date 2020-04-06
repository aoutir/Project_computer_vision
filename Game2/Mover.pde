class Mover { 


PVector location;
PVector velocity;
PVector gravityForce;
float gravityConstant=1;
float radius = 15 ;
float normalForce = 1;
float mu = 0.1;
float frictionMagnitude = normalForce * mu;



/*
*@brief Constructor for Mover
*/
Mover() {
location = new PVector(0, 0,0);
velocity = new PVector(0, 0,0); 
gravityForce= new PVector(0,0,0);
}

/*
*@brief adds gravity force effects
*/
void update() {
  
        gravityForce.x = sin(rz) * gravityConstant;
        gravityForce.z = -sin(rx) * gravityConstant;
        
        velocity.add(gravityForce);
        
        PVector friction = velocity.copy();
        friction.mult(-1);
        friction.normalize();
        friction.mult(frictionMagnitude);
        velocity.add(friction);
         location.add(velocity);
        
      }

/* 
*@brief Method to display
*/      
void display() {
        pushMatrix();
        stroke(0);
        strokeWeight(2);
        fill(127);
        translate(location.x,-TALL,location.z);
        sphere(radius);
        popMatrix();
}
float ela=0.5;

/*
*@brief make the ball bounce when hitting the edges
*/
void checkEdges() {
  if ((location.x > SIZE/2-radius)) {
        velocity.x = velocity.x * -1*ela;
        location.x = SIZE/2-radius;
      }
   if((location.x < -SIZE/2+radius)){
     velocity.x = velocity.x * -1*ela;
        location.x = -SIZE/2+radius;
   }
   
if ((location.z > SIZE/2-radius)) {
        velocity.z = velocity.z * -1*ela;
        location.z = SIZE/2-radius;
      }
      
    if((location.z < -SIZE/2+radius)){
       velocity.z = velocity.z * -1*ela;
        location.z = -SIZE/2+radius;
   }
}


/*
*@brief look at the current position of the sphere and the positions of all placed cylinders to check whether there is a collision. 
*In this case, the velocity of the sphere after the collision is updated.
*@param cylinders: where already placed cylinders are stored
*/
boolean checkCylinderCollision(PVector vec ){
    float dist = sqrt(pow((location.x - vec.x),2)+pow((location.z- vec.y),2));
    if(dist <= cylinderBaseSize + radius){
      print(dist);
      PVector normal = new PVector(location.x - vec.x, 0, location.z - vec.y);
      PVector n = normal.copy().normalize();
      float a = PVector.dot(n,velocity)*2;
      velocity = PVector.sub(velocity,PVector.mult(n,a));
      location.x = location.x + normal.x/(radius + cylinderBaseSize);
      location.z = location.z + normal.z/(radius+cylinderBaseSize);
      
            
      return true;
    }
     return false;  
  }

}
