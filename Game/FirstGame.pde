class FirstGame{
  

  int rnd; //random number to choose falling object
  int lives;
  FallingObject obj;
  ArrayList<FallingObject> objects;
  int time1,time2,timespeed1,timespeed2;
  float time,low,up;
  float secondsToFall;
  float durationOfBiggerBasket = 0, durationOfProtection = 0;
  float timeBasketResized = 0, timeProtectionStarted = 0;
  int originalBasketWidth, originalBasketHeight;
  
  FirstGame(){
    lives=3;
    objects = new ArrayList<FallingObject>();
    time1=0;
    time2=0;
    timespeed1=0;
    timespeed2=0;
    time=1000;
    low=700;
    up=1500;
    secondsToFall=3;
    originalBasketWidth = basket.width;
    originalBasketHeight = basket.height;
  }
  
  void myDraw(){
    if(isPaused==false){
      time2=millis();
      timespeed2=millis();
      
      background(background1);
      imageMode(CORNER);
      //score
      fill(255);
      textSize(20);
      textAlign(RIGHT);
      fill(color(blue));
      text("SCORE: "+score, width-5, 30);
      //lives
      for(int i=0; i<lives; i++){
        image(heart, 35*i+10, 10);
      }
      for(int i=lives; i<3; i++){
        image(heartEmpty, 35*i+10, 10);
      }
      
  
      
      for (int i = objects.size()-1; i >= 0; i--) {
        obj = objects.get(i);
      
        image(objectImages[obj.index],obj.posX,obj.posY+=float(height)/secondsToFall/(int(frameRate)));
        
        if(obj.posY>height){
          objects.remove(i);
          if(obj.bomb==false && obj.points==5){
            if(specialCatchMode==true && obj.index==8 || specialCatchMode==false){
              miss.play();
              lives--;
              if(lives<=0)
                setGameOver();
            }
          }
        }
        
       else if((obj.posY+obj.height>height-basket.height && obj.posY<height-basket.height
         && obj.posX+obj.width/2>mouseX-basket.width/2 && obj.posX+obj.width/2<mouseX+basket.width/2 && mode==true) ||
         (obj.posY+obj.height>height-basket.height && obj.posY<height-basket.height
         && obj.posX+obj.width/2>X-basket.width/2-50 && obj.posX+obj.width/2<X+basket.width/2+50 && mode==false)){
           if(obj.bomb==false){
            if(obj.points==1 && lives<3){
              life.play();
              lives++; //srce
            }
            else if(obj.points==2){//puz
             snail.play();
             low=700;
             up=1500;
             secondsToFall=3;
            }
            else if(obj.points==3){//povecanje kosarice
              strength.play();
              if (millis() - timeBasketResized >= durationOfBiggerBasket * 1000){
                basket.resize(basket.width*=1.2, basket.height*=1.2);
                timeBasketResized = millis();
              }
              durationOfBiggerBasket += 5;
            }
            else if(obj.points==4){//dodatni bodovi
              score += 10;
              star.play();
            }
            else if(obj.points==6){//zastita od bombi
            shield.play();
              if (millis() - timeProtectionStarted >= durationOfProtection * 1000){
                timeProtectionStarted = millis();
                durationOfProtection = 0;
              }
              durationOfProtection += 5;
            }
            else if(obj.points!=0 && obj.points!=1 && obj.points!=2
            && obj.points!=3 && obj.points!=4 && obj.points!=6){ //nije srce, nije puz, nije bomba
                if(specialCatchMode==false){
                  score+=obj.points;
                  pop.play();
                } else{
                  if(obj.index==8){
                    score+=obj.points;
                  }else{
                    wrong.play();
                    lives--;
                    if(lives<=0)
                      setGameOver();
                  }
                }
            }  
          }
          else{
            if (millis() - timeProtectionStarted >= durationOfProtection * 1000){
              bomb.play();
              durationOfProtection = 0;
              error.play();
              lives--;
              if(lives<=0)
                setGameOver();
            }
          }
          objects.remove(i);
        }
      
      }
        
      if(time2-time1>time){
        rnd=int(random(0,numFall-1));
        if(rnd==0){
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 0, true);
        }
        else if(rnd>=14 && rnd<17){
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 1, false); //srce
        }
        else if(rnd>=17 && rnd<20){
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 2, false); //puz
        }
        else if(rnd>=20 && rnd<23){
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 3, false); //veca kosarica
        }
        else if(rnd>=23 && rnd<26){
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 4, false); //veca kosarica
        }
        else if(rnd>=26){
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 6, false); //veca kosarica
        }
        else{
          obj=new FallingObject(rnd, int(random(0,width-width/10)), 5, false);
        }
        objects.add(obj);
        time1=time2;
        time=random(low,up);
      }
      
      
        if(difficulty==0){
          if(timespeed2-timespeed1>2000){
            if(secondsToFall>1.2)
              secondsToFall-=0.02;
            if(low>600)
              low-=10;
            if(up>1000)
              up-=10;
            timespeed1=timespeed2;
          }
        }
        else if(difficulty==1){
          if(timespeed2-timespeed1>1000){
            if(secondsToFall>0.7)
              secondsToFall-=0.02;
            if(low>200)
              low-=5;
            if(up>600)
              up-=10;
            timespeed1=timespeed2;
          }
        }
        else if(difficulty==2){
          if(timespeed2-timespeed1>1000){
            if(secondsToFall>0.6)
              secondsToFall-=0.05;
            if(low>200)
              low-=10;
            if(up>600)
              up-=50;
            timespeed1=timespeed2;
          }
        }
        else if(difficulty==3){
          if(timespeed2-timespeed1>1000){
            if(secondsToFall>0.7)
              secondsToFall-=0.07;
            if(low>100)
              low-=10;
            if(up>300)
              up-=70;
            timespeed1=timespeed2;
          }
        }
        
      
      
  
       //true->mouse
      if(mode==true){
        if (millis() - timeBasketResized < durationOfBiggerBasket * 1000) {
          // Keep the basket bigger for the specified duration
          image(basket, mouseX - basket.width / 2, height - basket.height, basket.width, basket.height);
        } else {
          // Basket is back to normal size
          durationOfBiggerBasket = 0;
          basket.resize(originalBasketWidth, originalBasketHeight);
          image(basket, mouseX - basket.width / 2, height - originalBasketHeight, originalBasketWidth, originalBasketHeight);
        }
      }
      else{    
        if (millis() - timeBasketResized < durationOfBiggerBasket * 1000) {
          // Keep the basket bigger for the specified duration
          image(basket, X, height-basket.height, basket.width, basket.height);
        } else {
          // Basket is back to normal size
          durationOfBiggerBasket = 0;
          basket.resize(originalBasketWidth, originalBasketHeight);
          image(basket, X, height-originalBasketHeight, originalBasketWidth, originalBasketHeight);
        }
      }
        
      //.................back button....................
      if(overCircle(30,height-50,50)==true){  
        fill(darkblue);
        stroke(darkblue);
      }
      else{
        fill(blue);
        stroke(blue);
      }
      circle(30, height-30, 50);
      imageMode(CENTER);
      image(leftArrow,30,height-30);
      //.................play/pause button....................
      if(overCircle(670,height-50,50)==true){  
        fill(darkblue);
        stroke(darkblue);
      }
      else{
        fill(blue);
        stroke(blue);
      }
      circle(670, height-30, 50);
      imageMode(CENTER);
      image(playpause,670,height-30);
      
    }
  }
  
  void setGameOver(){ 
    appendTextToFile("scores.txt", score + " "+day()+"/"+month()+"/"+year()+"-"+hour()+":"+minute()+":"+second() );
    firstGameB=false;
    gameOverB=true;
  }

  void myMousePressed() {
    
    if(overCircle(30,height-30,50)==true){
       click.play();
       homeB=true;
       firstGameB=false;
       firstGame = new FirstGame();
       score=0;
     }
     if(overCircle(670,height-30,50)==true){
       //play/pause button
        click.play();
        if(isPaused){
          // Resume animation
          isPaused=false;
          song1.play();
        } else{
          // Pause animation
          song1.pause();
          isPaused=true;
        }
     }
  }
  

}
