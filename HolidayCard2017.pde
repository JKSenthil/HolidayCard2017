ArrayList<Firework> fireworks;
int numOfFireworks = 2;
Timer timer;
PImage bg;
PFont font;

void setup(){
  size(800,800);
  bg = loadImage("https://get.wallhere.com/photo/landscape-mountains-digital-art-sea-night-pixel-art-lake-nature-reflection-sky-stars-clouds-Moon-blue-hills-evening-morning-coast-pixels-moonlight-horizon-atmosphere-dusk-cloud-dawn-ocean-wave-darkness-1920x1200-px-computer-wallpaper-wind-wave-630639.jpg");
  bg.resize(height,width);
  font=loadFont("data/SnellRoundhand-Bold-32.vlw");
  timer = new Timer();
  timer.start();
  fireworks = new ArrayList<Firework>();
  for(int i = 0; i < numOfFireworks; i++){
    fireworks.add(new Firework(random(height), 410));
  }
  textFont(font);
  textSize(88);
}

void draw(){
  image(bg,0,0);
  
  fill(255,0,0);
  text("Happy Holidays", 100,550);
  for(Firework f : fireworks){
    if(f.isExplode() && !f.exploded){
      f.explode();
    }
    f.show();
  }
  
  //despawn
  for(int i = 0; i < fireworks.size(); i++){
    if(fireworks.get(i).exploded && isDespawn(fireworks.get(i))){
      fireworks.remove(i);
    }
  }
  
  if(timer.intervalPassed(1)){
    spawnFirework();
    timer.start();
  }
    
}

void spawnFirework(){
  fireworks.add(new Firework(random(height), 410));
}

boolean isDespawn(Firework f){
  return (f.particles.get(0).pos.y>2400 || f.particles.get(0).opaque<-200);
}



public class Firework{
  public PVector pos;
  public ArrayList<Particle> particles;
  public int numOfParticles = 300;
  public boolean exploded = false;
  public float rand = random(50,250);
  
  public Firework(float x, float y){
    pos = new PVector();
    particles = new ArrayList<Particle>();
    pos.x = x;
    pos.y = y;
  }
  
  public void explode(){
    exploded = true;
    for(int i = 0; i < numOfParticles; i++){
      particles.add(new Particle(pos.x, pos.y));
    }
  }
  
  public boolean isExplode(){
    return (pos.y < rand);
  }
  
  public void show(){
    if(!exploded){
      fill(255);
      stroke(0);
      rect(pos.x,pos.y,10,25);
      stroke(255,0,0);
      strokeWeight(3);
      line(pos.x+2,pos.y+23,pos.x+8,pos.y+20);
      line(pos.x+2,pos.y+14,pos.x+8,pos.y+11);
      line(pos.x+2,pos.y+5,pos.x+8,pos.y+2);
      noStroke();
      fill(255,0,0);
      triangle(pos.x-2,pos.y,pos.x+12,pos.y,pos.x+5,pos.y-8);
      pos.x -= 0;
      pos.y -= 7;
    }else{
      for(Particle p : particles){
        p.show();
        p.update();
      }
    }
  }
  
}


public class Particle{
  float rot;
  PVector pos;
  color c;
  int size;
  float Vy;
  float Vx;
  float opaque = 255;
  float rotate;
  
  public Particle(float x, float y){
    pos = new PVector();
    init(x,y);
  }
  
  public Particle(float x, float y, int r, int g, int b){
    pos = new PVector();
    init(x,y);
    c = color(r,b,g);
  }
   
  private void init(float x, float y){
    int r = 255*((int)random(0,2));
    int g = 255*((int)random(0,2));
    int b = 255*((int)random(0,2));
    c =  color(r, g, b);
    float op = random(150,255);
    opaque=(int)random(op,255);
    pos.x = x;
    pos.y = y;
    size = 6;
    rotate=(float)PI/((int)random(32,64));
    Vx = random(-1.5,1.5);
    Vy = random(-2,2) * sqrt(2.25-pow(Vx,2));
    Vx *=2;
    rot=(float)PI/((int)random(1,64));
  }
  
  public void update(){
    pos.x += Vx;
    pos.y += Vy;
    //rot+=PI/64;
    
    rot+=rotate;
    Vy += 0.05; //acceleration
    opaque -= 3;
  }
  
  public void show(){
    fill(c,opaque);
    size = (int) random(1,12);
    ellipse(pos.x, pos.y, size*cos(rot), size);
  }
  
  public float getVelocity(){
    return sqrt(pow(Vx,2) + pow(Vy,2));
  }
}


public class Timer{
  private int prevTime;
  private int currentTime;
  public boolean isTiming = false;
  
  public void start(){
    prevTime = millis();
    isTiming = true;
  }
  
  public boolean intervalPassed(float seconds){
    currentTime = millis();
    if(currentTime - prevTime > seconds * 1000){
      prevTime = currentTime;
      isTiming = false;
      return true;
    }
    return false;
  }
  
}
