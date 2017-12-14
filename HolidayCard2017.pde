import processing.sound.*;

//key input array
boolean[] keys;

//basketball variables
float ballX, ballY;
int ballSize;
int ballColor = color(255, 140, 0);
float ballSpeedVert = 0;
PhysicsEngineBall bEngine;

//player1 variables
float p1x, p1y;
int player1Height, player1Width;
PGraphics p1;
PhysicsEnginePlayer p1Engine;

//player2 variables
float p2x, p2y;
int player2Height, player2Width;
PGraphics p2;
PhysicsEnginePlayer p2Engine;

//court
PGraphics b;

//scoreboard image
PImage scoreboard;

//jerseys 1 and 2
PImage one;
PImage two;

//mainmenu assets
PImage mainmenu;
PImage gameover;

//sound
SoundFile file;

//font variables
PFont f;

//Timer object
Timer t;

//gamescreen variable
int gamescreen;

//button boolean
boolean isOverPlay = false;
boolean isOverReplay = false;

void setup(){
  size(1000, 600);
  
  //jersey set up
  one = loadImage("data/one.png");
  two = loadImage("data/two.png");
  
  mainmenu = loadImage("data/MenuFinal.png");
  gameover = loadImage("data/Gameover.png");
  
  b = createGraphics(width, height);
  drawBackground();
  
  //key input setup
  keys = new boolean[10];
  for(int i = 0; i < keys.length; i++)
    keys[i] = false;
  
  //ball setup
  ballX = 250;
  ballY = 250;
  ballSize = 20;
  bEngine = new PhysicsEngineBall(ballSize / 2, ballSize, ballX, ballY, height - 50, 0, width);
  
  //player1 setup
  p1 = createGraphics(58,88);
  drawPlayerOne();
  p1x = 200;
  p1y = 100;
  player1Width = p1.width;
  player1Height = p1.height;
  p1Engine = new PhysicsEnginePlayer(player1Height, player1Width, p1x, p1y, height - 50, 0, width);
  
  //player2 setup
  p2 = createGraphics(58, 88);
  drawPlayerTwo();
  p2x = 500;
  p2y = 100;
  player2Width = p2.width;
  player2Height = p2.height;
  p2Engine = new PhysicsEnginePlayer(player2Height, player2Width, p2x, p2y, height - 50, 0, width);
  
  //sound setup
  file = new SoundFile(this, "data/music.mp3");
  file.amp(0.5);
  file.play();
  
  //scoreboardsetup
  scoreboard = loadImage("data/Scoreboard.png");
  
  //font stuff
  f = createFont("Calibri", 32);
  
  //timer stuff
  t = new Timer();
  t.start();
  
  //gamescreen stuff
  gamescreen = 1;
}

void draw(){
  if(gamescreen == 1)
    mainmenu();
  if(gamescreen == 2)
    drawGame();
  if(gamescreen == 3)
    endmenu();
}

//-----------------drawing methods------------------------//
void mainmenu(){
  image(mainmenu,0,0);
  isOverPlay = false;
  if(mouseX >= width/2-160/2 && mouseX <= width/2-160/2 + 160){
    if(mouseY >= 450 && mouseY <= 450 + 80){
      isOverPlay = true;
    }
  }
  drawPlayButton();
}

void endmenu(){
  image(gameover,0,0);
  isOverReplay = false;
  if(mouseX >= width/2-160/2 && mouseX <= width/2-160/2 + 160){
    if(mouseY >= 450 && mouseY <= 450 + 80){
      isOverReplay = true;
    }
  }
  drawReplayButton();
}

void drawPlayButton(){
  if(!isOverPlay){
    fill(255,215,0);
  }else{
    fill(204,229,213);
  }
  noStroke();
  int w = 160;
  int h = 80;
  rect(width/2-w/2, 450, w, h);
  fill(255);
  textFont(f);
  text("PLAY", width/2 - 38 + 4, 502);
}

void drawReplayButton(){
  if(!isOverReplay){
    fill(255,215,0);
  }else{
    fill(204,229,213);
  }
  noStroke();
  int w = 160;
  int h = 80;
  rect(width/2-w/2, 450, w, h);
  fill(255);
  textFont(f);
  text("Menu?", width/2 - 45, 506);
  
  if(Collision.p1score > Collision.p2score){
    text("Player One WON!", 400, 300);
  }else{
    text("Player Two WON!", 375, 300);
  }
}

