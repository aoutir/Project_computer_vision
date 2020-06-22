class ParticleSystem {
ArrayList<Particle> particles;
PVector origin;
float particleRadius = cylinderBaseSize;

ParticleSystem(PVector origin) {
this.origin = origin.copy();
particles = new ArrayList<Particle>();
particles.add(new Particle(origin, particleRadius));
//totalScore=0;
}

void addParticle() {
PVector center;
int numAttempts = 1000;
for(int i=0; i<numAttempts; i++) {
  // Pick a cylinder and its center.
  int index = int(random(particles.size()));
  center = particles.get(index).center.copy();
  // Try to add an adjacent cylinder.
  float angle = random(TWO_PI);
  center.x += sin(angle) * 2*particleRadius;
  center.y += cos(angle) * 2*particleRadius;
 
  if(checkPosition(center)&&(frameCount%60==0)) {
    particles.add(new Particle(center, particleRadius));
     mover.totalScore-=10;
    mover.lastScore=-10;
    timeIndex++;
    
    break;
    }
  }
}

// Iteratively update and display every particle,
// and remove them from the list if their lifetime is over.
void run() {
  if( particles.size()> 0){
  for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if(p.isDead() && p.center.dist(origin)==0){
          particles = new ArrayList();
       
            //print("particles.size apres le for \n" + particles.size()) ;
          }
      else if (p.isDead()) {
        particles.remove(i);
      }
}
  }
}

boolean checkPosition(PVector center) {
 if ((center.x > (SIZE/2 - particleRadius)) || center.x < -SIZE/2+particleRadius||center.y > (SIZE/2 - particleRadius)|| center.y < -SIZE/2+particleRadius) {
      return false;
   }
  for(Particle p: particles){
   if(checkOverlap(center,p.center)){
     return false;
  }
  }
return true;
}

boolean checkOverlap(PVector c1, PVector c2) {
if(abs(c1.dist(c2))<2*particleRadius){
  return true;
}else{
  return false;
}
}
}
