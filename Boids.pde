int zahl = 1500; //0.08 --> 800
float[] x = new float[zahl];
float[] y = new float[zahl];
float[] w = new float[zahl];
float[] lokaleUmgebung = new float[zahl];
float winkelDrehung = 1*2*PI/360; //17
float v = 2; //0.67
float interaktionsRadius;
float countLeft;
float countRight;
float h = 12;
float last = 1;

void setup(){
  //size(1300,600);
  fullScreen();
  interaktionsRadius = 30; //5 //20, 30,
  for(int i=0; i<zahl; i++){
    x[i] = random(width);
    y[i] = random(height);
    w[i] = random(12*PI)%(2*PI);
  }
  fill(255);
  noStroke();
}


void draw(){
    for(int fps=0; fps<2; fps++){
    for(int i=0; i<zahl; i++){
      countLeft = 0;
      countRight = 0;
      lokaleUmgebung[i] = 0;
      for(int j=0; j<zahl; j++){
        if(i != j){
          if(abstand(x[i],y[i],x[j],y[j]) < interaktionsRadius){
            if(winkel(w[i]%(2*PI),w[j]%(2*PI)) < PI){
              countLeft ++;
            }
            else{
              countRight ++;
            }
          }
        }
      }
      lokaleUmgebung[i] = countRight + countLeft;
      w[i] += winkelDrehung*lokaleUmgebung[i]*signum(countRight-countLeft);
    }
    for(int i=0; i<zahl; i++){
      x[i] += v*cos(w[i]);
      y[i] += v*sin(w[i]);
      x[i] += width;
      y[i] += height;
      x[i] %= width;
      y[i] %= height;
    }
  }
  //if(frameCount < 300){
    background(200);
  //}
  for(int i=0; i<zahl; i++){
    if(mousePressed == true){
      noFill();
      stroke(255-200*lokaleUmgebung[i]/last,30-30*lokaleUmgebung[i]/last,100-50*lokaleUmgebung[i]/last);
      ellipse(x[i],y[i],2*interaktionsRadius,2*interaktionsRadius);
      noStroke();
    }
    fill(255-200*lokaleUmgebung[i]/last,30-30*lokaleUmgebung[i]/last,100-50*lokaleUmgebung[i]/last);
    triangle(x[i]+h*cos(w[i]),y[i]+h*sin(w[i]),x[i]-h/4*sin(w[i]),y[i]+h/4*cos(w[i]),x[i]+h/4*sin(w[i]),y[i]-h/4*cos(w[i]));
  }
  
  saveFrame("1500_1deg/frame#####.png");
  if(frameCount > 1200){
    exit();
  }
  last = max(last, max(lokaleUmgebung));
  //print(last,"\n");
}


float abstand(float x1,float y1,float x2,float y2){
  if(abs(x1-x2) < interaktionsRadius && abs(y1-y2) < interaktionsRadius){
    float r = min(sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)),
                  sqrt((x1-x2-width)*(x1-x2-width)+(y1-y2)*(y1-y2)),
                  sqrt((x1-x2)*(x1-x2)+(y1-y2-height)*(y1-y2-height)));
    r = min(r,    sqrt((x1-x2+width)*(x1-x2+width)+(y1-y2)*(y1-y2)),
                  sqrt((x1-x2)*(x1-x2)+(y1-y2+height)*(y1-y2+height)));
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
