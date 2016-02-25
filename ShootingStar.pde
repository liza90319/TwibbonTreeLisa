class ShootingStar{
  //GLOBAL VARIABLE
  int[] ShootingStarX= new int[60];
  int[] ShootingStarY= new int[60];
  int[] ShootingStarSize= new int[30];
  float ShootingstarFadeSize = 0;
  float speedX = -2;
  float speedY = -.5;
 
  //CONSTRUCTOR
    ShootingStar(){
    ShootingStarX = shootX;
    ShootingStarY = shootY;

  }
 
  //FUNCTIONS
  void run(){
  drawShootingStar();
  move();
  fade();
  newShootingStarInit();
  }
 
  void move(){
      // move the shooting star along it's path
    for (int i = 0; i < shootX.length-1; i++) {
      shootX[i] = shootX[i+1];
      shootY[i] = shootY[i+1];
    }
  }
 
  void fade(){
    if (ssTimer >= 0 && ssTimer < shootX.length) {
      shootX[shootX.length-1] = int(startX + ssDeltaX*(ssTimer));
      shootY[shootY.length-1] = int(startY + ssDeltaY*(ssTimer));
      ssTimer++;
      if (ssTimer >= shootX.length) {
        ssTimer = -1; // end the shooting star
      }
    }
  }
 
 
  void drawShootingStar(){
      // draw the shooting star
      for (int i = 0; i < shootX.length-1; i++) {
        int shooterSize = max(0,int(meteorSize*i/shootX.length));
        // to get the tail to disappear need to switch to noStroke when it gets to 0
        if (shooterSize > 0) {
          strokeWeight(shooterSize);
          stroke(255);
         
        }
        else
          noStroke();
        line(shootX[i], shootY[i], shootX[i+1], shootY[i+1]);
        //text(status.getText(), shootX[i], shootY[i], 0, 100);
        //ellipse(shootX[i], shootY[i], meteorSize*i/shootX.length,meteorSize*i/shootX.length);
      }
      meteorSize*=0.94; // shrink the shooting star as it fades
  }
  
  void newShootingStarInit(){
    if (random(20) < 1 && ssTimer == -1) {
      newShootingStar();
    }
  }
  
  void newShootingStar() {
    int endX, endY;
    startX = (int)random(width);
    startY = (int)random(height);
    endX = (int)random(width);
    endY = (int)random(height);
    ssDeltaX = (endX - startX)/(float)(shootX.length);
    ssDeltaY = (endY - startY)/(float)(shootY.length);
    ssTimer = 0; // starts the timer which ends when it reaches shootX.length
    meteorSize = METEOR_SIZE;
    // by filling the array with the start point all lines will essentially form a point initialy
    
    for (int i = 0; i < shootX.length; i++) {
      shootX[i] = startX;
      shootY[i] = startY;
    }
  }
  
}


class FadingText {
  String txt;
  float alpha;
  float r, g, b, x, y;

  FadingText (String _txt) {
    txt = _txt;
    alpha = 255;
    r = random(125, 255);
    g = random(125, 255);
    b = random(125, 255);

    x = random(0, 1280);
    y = random(100, 720);
  }

  void display() {
    textSize(15);
    noStroke();
    fill(r, g, b, alpha);
    text(txt, x, y);
    alpha-=4;// fading speed
  }

  boolean isDone() {  
    return alpha < 0;
  }
}