void drawGame(){
  background(255);
  fill(135, 206, 250);
  rect(0,0, width, height/2 + 50);
  tint(185,185);
  image(b,0,0);
  noTint();
  drawCourt();
  
  if(Collision.isPossessed() == false){
    double gg = Math.random();
    if(gg > .5){
      Collision.doesP1(ballX, ballY, p1x, p1y);
      Collision.doesP2(ballX, ballY, p2x, p2y);
    }else{
      Collision.doesP2(ballX, ballY, p2x, p2y);
      Collision.doesP1(ballX, ballY, p1x, p1y);
    }
  }
  
  moveball();
  bEngine.applyGravity();
  bEngine.applyHorizontalSpeed();
  bEngine.bounce();
  if(Collision.ballOnRim(ballX, ballY, 895, 285)){
      bEngine.bounceOffRimRight();
  }
  if(Collision.ballOnRim(ballX, ballY, 105, 285 + 6)){
    bEngine.bounceOffRimLeft();
  }
  if(Collision.ballOnBackBoardRight(ballX, ballY)){
      bEngine.bounceOffBackboardRight();
  }
  if(Collision.ballOnBackBoardLeft(ballX, ballY)){
    bEngine.bounceOffBackboardLeft();
  }
  if(Collision.isClose2(ballX + 10, ballY + 10, 922.5 + 10, 288 + 5) && bEngine.getSpeedVert() > 0){
     if(t.intervalPassed(1)){
       Collision.p1score++;
     }
  }
  if(Collision.isClose3(ballX + 10, ballY + 10, 77.5 - 10, 288 + 5) && bEngine.getSpeedVert() > 0){
     if(t.intervalPassed(1)){
       Collision.p2score++;
     }
  }
  if(Collision.isPossessed()){
      if(Collision.p1possession){
        bEngine.dribble(p1x, p1y, p1Engine.isOnGround());
      }
      if(Collision.p2possession){
        bEngine.dribble(p2x, p2y, p2Engine.isOnGround());
      }
  }
  ballX = bEngine.getX();
  ballY = bEngine.getY();
  drawBall();
  
  movep1();
  p1Engine.applyGravity();
  p1Engine.applyHorizontalSpeed();
  p1Engine.bounce();
  p1Engine.bounce(895, 285, 895+55, 285+6);
  p1Engine.bounce2(0,285,50 + 55, 285 + 6);
  p1x = p1Engine.getX();
  p1y = p1Engine.getY();
  image(p1, p1x, p1y);
  
  movep2();
  p2Engine.applyGravity();
  p2Engine.applyHorizontalSpeed();
  p2Engine.bounce();
  p2Engine.bounce(895, 285, 895+55, 285+6);
  p2Engine.bounce2(0,285,50 + 55, 285 + 6);
  p2x = p2Engine.getX();
  p2y = p2Engine.getY();
  image(p2, p2x, p2y);
  
  image(scoreboard, 300, 10);
  
  //score number rendering
  textFont(f);
  fill(0);
  text(Collision.p1score, 300 + 16,50);
  fill(255);
  text(Collision.p2score, 650 + 15, 50);
  
  if(Collision.p1score >= 9 || Collision.p2score >= 9)
    gamescreen = 3;
}

void drawCourt(){
  stroke(0);
  fill(75);
  rect(-1,550,1001,600);
  
  //hoop left
  fill(200);
  rect(30,200,20,100);
  fill(255,0,0);
  rect(50,285,55,6);
  fill(0);
  rect(5,270,25,280);
  
  //hoop right
  fill(200);
  rect(950,200,20,100);
  fill(255,0,0);
  rect(895,285,55,6);
  fill(0);
  rect(970,270,25,280);

}

