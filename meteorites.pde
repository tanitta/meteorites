//星の数
int num = 200;
//空間の広さ
float scaleField = 1;
//処理速度
float disTime = 0.01;
//万有引力定数
float grav = 15.0;
float sizStar = 800.;
//粘性係数
float conC = 200.;
//反発係数
float conR = 0.1;
//爆発のトリガ閾値
float conBomb = 128.*2000.;

int sizScreenX = displayWidth;
int sizScreenY = displayHeight;

class MotherStar 
{
  float Mass,Radius,invMass;
  float PosX,PosY;
  float VerX,VerY;
  float AccX,AccY;
  float ForX,ForY;
  float ForAbsX, ForAbsY;
  float counter;
  boolean bomb = false; 
  boolean IsLock = false;
  MotherStar (float m,float x, float y) {
    Mass = m;
    invMass = 1./Mass;
    PosX = x;
    PosY = y;
    VerX = 0;
    VerY = 0;
    Radius = pow(Mass*0.3183,0.5);
    counter = 0;
  };
  void SetPos(float x,float y){
    PosX = x;
    PosY = y;
  };
  void SetLock(boolean b){
          IsLock = b;
  };
  
  void SetForce(float x, float y){
    ForX = x;
    ForY = y;
    ForAbsX = abs(x);
    ForAbsY = abs(y);
  };
  void SetVelocity(float x, float y){
    VerX = x;
    VerY = y;
  };
  
  float GetForAbs(){
    return pow(pow(ForAbsX,2.)+pow(ForAbsY,2.),0.5)*0.1;
  };
  
  void AddForce(float x, float y){
    ForX = ForX +  x;
    ForY = ForY + y;
    ForAbsX = ForAbsX + abs(x);
    ForAbsY = ForAbsY + abs(y);
  };
  void Update(){
    AccX = ForX*invMass;
    AccY = ForY*invMass;
    VerX = VerX + AccX*disTime;
    VerY = VerY + AccY*disTime;
    
    PosX = PosX + VerX*disTime;
    PosY = PosY + VerY*disTime;
  };
  void Draw(){  
    
    //line(PosX, PosY, PosX-AccX*1000, PosY-AccY*1000);
    /*
    line(PosX, PosY, PosX+Radius+10, PosY+Radius+10);
    line(PosX+Radius+10, PosY+Radius+10,PosX+Radius+200, PosY+Radius+10);
    text("Mass : "+Mass, PosX+Radius+10,PosY+Radius+10);
    text("X : "+PosX, PosX+Radius+10,PosY+Radius+12*2);
    text("Y : "+PosY, PosX+Radius+150,PosY+Radius+12*2);
    
    text("VX : "+VerX, PosX+Radius+10,PosY+Radius+12*3);
    text("VY : "+VerY, PosX+Radius+150,PosY+Radius+12*3);

    text("AX : "+AccX, PosX+Radius+10,PosY+Radius+12*4);
    text("AY : "+AccY, PosX+Radius+150,PosY+Radius+12*4); 
    */
    ellipse(int(PosX),int(PosY),Radius*2,Radius*2);
    point(int(PosX),int(PosY));
  };
  void Draw2(){  
    ellipse(int(PosX),int(PosY),GetForAbs()*0.008*40.,GetForAbs()*0.008*40.);
    
    //line(PosX, PosY, PosX-AccX*1000, PosY-AccY*1000);
  };
  
};

MotherStar[] star = new MotherStar[num];
float r,invr;
void setup()
{
  stroke(255,255,255,0);
  strokeWeight(10); 
  //size(sizScreenX, sizScreenY,OPENGL);
  size(displayWidth, displayHeight);
  
  fill(255, 64);
  background(64);
  smooth();
  for(int i = 0; i < star.length; i ++) star[i] = new MotherStar(sizStar*random(1/sizStar, 1.), width*0.5*random(-1., 1.)+width/2, height*0.5*random(-1., 1.)+height/2);
  for(int i = 0; i < star.length; i ++) star[i].SetVelocity(1*random(-0.1, 0.1),5*random(-0.1, 0.1));
  //star[0] = new MotherStar(500,10*0+width/2, 10*0+height/2);
}

