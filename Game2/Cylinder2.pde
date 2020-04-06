static final float cylinderBaseSize = 25;

class Cylinder{
float cylinderHeight = 50;
int cylinderResolution = 40;

PShape openCylinder = new PShape();
PShape topCylinder = new PShape();
PShape bottomCylinder = new PShape();
PShape cylinder = new PShape();

/*
*@brief Constructor for cylinder
*/
Cylinder() {

//create cylinder
float angle;
float[] x = new float[cylinderResolution + 1];
float[] y = new float[cylinderResolution + 1];
//get the x and y position on a circle for all the sides
for(int i = 0; i < x.length; i++) {
angle = (TWO_PI / cylinderResolution) * i;
x[i] = sin(angle) * cylinderBaseSize;
y[i] = cos(angle) * cylinderBaseSize;
}
openCylinder = createShape();
openCylinder.beginShape(QUAD_STRIP);
//draw the border of the cylinder
for(int i = 0; i < x.length  ; i++) {
openCylinder.vertex(x[i], 0, y[i]);
openCylinder.vertex(x[i] ,-cylinderHeight ,y[i] );
}
openCylinder.endShape();

//draw the top of the cylinder 
topCylinder = createShape();
topCylinder.beginShape(TRIANGLE_FAN);
topCylinder.vertex(0, -cylinderHeight, 0);

for(int i = 0; i < x.length ; i++){
      topCylinder.vertex(x[i], -cylinderHeight,y[i]);
}
topCylinder.endShape();

//draw the bottom of the cylindre 
bottomCylinder = createShape();
bottomCylinder.beginShape(TRIANGLE_FAN);
bottomCylinder.vertex(0, 0, 0);

for(int i = 0; i < x.length ; i++){
      bottomCylinder.vertex(x[i], 0,y[i] );
      
}
bottomCylinder.endShape();

cylinder = createShape(GROUP);
cylinder.addChild(openCylinder);
cylinder.addChild(topCylinder);
cylinder.addChild(bottomCylinder);

}

/*
*@brief draw
*@param x
*@param y
*/
void draw(float x , float z ) {

pushMatrix();
translate(x,0,z);
shape(cylinder);
popMatrix();


}


}
