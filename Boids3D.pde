int zahl = 1200; //0.08 --> 800
int boxSize = 450;
float[] x = new float[zahl];
float[] y = new float[zahl];
float[] z = new float[zahl];
float[] w1 = new float[zahl];
float[] w2 = new float[zahl];
float[] lokaleUmgebung = new float[zahl];
float winkelDrehung = 0.01; //1*2*PI/360; //17
float v = 2; //0.67
float interaktionsRadius;
float countLeft;
float countRight;
float countAbove;
float countBelow;
float h = 12;
float last = 1;

void setup(){
  //size(1300,600);
  fullScreen(P3D);
  interaktionsRadius = 40; //5 //20, 30,
  for(int i=0; i<zahl; i++){
    x[i] = random(boxSize);
    y[i] = random(boxSize);
    z[i] = random(boxSize);
    w1[i] = random(12*PI)%(2*PI);
    w2[i] = random(12*PI)%(2*PI);
  }
  fill(255);
  noStroke();
}


void draw(){
    for(int fps=0; fps<2; fps++){
    for(int i=0; i<zahl; i++){
      countLeft = 0;
      countRight = 0;
      countAbove = 0;
      countBelow = 0;
      lokaleUmgebung[i] = 0;
      for(int j=0; j<zahl; j++){
        if(i != j){
          if(abs(x[i]-x[j]) < interaktionsRadius && abs(y[i]-y[j]) < interaktionsRadius && abs(z[i]-z[j]) < interaktionsRadius){
            if(abstand(x[i],y[i],z[i],x[j],y[j],z[j]) < interaktionsRadius){
              if(winkel(w1[i]%(2*PI),w1[j]%(2*PI)) < PI){
                countLeft ++;
              }
              else{
                countRight ++;
              }
              if(winkel(w2[i]%(2*PI),w2[j]%(2*PI)) < PI){
                countBelow ++;
              }
              else{
                countAbove ++;
              }
            }
          }
        }
      }
      lokaleUmgebung[i] = countRight + countLeft + countAbove + countBelow;
      w1[i] += winkelDrehung*lokaleUmgebung[i]*signum(countRight-countLeft);
      w2[i] += winkelDrehung*lokaleUmgebung[i]*signum(countAbove-countBelow);
    }
    for(int i=0; i<zahl; i++){
      x[i] += v*cos(w1[i])*sin(w2[i]);
      y[i] += v*sin(w1[i])*sin(w2[i]);
      z[i] += v*cos(w2[i]);
      x[i] += boxSize;
      y[i] += boxSize;
      z[i] += boxSize;
      x[i] %= boxSize;
      y[i] %= boxSize;
      z[i] %= boxSize;
    }
  }
  
  background(255,190,200);
  
  
  strokeWeight(2);
  for(int i=0; i<zahl; i++){
    fill(255-200*lokaleUmgebung[i]/last,30-30*lokaleUmgebung[i]/last,100-50*lokaleUmgebung[i]/last);
    stroke(255-200*lokaleUmgebung[i]/last,30-30*lokaleUmgebung[i]/last,100-50*lokaleUmgebung[i]/last);
    //triangle(x[i]+h*cos(w1[i]),y[i]+h*sin(w1[i]),x[i]-h/4*sin(w1[i]),y[i]+h/4*cos(w1[i]),x[i]+h/4*sin(w1[i]),y[i]-h/4*cos(w1[i]));
    translate(x[i],y[i],z[i]);
    boid(w1[i],w2[i]);
    translate(-x[i],-y[i],-z[i]);
  }
  
  stroke(50);
  strokeWeight(4);
  float boxMin = 0;
  float boxMax = boxSize;
  line(boxMin,boxMin,boxMin,  boxMax,boxMin,boxMin);
  line(boxMin,boxMin,boxMin,  boxMin,boxMax,boxMin);
  line(boxMin,boxMin,boxMin,  boxMin,boxMin,boxMax);
  line(boxMax,boxMin,boxMin,  boxMax,boxMax,boxMin);
  line(boxMax,boxMin,boxMin,  boxMax,boxMin,boxMax);
  line(boxMin,boxMax,boxMin,  boxMax,boxMax,boxMin);
  line(boxMin,boxMax,boxMin,  boxMin,boxMax,boxMax);
  line(boxMin,boxMin,boxMax,  boxMax,boxMin,boxMax);
  line(boxMin,boxMin,boxMax,  boxMin,boxMax,boxMax);
  line(boxMax,boxMax,boxMax,  boxMin,boxMax,boxMax);
  line(boxMax,boxMax,boxMax,  boxMax,boxMin,boxMax);
  line(boxMax,boxMax,boxMax,  boxMax,boxMax,boxMin);
  
  float turnspeed = 7200;
  float diag = boxSize*1.4;
  float centre = boxSize/2;
  camera(sin(2*PI*float(frameCount)/turnspeed)*diag+centre, centre, cos(2*PI*float(frameCount)/turnspeed)*diag+centre,     centre, centre, centre,     0.0, 1.0, 0.0);
  saveFrame("1200_LongAt30fps/frame#####.png");
  if(frameCount > 41200){
    exit();
  }
  last = max(last, max(lokaleUmgebung));
  //print(last,"\n");
  //text(frameRate, 20,20);
}


















