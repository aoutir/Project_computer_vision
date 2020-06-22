class Mover { 


PVector location;
PVector velocity;
PVector gravityForce;
float gravityConstant=1;
float radius = 15 ;
float normalForce = 1;
float mu = 0.3;
float frictionMagnitude = normalForce * mu;

float totalScore;
float lastScore;


Mover() {
location = new PVector(0, 0,0);
velocity = new PVector(0, 0,0); 
gravityForce= new PVector(0,0,0);
totalScore=0;
lastScore=0;
}
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
void display() {
         gameSurface.pushMatrix();
         gameSurface.stroke(0);
         gameSurface.strokeWeight(2);
         gameSurface.fill(127);
         gameSurface.translate(location.x,-TALL,location.z);
         gameSurface.sphere(radius);
         gameSurface.popMatrix();
}
float ela=0.5;
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


boolean checkCylinderCollision(PVector vec ){
    float dist = sqrt(pow((location.x - vec.x),2)+pow((location.z- vec.y),2));
    if(dist <= cylinderBaseSize + radius){
  
      PVector normal = new PVector(location.x - vec.x, 0, location.z - vec.y);
      PVector n = normal.copy().normalize();
   
      float a = PVector.dot(n,velocity)*2;
      velocity = PVector.sub(velocity,PVector.mult(n,a));

      location.x = location.x + normal.x/(radius + cylinderBaseSize);
      location.z = location.z + normal.z/(radius+cylinderBaseSize);
      
       totalScore += velocity.mag();
      lastScore = velocity.mag();
        //timeIndex++;
      return true;
    }
     return false;   
  }

}
