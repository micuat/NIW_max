class HapticTile
{
  int x, y, destX;
  int texId = 255;
  NetAddress remote;
  
  public HapticTile(int _x, int _y)
  {
    x = _x;
    y = _y;
    
    if(miniTile)
    {
      if(_x == 0 && _y == 0)
        destX = 3;
      else if(_x == 1 && _y == 0)
        destX = 1;
      else if(_x == 0 && _y == 1)
        destX = 2;
      else if(_x == 1 && _y == 1)
        destX = 0;
      remote = local;
    }
    else
    {
      destX = _x;
      remote = mac1;
      if( y < 1 )
        remote = mac1;
      else if( y < 2 )
        remote = mac2;
      else if( y < 3 )
        remote = mac3;
      else if( y < 4 )
        remote = mac4;
      else if( y < 5 )
        remote = mac5;
      else if( y < 6 )
        remote = mac6;
    }
  }
  
  public void setTexId(String s)
  {
    int texId;
    if(s.equals("none"))
      texId = 0;
    else if(s.equals("ice"))
      texId = 1;
    else if(s.equals("snow"))
      texId = 2;
    else if(s.equals("can"))
      texId = 3;
    else if(s.equals("water"))
      texId = 4;
    else if(s.equals("sand"))
      texId = 5;
    else return;
    
    setTexId(texId);
  }

  public void trigger()
  {
    OscMessage myMessage = new OscMessage("/niw/direct");
    myMessage.add((int)destX + 1); /* add an int to the osc message */
  
    oscP5.send(myMessage, remote);
  }
  
//  public void trigger()
//  {
//    for(int i = 0; i < 15000; i+=100)
//    {
//      OscMessage myMessage = new OscMessage("/niw/client/VtoF");
//      myMessage.add((this.x == 0)?i:0);
//      myMessage.add((this.x == 1)?i:0);
//      myMessage.add((this.x == 2)?i:0);
//      myMessage.add((this.x == 3)?i:0);
//      myMessage.add((this.x == 4)?i:0);
//      myMessage.add((this.x == 5)?i:0);
//    
//      oscP5.send(myMessage, remote);
//    }
//    
//    delay(100);
//  }
  public void setTexId(int texId)
  {
    if(this.texId != texId)
    {
      if(texId == 0) // none
      {
        OscMessage myMessage = new OscMessage("/niw/fsr");
        myMessage.add("off");
        myMessage.add((int)destX + 1); /* add an int to the osc message */
      
        oscP5.send(myMessage, remote);
      
        this.texId = texId;
      }
      else
      {
        OscMessage myMessage = new OscMessage("/niw/fsr");
        myMessage.add("on");
        myMessage.add((int)destX + 1); /* add an int to the osc message */
      
        oscP5.send(myMessage, remote);
        
        myMessage = new OscMessage("/niw/preset");
        myMessage.add((int)destX + 1); /* add an int to the osc message */
        if(texId == 1)
          myMessage.add("ice");
        else if(texId == 2)
          myMessage.add("snow");
        else if(texId == 3)
          myMessage.add("can");
        else if(texId == 4)
          myMessage.add("water");
        else if(texId == 5)
          myMessage.add("sand");
      
        oscP5.send(myMessage, remote);
      
        this.texId = texId;
      }
    }
  }
  
  public void setParameters(float f0, float f1, float f2, float f3, float f4, float f5, float f6, 
  float f7, float f8, float f9, float f10, float f11, float f12)
  {
    OscMessage myMessage = new OscMessage("/niw/crumpleparams");
    myMessage.add((int)destX + 1); /* add an int to the osc message */
    myMessage.add(f0);
    myMessage.add(f1);
    myMessage.add(f2);
    myMessage.add(f3);
    myMessage.add(f4);
    myMessage.add(f5);
    myMessage.add(f6);
    myMessage.add(f7);
    myMessage.add(f8);
    myMessage.add(f9);
    myMessage.add(f10);
    myMessage.add(f11);
    myMessage.add(f12);
  
    oscP5.send(myMessage, remote);
    this.texId = 255;
  }

  public int getTexId()
  {
    return this.texId;
  }
  
  public void draw()
  {
    if(texId == 0)
      fill(30);
    else if(texId == 1)
      fill(255);
    else if(texId == 2)
      fill(128);
    else if(texId == 3)
      fill(255, 255, 0);
    else if(texId == 4)
      fill(100, 100, 255);
    else if(texId == 5)
      fill(255, 155, 0);
    else if(texId == 255)
      fill(255, 0, 0);
    
    float dx = width / numCols;
    float dy = height / numRows;
    float wx = map(x, 0, numCols - 1, dx / 2, width - dx / 2);
    float wy = map(y, 0, numRows - 1, dy / 2, height - dy / 2);
    rectMode(CENTER);
    rect(wx, wy, dx - 4, dy - 4);
  }
}