void drawBackground(){
  b.beginDraw();
  b.fill(170);
  b.rect(0,350,1000,200);
    for(int i = 0; i < 24; i++){
    b.fill((float)Math.random()*255, (float)Math.random()*255, (float)Math.random()*255) ;
    b.rect(52 + i * 910/24,390,19,19);
    b.ellipse(61.75 + i * 910/24,380,22,22);
    b.fill(255);
    b.ellipse(56.5 +i * 910/24,379,5,5);
    b.ellipse(66.5 +i * 910/24,379,5,5);
    b.rect(56 + i *910/24, 384,10,2);
  }
  
  //row6
  b.fill(170);
   b.rect(0,400,1000,150);
    for(int i = 0; i < 24; i++){
   b.fill((float)Math.random()*255, (float)Math.random()*255, (float)Math.random()*255) ;
    b.rect(52 + i * 910/24,440,19,19);
    b.ellipse(61.75 + i * 910/24,430,22,22);
    b.fill(255);
     b.ellipse(56.5 +i * 910/24,429,5,5);
    b.ellipse(66.5 +i * 910/24,429,5,5);
    b.rect(56 + i *910/24, 434,10,2);
  }
  
  //row7
  b.fill(170);
  b.rect(0,450,1000,100);
      for(int i = 0; i < 24; i++){
   b.fill((float)Math.random()*255, (float)Math.random()*255, (float)Math.random()*255) ;
    b.rect(52 + i * 910/24,490,19,19);
    b.ellipse(61.75 + i * 910/24,480,22,22);
    b.fill(255);
     b.ellipse(56.5 +i * 910/24,479,5,5);
    b.ellipse(66.5 +i * 910/24,479,5,5);
    b.rect(56 + i *910/24, 484,10,2);
  }
  
  
  //row8
  b.fill(170);
  b.rect(0,500,1000,50);
      for(int i = 0; i < 24; i++){
    b.fill((float)Math.random()*255, (float)Math.random()*255, (float)Math.random()*255) ;
    b.rect(52 + i * 910/24,540,19,19);
    b.ellipse(61.75 + i * 910/24,530,22,22);
    b.fill(255);
     b.ellipse(56.5 +i * 910/24,529,5,5);
    b.ellipse(66.5 +i * 910/24,529,5,5);
    b.rect(56 + i *910/24, 534,10,2);
  }

    b.stroke(0);
  b.fill(222,184,135);
  b.rect(-1,550,1001,600);
b.endDraw();
}