void draw()
{
  //background(32, 32, 32, 256); //背景
  background(0, 0, 0, 256); //背景   
  //fill(0,255);
  //rect(0, 0, width, height);   
  for(int i = 0; i < star.length; i ++){
    star[i].SetForce(0,0);
    for(int j = 0; j < star.length; j ++){   
      if(i != j){
        r = pow(pow(star[i].PosX-star[j].PosX,2.0)+pow(star[i].PosY-star[j].PosY,2.0),0.5);
        invr = 1./pow(r,3);
        if(star[i].Radius+star[j].Radius < r){
          float fx = grav*star[i].Mass*star[j].Mass*invr*(star[i].PosX-star[j].PosX);
          float fy = grav*star[i].Mass*star[j].Mass*invr*(star[i].PosY-star[j].PosY);        
          star[i].AddForce(-fx,-fy);
        }else{
        float fx = grav*star[i].Mass*1*star[j].Mass*invr*(star[i].PosX-star[j].PosX);
        float fy = grav*star[i].Mass*1*star[j].Mass*invr*(star[i].PosY-star[j].PosY);
          star[i].AddForce(fx*conR,fy*conR);
          star[i].AddForce(-(star[i].VerX-star[j].VerX)*conC,-(star[i].VerY-star[j].VerY)*conC);
        };
        if(star[i].Radius+star[j].Radius > r*0.66 && star[j].bomb && star[i].GetForAbs()>32){
          star[i].bomb = true;
        };
      };
    };
    if(star[i].GetForAbs()>conBomb){
      star[i].bomb = true;
    };

    if (star[i].bomb){
      star[i].counter = star[i].counter + 1.  ;
    };
    if(star[i].counter>5){
        star[i].AddForce(0.1*star[i].Mass*star[i].GetForAbs()*random(-1., 1.),0.1*star[i].Mass*star[i].GetForAbs()*random(-1., 1.));
        star[i].counter = 0.;
        star[i].bomb = false;
    };
  };
  
  //star[0].SetForce(0,0);
  //star[0].SetPos(width/2,height/2);
  //star[0].SetPos(mouseX,mouseY);
  
  for(int i = 0; i < star.length; i ++) star[i].Update();
  for(int i = 0; i < star.length; i ++){
    float resetX = star[i].VerX;
    float resetY = star[i].VerY; 
    if (star[i].PosX>width*0.5+scaleField*width*0.5){
      resetX = -abs(resetX)*0.6;
    };
    if (star[i].PosX<width*0.5-scaleField*width*0.5){
      resetX = abs(resetX)*0.6;
    };
    if (star[i].PosY>height*0.5+scaleField*height*0.5){
      resetY = -abs(resetY)*0.6;
    };
    if (star[i].PosY<height*0.5-scaleField*height*0.5){
      resetY = abs(resetY)*0.6;
    };
    star[i].SetVelocity(resetX,resetY);
  };
  for(int i = 0; i < star.length; i ++) star[i].Update();
  
  translate(-(mouseX-width*0.5)*scaleField*5,-(mouseY-height*0.5)*scaleField*5);
  translate((width*0.5),(height*0.5));
  //scale((mouseX-width/2)*0.1,(mouseX-width/2)*0.1); 
  scale(1,1); 

  translate((-width*0.5),(-height*0.5));
  for(int i = 0; i < star.length; i ++){
    
    // strokeWeight(star[i].GetForAbs()*3./128.*40.);
    //fill(star[i].GetForAbs()*30+5, star[i].GetForAbs()*30*0.4+5,(star[i].GetForAbs()*30*0.4*0.5+5)*0.9,4);
    //star[i].Draw2();
    
    //fill(star[i].GetForAbs()*3+128, star[i].GetForAbs()*3*0.5+128,128-star[i].GetForAbs()*3.);
    fill(star[i].GetForAbs()*(128.*1.5)/conBomb*30+5, star[i].GetForAbs()*(128.*1.5)/conBomb*30*0.4+5,star[i].GetForAbs()*(128.*1.5)/conBomb*30*0.4*0.5+5);
    stroke(star[i].GetForAbs()*(128.*1.5)/conBomb*30+5, star[i].GetForAbs()*(128.*1.5)/conBomb*30*0.4+5,star[i].GetForAbs()*(128.*1.5)/conBomb*30*0.4*0.5+5,32);
    strokeWeight(10);
    star[i].Draw();
    
    
  };
  //println("star[0].GetForAbs(): "+star[1].GetForAbs());
};

