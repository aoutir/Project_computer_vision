Mover mover;
Cylinder cylinder;
Robotnik robot;
int SIZE=500;
boolean en;
ArrayList<PVector> cylinders;
int TALL=30;
float tmprx;
float tmprz;
ParticleSystem ps;
PShape s;
PImage image ;

void setup() {
  size(1000, 1000, P3D);
  cylinders = new ArrayList();
  noStroke();
  mover = new Mover();
  cylinder = new Cylinder();
  robot = new Robotnik();
}

/*
*@brief draw
*/
void draw() {
   
directionalLight(50, 100, 125, 0, -1, 0);
ambientLight(102, 102, 102);
background(250);

pushMatrix();
translate(width/2, height/2, 0);
rotateX(rx);
rotateZ(rz);
box(SIZE,TALL,SIZE);


if(!en){
mover.update();
mover.checkEdges();
for(PVector c : cylinders){
mover.checkCylinderCollision(c);
}

}
mover.display();


if(ps !=null){
  cylinders = new ArrayList();
  for(Particle p : ps.particles){
  cylinders.add(p.center);
}
}

if(ps != null && ps.particles.size() > 0){
  robot.draw(ps.origin.x,ps.origin.y);
  ps.addParticle() ;
  ps.run();
}

popMatrix();
}


/*
*@brief updates when the keyboard is pressed 
*/
void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      en = true;
      tmprx = rx;
      tmprz = rz;
      rx = -PI/2;
      rz = 0;
    }
  }
}

/*
*@brief updates when the keyboard is released 
*/
void keyReleased(){
  if(key == CODED){
    if(keyCode == SHIFT){
      en = false;
      rx = tmprx;
      rz = tmprz;
    }
  }
}

/*
*@brief updates when the mouse is clicked 
*/
void mouseClicked(){
          
  pushMatrix();        
  if(en){
      if(((abs(mouseX -width/2) <= SIZE/2-cylinderBaseSize) && (abs(mouseY -height/2) <= SIZE/2-cylinderBaseSize))){
        cylinders = new ArrayList();
         ps = new ParticleSystem(new PVector(mouseX -width/2,mouseY-height/2,0));
      }
    }
    popMatrix();
}

float a=1.0;
float rx;
float rz;

/*
*@brief updates plate position according to mouse directions
*/  
void mouseDragged() 
{
  
  float deltaX=(mouseY-pmouseY)/1000.;
  rx+=deltaX*PI*e;
  if(rx>PI/3){
    rx=PI/3;
  }
  if(rx<-PI/3){
    rx=-PI/3;
  }
 
  float deltaY=(mouseX-pmouseX)/1000.;
  rz+=deltaY*PI*e;
  if(rz>PI/3){
    rz=PI/3;
  }
  if(rz<-PI/3){
    rz=-PI/3;
  }    
}


/*
*@brief method that changes the speed of tilting according to mouse wheel
*@param event
*/
float e = 1;
void mouseWheel(MouseEvent event) {
  e=e+0.2*event.getCount();
  if(e<0.25){
    e=0.2;
  }
}