void drawBall(){
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void drawPlayerOne(){
  int offset = 15;
  p1.beginDraw();
  //hair
  p1.fill(0);
  p1.rect(0 + offset,0,28,25);
  
  //leftarmplayer
  p1.fill(143, 70, 29);
  p1.pushMatrix();
  p1.translate(9+ offset, 45);
  p1.rotate(PI/1.4);
  //rotate(30);
  //rect(105,659,10,20);
  p1.rect(0,0,10,20);
  p1.popMatrix();
  //rightarmplayer
  p1.pushMatrix();
  p1.translate(36+ offset,33);
  p1.rotate(PI/3.6);
  p1.rect(0,0,10,20);
  p1.popMatrix();
  
  //playerbody
  p1.fill(143, 70, 29);
  p1.rect(2+ offset,72,10,15);
  p1.rect(17+ offset,72,10,15);
  p1.rect(2+ offset,34,25,40);
  p1.ellipse(14+ offset,22,30,30);
  
  //jersey
  p1.fill(220,0,0);
  p1.rect(2.75+ offset,34,25,40);
  p1.fill(92,51,23);
  p1.ellipse(14.25+ offset, 34,15,15);
  
  p1.fill(143, 70, 29);
  p1.ellipse(14+ offset,22,30,30);

  p1.image(one, 0,10);
  
  //playerfacialfeatures
  p1.fill(0);
  p1.ellipse(9+ offset,20,5,5);
  p1.ellipse(19+ offset,20,5,5);
  p1.rect(8+ offset,27,12,1);
  p1.endDraw();
}

void drawPlayerTwo(){
  int offset = 15;
  p2.beginDraw();
  //hair
  p2.fill(0);
  p2.rect(0 + offset,0,28,25);
  
  //leftarmplayer
  p2.fill(234,192,134);
  p2.pushMatrix();
  p2.translate(9+ offset, 45);
  p2.rotate(PI/1.4);
  //rotate(30);
  //rect(105,659,10,20);
  p2.rect(0,0,10,20);
  p2.popMatrix();
  //rightarmplayer
  p2.pushMatrix();
  p2.translate(36+ offset,33);
  p2.rotate(PI/3.6);
  p2.rect(0,0,10,20);
  p2.popMatrix();
  
  //playerbody
  p2.fill(234,192,134);
  p2.rect(2+ offset,72,10,15);
  p2.rect(17+ offset,72,10,15);
  p2.rect(2+ offset,34,25,40);
  p2.ellipse(14+ offset,22,30,30);
  
  //jersey
  p2.fill(0,0,200);
  p2.rect(2.75+ offset,34,25,40);
  p2.fill(234,192,134);
  p2.ellipse(14.25+ offset, 34,15,15);
  
  p2.ellipse(14+ offset,22,30,30);

  p2.image(two, 0,10);
  
  //playerfacialfeatures
  p2.fill(0);
  p2.ellipse(9+ offset,20,5,5);
  p2.ellipse(19+ offset,20,5,5);
  p2.fill(123,123,123);
  p2.rect(8+ offset,27,12,1);
  p2.endDraw();
}

//-----------------end drawing methods------------------------//
//-----------------player movement control------------------------//

void keyPressed(){
  if(gamescreen == 2){
    switch(key){
      case 'a':
        keys[0] = true;
        break;
      case 'w':
        keys[1] = true;
        break;
      case 'd':
        keys[2] = true;
        break;
      case 'q':
        keys[3]  = true;
        break;
      case 'e':
        keys[8] = true;
        break;
      }
    switch(key){
      case 'j':
        keys[4]  = true;
        break;
      case 'i':
        keys[5]  = true;
        break;
      case 'l':
        keys[6]  = true;
        break;
      case 'o':
        keys[7]  = true;
        break;
      case 'u':
        keys[9] = true;
        break;
    }
  }
}

void keyReleased(){
  if(gamescreen == 2){
    switch(key){
      case 'a':
        keys[0] = false;
        break;
      case 'w':
        keys[1] = false;
        break;
      case 'd':
        keys[2] = false;
        break;
      case 'q':
        keys[3]  = false;
      case 'e':
        keys[8] = false;
        break;
    }
    switch(key){
      case 'j':
        keys[4]  = false;
        break;
      case 'i':
        keys[5]  = false;
        break;
      case 'l':
        keys[6]  = false;
        break;
      case 'o':
        keys[7]  = false;
        break;
      case 'u':
        keys[9] = false;
        break;
    }
  }
}

void movep1(){
  if(keys[0])
    p1Engine.left();
  if(keys[2])
    p1Engine.right();
  if(keys[1])
    p1Engine.jump();
  if(keys[8]){
    //steal
    if(!Collision.p1possession && Collision.p2possession){
      if(Collision.isClose(ballX, ballY, p1x, p1y)){
        Collision.p1possession = true;
        Collision.p2possession = false;
      }
    }
  }
}

void movep2(){
  if(keys[4])
    p2Engine.left();
  if(keys[6])
    p2Engine.right();
  if(keys[5])
    p2Engine.jump();
  if(keys[9]){
    //steal
    if(!Collision.p2possession && Collision.p1possession){
      if(Collision.isClose(ballX, ballY, p2x, p2y)){
        Collision.p1possession = false;
        Collision.p2possession = true;
      }
    }
  }
}

void moveball(){
  if(Collision.p1possession){
    if(keys[3])
      bEngine.shoot();
  }
  if(Collision.p2possession){
    if(keys[7])
      bEngine.shoot();
  }
}
//-----------------end player movement control------------------------//
void startUp(){
  //key input setup
  keys = new boolean[10];
  for(int i = 0; i < keys.length; i++)
    keys[i] = false;
  
  //ball setup
  ballX = 250;
  ballY = 250;
  ballSize = 20;
  bEngine = new PhysicsEngineBall(ballSize / 2, ballSize, ballX, ballY, height - 50, 0, width);
  
  //player1 setup
  p1 = createGraphics(58,88);
  drawPlayerOne();
  p1x = 200;
  p1y = 100;
  player1Width = p1.width;
  player1Height = p1.height;
  p1Engine = new PhysicsEnginePlayer(player1Height, player1Width, p1x, p1y, height - 50, 0, width);
  
  //player2 setup
  p2 = createGraphics(58, 88);
  drawPlayerTwo();
  p2x = 500;
  p2y = 100;
  player2Width = p2.width;
  player2Height = p2.height;
  p2Engine = new PhysicsEnginePlayer(player2Height, player2Width, p2x, p2y, height - 50, 0, width);
  
  //sound setup
  file = new SoundFile(this, "music.mp3");
  file.amp(0.5);
  file.play();
  
  Collision.p1possession = false;
  Collision.p2possession = false;
  Collision.p1score = 0;
  Collision.p2score = 0;
}
//-----------------mouse click event stuff------------------------//
void mousePressed(){
  if(isOverPlay){
    file.stop();
    file = new SoundFile(this, "nitro.mp3");
    file.play();
    file.amp(0.5);
    gamescreen = 2;
    isOverPlay = false;
  }
  if(isOverReplay){
    file.stop();
    gamescreen = 1;
    startUp();
    isOverReplay = false;
  }
}

public static class Collision{
  
  public static boolean p1possession = false;
  public static boolean p2possession = false;
  
  public static int p1score = 0;
  public static int p2score = 0;
   
  private static boolean isClose(float ballX, float ballY, float playerX, float playerY){
    return Math.pow(ballX-playerX, 2) + Math.pow(ballY-playerY,2) <= 6500;
  }
  
  public static boolean isClose2(float ballX, float ballY, float x2, float y2){
    return Math.pow(ballX-x2, 2) + Math.pow(ballY-y2,2) <= 300;
  }
  
  public static boolean isClose3(float ballX, float ballY, float x2, float y2){
    return Math.pow(ballX-x2, 2) + Math.pow(ballY-y2,2) <= 500;
  }
  
  public static void doesP1(float ballX, float ballY, float playerX, float playerY){
    if(isClose(ballX, ballY, playerX, playerY)){
      p1possession = true;
    }
  }
  
  public static void doesP2(float ballX, float ballY, float playerX, float playerY){
    if(isClose(ballX, ballY, playerX, playerY)){
      p2possession = true;
    }
  }
  
  public static boolean isPossessed(){
    return p1possession || p2possession;
  }
  
  public static boolean ballOnRim(float ballX, float ballY, float rimX, float rimY){
    return Math.pow(ballX-rimX, 2) + Math.pow(ballY-rimY,2) <= 500;
  }
  
  public static boolean ballOnBackBoardRight(float ballX, float ballY){
    if(ballX + 10 >= 950){
      if(ballY + 10 >= 200 && ballY + 10 <= 300){
        return true;
      }
    }
    return false;
  }
  
  public static boolean ballOnBackBoardLeft(float ballX, float ballY){
    if(ballX <= 30 + 20){
      if(ballY >= 200 && ballY <= 300){
        return true;
      }
    }
    return false;
  }
}

public interface Physicable{
  public static final float GRAVITY = 1;
  public static final float AIRFRICTION = 0.0001;
  public static final float FRICTION = 0.1;
  
  public float getX();
  public float getY();
  
  public void applyGravity();
  public void applyHorizontalSpeed();
  public void bounce();
  
  public boolean isOnGround();
  public boolean isOnLeft();
  public boolean isOnRight();
  
  public float getSpeedVert();
  public float getSpeedHori();
  public void setSpeedVert(float speedVert);
  public void setSpeedHori(float speedHori);
}

public class PhysicsEngine implements Physicable{
  
  float x, y;
  float speedVert, speedHori;
  int objectHeight, objectWidth;
  int ground, left, right;
  
  public PhysicsEngine(int objectHeight, int objectWidth, float x, float y, int ground, int left, int right){
    this.objectHeight = objectHeight;
    this.objectWidth = objectWidth;
    this.x = x;
    this.y = y;
    this.ground = ground;
    this.left = left;
    this.right = right;
    speedVert = 0;
    speedHori = 0;
  }
  
  public float getX(){
    return x;
  }
  
  public float getY(){
    return y;
  }
  
  public boolean isOnGround(){
    if(y + objectHeight >= ground){
      //y = ground - objectHeight;
      return true;
    }
    return false;
  }
  
  public boolean isOnLeft(){
    if(x <= left){
      x = left;
      return true;
    }
    return false;
  }
  
  public boolean isOnLeft(int LEFT){
    if(x <= LEFT){
      x = LEFT;
      return true;
    }
    return false;
  }
  
  public boolean isOnRight(){
    if(x + objectWidth >= right){
      x = right - objectWidth;
      return true;
    }
    return false;
  }
  
  public boolean isOnRight(int RIGHT){
   if(x + objectWidth >= RIGHT){
      x = RIGHT - objectWidth;
      return true;
    }
    return false;
  }
  
  public void applyHorizontalSpeed(){
    if(isOnGround())
      speedHori -= (speedHori * FRICTION);
    else
      speedHori -= (speedHori * AIRFRICTION);
    x += speedHori;
  }
  
  public void applyGravity(){
    speedVert += GRAVITY;
    speedVert -= (speedVert * AIRFRICTION);
    y += speedVert;
  }
  
  public void bounce(){
    if(isOnGround()){
      speedVert *= -1;
      speedVert -= (speedVert * FRICTION);
      y += speedVert;
    }
    if(y + objectHeight > ground){
      y = ground - objectHeight;
    }
    if(isOnLeft() || isOnRight()){
      speedHori *= -1;
      speedHori -= (speedHori * FRICTION);
      x += speedHori;
    }
  }
  
  public float getSpeedVert(){
    return speedVert;
  }
  
  public float getSpeedHori(){
    return speedHori;
  }
  
  public void setSpeedVert(float speedVert){
    this.speedVert = speedVert;
  }
  
  public void setSpeedHori(float speedHori){
    this.speedHori = speedHori;
  }
}

public class PhysicsEngineBall extends PhysicsEngine{
  
  public PhysicsEngineBall(int objectHeight, int objectWidth, float x, float y, int ground, int left, int right){
    super(objectHeight, objectWidth, x, y, ground, left, right);
  }
  
  public void dribble(float px, float py, boolean isOnGround){
    if(Collision.p1possession){
      if(!isOnGround){
        x = px + 68;
        y = py;
      }else{
        x = px + 68;
        if(y <= py + 30){
          y = py + 30;
          speedVert = 8;
        }
      }
    }else if(Collision.p2possession){
      if(!isOnGround){
        x = px;
        y = py;
      }else{
        x = px - 10;
        if(y <= py + 30){
          y = py + 30;
          speedVert = 8;
        }
      }
    }
  }
  
  public void shoot(){
    if(Collision.p1possession){
      Collision.p1possession = false;
      speedHori = 10;
      speedVert = -25;
    }else if(Collision.p2possession){
      Collision.p2possession = false;
      speedHori = -10;
      speedVert = -25;
    }
  }
  
  public void bounceOffRimRight(){
    x = 895 - objectWidth;
    speedHori = -10;
  }
  
  public void bounceOffRimLeft(){
    x = 50 + 55;
    speedHori = 10;
  }
  
  public void bounceOffBackboardRight(){
    x = 950 - objectWidth;
    speedHori *= -1;
    speedHori -= (speedHori * FRICTION);
    x += speedHori;
  }
  
  public void bounceOffBackboardLeft(){
    x = 50;
    speedHori *= -1;
    speedHori -= (speedHori * FRICTION);
    x += speedHori;
  }
}

public class PhysicsEnginePlayer extends PhysicsEngine{
  
  public PhysicsEnginePlayer(int objectHeight, int objectWidth, float x, float y, int ground, int left, int right){
    super(objectHeight, objectWidth, x, y, ground, left, right);
  }
  
  public void bounce(){
    if(y + objectHeight > ground){
      y = ground - objectHeight;
    }
    if(isOnLeft() || isOnRight()){
      speedHori *= -1 * 0.1;
      x += speedHori;
    }
  }
  
  public void jump(){
    if(isOnGround()){
      speedVert = -23;
    }
  }
  
  public void left(){
    speedHori -= 1;
    speedHori -= (speedHori * FRICTION);
  }
  
  public void right(){
    speedHori += 1;
    speedHori -= (speedHori * FRICTION);
  }
  
  public void bounce(float x1, float y1, float x2, float y2){
    if(x + objectWidth >= x1 && x - objectWidth <= x2){
      if(y <= y1){
        speedVert *= -1;
      }
    }
  } 
  
  public void bounce2(float x1, float y1, float x2, float y2){
    if(x >= x1 && x <= x2){
      if(y <= y1){
        speedVert *= -1;
      }
    }
  } 
}

public class Timer{
  private int prevTime;
  private int currentTime;
  
  public void start(){
    prevTime = millis();
  }
  
  public boolean intervalPassed(int seconds){
    currentTime = millis();
    if(currentTime - prevTime > seconds * 1000){
      prevTime = currentTime;
      return true;
    }
    return false;
  }
}
