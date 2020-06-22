  PGraphics scoreSurface;
  PGraphics gameSurface;
  PGraphics topView;
  PGraphics scoreBoard;
  PGraphics barChart;
  
  
  Mover mover;
  Cylinder cylinder;
  Robotnik robot;
  int SIZE=300;
  int TOPVIEW_SIZE=150;
  int BARCHART_WIDTH=500;
  int BARCHART_HEIGHT=200;
  int SB_HEIGHT=200;
  
  //int DEPTH=20;
  boolean cylinderADDED=false;
  boolean en;
  ArrayList<PVector> cylinders;
  int TALL=30;
  float tmprx;
  float tmprz;
  ParticleSystem ps;
  PShape s;
  PImage image ;
  ImageProcessing imgproc;
  PVector rotations;
  
  //SCORE
  int time = 0;
  int scoreMax=0;
  int currentScore = 0;
  float[] scoreTable;
  float last_score;
  int timeIndex;
  float totalScore;
  float lastScore;
  
  HScrollbar scrollbar;
  
  
  void settings(){
    size(1700,700,P3D);
  }
  
  void setup() {
    noStroke();
    time=0;
    //gameSurface
    gameSurface = createGraphics(width, height-SB_HEIGHT,P3D);
    
   //Score setup
    scoreSurface = createGraphics(width, SB_HEIGHT, P2D);
    scoreSurface.beginDraw();
    scoreSurface.background(170);
    scoreSurface.endDraw();
    
    //TopView setup
    topView = createGraphics(TOPVIEW_SIZE, SB_HEIGHT, P2D);
    topView.beginDraw();
    topView.background(60, 10, 120);
    topView.endDraw();
    
    //scoreBoard setup
    scoreBoard = createGraphics(2*TOPVIEW_SIZE, 2*TOPVIEW_SIZE, P2D);
    scoreBoard.beginDraw();
    scoreBoard.background(60, 10, 120);
    scoreBoard.endDraw();
    
    //barchart setup
    barChart = createGraphics(BARCHART_WIDTH, BARCHART_HEIGHT, P2D);
    scoreBoard.beginDraw();
    scoreBoard.background(60, 10, 120);
    scoreBoard.endDraw();
    
    //scrollbar
    scrollbar = new HScrollbar(0.5*width, height - 20, BARCHART_WIDTH/ 2, 20);
    scoreTable = new float[barChart.width];
    
    cylinders = new ArrayList();
    mover = new Mover();
    cylinder = new Cylinder();
    robot = new Robotnik();
    
    
  scoreMax = (int)(barChart.width/2);
  scoreTable = new float[scoreMax];
  
    imgproc = new ImageProcessing();
    String []args = {"Image processing window"};
    PApplet.runSketch(args, imgproc);
    
    rotations = new PVector();
  
  }
  
  
  void draw() {
    drawGame();
    image(gameSurface, 0, 0);
    drawScore();
    image(scoreSurface, 0, height-SB_HEIGHT);
    drawTopView();
    image(topView, 10, height- SB_HEIGHT);
    drawScoreBoard();
    image(scoreBoard, TOPVIEW_SIZE+TALL, height- SB_HEIGHT);
    drawBarChart();
    image(barChart, 0.5*width, height - SB_HEIGHT);
    scrollbar.update();
    scrollbar.display();
  
  }
  
  
  
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
  void keyReleased(){
    if(key == CODED){
      if(keyCode == SHIFT){
        en = false;
        rx = tmprx;
        rz = tmprz;
      }
    }
  }
  
  void mouseClicked(){
            
    gameSurface.pushMatrix();        
    if(en){
        if(((abs(mouseX -width/2) <= SIZE/2-cylinderBaseSize) && (abs(mouseY -height/2) <= SIZE/2-cylinderBaseSize))){
          cylinders = new ArrayList();
           ps = new ParticleSystem(new PVector(mouseX -width/2,mouseY-height/2,0));
           robot.draw(mouseX -width/2,mouseY-height/2);
        }
      }
      gameSurface.popMatrix();
  }
  
  float a=1.0;
  float rx;
  float rz;
  
  void mouseReleased(){
    cylinderADDED=false;
  }
    
  void mouseDragged() 
  {
    if (mouseY < gameSurface.height) {
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
  }
  
  
  
  float e = 1;
  void mouseWheel(MouseEvent event) {
    e=e+0.2*event.getCount();
    if(e<0.25){
      e=0.2;
    }
  }
  
  void drawScore(){
    scoreSurface.beginDraw();
    scoreSurface.background(190);
    scoreSurface.endDraw();
  }
  
  void drawGame(){
    
    
  gameSurface.beginDraw();
  gameSurface.pushMatrix();
  gameSurface.directionalLight(50, 100, 125, 0, -1, 0);
  gameSurface.ambientLight(102, 102, 102);
  gameSurface.background(220, 240, 255);
  
  gameSurface.translate(gameSurface.width/2, gameSurface.height/2, 0);
  
  rotations = imgproc.getRotations();
     
      if(rotations != null){
         rx = rotations.x;
         rz =  rotations.y;
     
      }
   
  if(!en){
  gameSurface.rotateX(rx);
  gameSurface.rotateZ(rz);
  mover.update();
  mover.checkEdges();
  for(PVector c : cylinders){
  mover.checkCylinderCollision(c);
  }
  }else{
    gameSurface.rotateX(-PI/2);
  }
  
  gameSurface.box(SIZE,TALL,SIZE);
  
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
  gameSurface.popMatrix();
  gameSurface.endDraw();
  }
  float scale = TOPVIEW_SIZE/(SIZE+0.0001);
  
  void drawTopView(){
    topView.beginDraw();
    topView.fill(60);
    topView.rect(0, 0, topView.height, topView.width);
    topView.fill(250);
    topView.translate(TOPVIEW_SIZE/2, TOPVIEW_SIZE/2);
    for (PVector c : cylinders) {
      topView.ellipse(c.x*scale, c.y*scale, 2*cylinderBaseSize*scale, 2*cylinderBaseSize*scale);
    }
    topView.noStroke();
    topView.fill(199, 1, 1);
    topView.ellipse(mover.location.x*scale, mover.location.z*scale, 2*mover.radius*scale, 2*mover.radius*scale);
    topView.endDraw();
  } 
  
  void drawScoreBoard() {
    int line_size = 25;
    int margin_size = 10;
  
    scoreBoard.beginDraw();
    scoreBoard.background(100);
    scoreBoard.stroke(255);
    scoreBoard.fill(0);
  
    // Setting the text size and content
    scoreBoard.textSize(20);
    scoreBoard.text("Total Score", 20, line_size + margin_size);
    scoreBoard.text("" + nf((float) mover.totalScore ,0,3), 20, (margin_size + 2*line_size));
   
    scoreBoard.text("Velocity", 20, margin_size + 3*line_size);
    scoreBoard.text("" +nf((float) mover.velocity.mag(),0,3), 20, margin_size + 4*line_size);
  
    scoreBoard.text("Last Score", 20, margin_size + 5*line_size);
    scoreBoard.text("" + nf((float) mover.lastScore,0,3), 20, margin_size + 6*line_size);
    scoreBoard.endDraw();
  }
  
  void drawBarChart(){
    
   int rectWidth = 1 + (int)(20*scrollbar.getPos());
  int blockHeight = 5;

  if (millis() - time >= 1000) {
    barChart.beginDraw();
    barChart.background(255);

    time = millis();
    currentScore ++;

    for (int i = scoreMax - 1; i > 0; i--) {
      scoreTable[i] = scoreTable[i-1];
    }
    scoreTable[0] = mover.totalScore;

    
    println(blockHeight);
  
    
    for (int i = 0; i < scoreMax; i++) {
      int sign = - (int) Math.signum(scoreTable[i]);
      
       
        for (int j = 0; j < abs(scoreTable[i]/10); j++) {
          
          barChart.rect(i * rectWidth, barChart.height/2 +sign*( j * blockHeight  - blockHeight), rectWidth, blockHeight);
        }
      }
    

    barChart.endDraw();
  }
  }
