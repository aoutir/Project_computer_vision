class Robotnik{


Robotnik() {
 image = loadImage("robotnik.png"); // load the texture
  s = loadShape("robotnik.obj"); 
  beginShape();

  s.rotateX(3.14);
  s.scale(100);
  s.translate(0 , -cylinder.cylinderHeight+ TALL/2,0);
  texture(image);
  endShape();

}

void draw(float x , float z ) {

 gameSurface.pushMatrix();
 gameSurface.translate(x,0,z);
 gameSurface.shape(s, 0, 0, 70, 100) ;
 gameSurface.popMatrix();


}


}