float abstand(float x1,float y1,float z1,float x2,float y2,float z2){
  if(abs(x1-x2) < interaktionsRadius && abs(y1-y2) < interaktionsRadius && abs(z1-z2) < interaktionsRadius){
    float r = min(sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2)),
                  sqrt((x1-x2-boxSize)*(x1-x2-boxSize)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2)),
                  sqrt((x1-x2)*(x1-x2)+(y1-y2-boxSize)*(y1-y2-boxSize)+(z1-z2)*(z1-z2)));
    r = min(r,    sqrt((x1-x2+boxSize)*(x1-x2+boxSize)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2)),
                  sqrt((x1-x2)*(x1-x2)+(y1-y2+boxSize)*(y1-y2+boxSize)+(z1-z2)*(z1-z2)));
    r = min(r,    sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2-boxSize)*(z1-z2-boxSize)),
                  sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2+boxSize)*(z1-z2+boxSize)));
  return r;
  }
  else{
    return interaktionsRadius*3;
  }
}




float winkel(float w1, float w2){
  float w = (w1-w2+2*PI)%(2*PI);
  return w;
}





float signum(float x){
  if(x==0){
    return 0;
  }
  if(x<0){
    return -1;
  }
  if(x>0){
    return 1;
  }
  print("Error on sign\n");
  return 0;
}





void boid(float w1Temp,float w2Temp){
  float boidSize = 10;
  float boidAngle = PI/12;
  float offsetW1 = 0;
  float offsetW2 = PI;
  
  //Tip is at (0,0,0)
  float[][] corners = new float[5][4];
  
  corners[1][1] = boidSize * cos(w1Temp+offsetW1+boidAngle) * sin(w2Temp+offsetW2+boidAngle);
  corners[2][1] = boidSize * cos(w1Temp+offsetW1+boidAngle) * sin(w2Temp+offsetW2-boidAngle);
  corners[3][1] = boidSize * cos(w1Temp+offsetW1-boidAngle) * sin(w2Temp+offsetW2+boidAngle);
  corners[4][1] = boidSize * cos(w1Temp+offsetW1-boidAngle) * sin(w2Temp+offsetW2-boidAngle);
  
  corners[1][2] = boidSize * sin(w1Temp+offsetW1+boidAngle) * sin(w2Temp+offsetW2+boidAngle);
  corners[2][2] = boidSize * sin(w1Temp+offsetW1+boidAngle) * sin(w2Temp+offsetW2-boidAngle);
  corners[3][2] = boidSize * sin(w1Temp+offsetW1-boidAngle) * sin(w2Temp+offsetW2+boidAngle);
  corners[4][2] = boidSize * sin(w1Temp+offsetW1-boidAngle) * sin(w2Temp+offsetW2-boidAngle);
  
  corners[1][3] = boidSize * cos(w2Temp+offsetW2+boidAngle);
  corners[2][3] = boidSize * cos(w2Temp+offsetW2-boidAngle);
  corners[3][3] = boidSize * cos(w2Temp+offsetW2+boidAngle);
  corners[4][3] = boidSize * cos(w2Temp+offsetW2-boidAngle);

  
  line(0, 0, 0, corners[1][1], corners[1][2], corners[1][3]);
  line(0, 0, 0, corners[2][1], corners[2][2], corners[2][3]);
  line(0, 0, 0, corners[3][1], corners[3][2], corners[3][3]);
  line(0, 0, 0, corners[4][1], corners[4][2], corners[4][3]);
}
