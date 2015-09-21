/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress mac1, mac2, mac3, mac4, mac5, mac6, local;
boolean debug = true;
boolean miniTile = true;

int numRows = 6;
int numCols = 6;

HapticTile[] tiles = new HapticTile[numRows * numCols];

void setup() {
  if(miniTile)
  {
    numRows = 2;
    numCols = 2;
  }
  
  size(400,400);
  smooth();
  frameRate(60);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,14833);

  local = new NetAddress("localhost",14924);
  mac1 = new NetAddress("192.168.5.82",14924);
  mac2 = new NetAddress("192.168.5.82",14925);
  mac3 = new NetAddress("192.168.5.83",14926);
  mac4 = new NetAddress("192.168.5.84",14927);
  mac5 = new NetAddress("192.168.5.85",14928);
  mac6 = new NetAddress("192.168.5.86",14929);

  for(int i = 0; i < numRows; i++)
  {
    for(int j = 0; j < numCols; j++)
    {
      tiles[i * numCols + j] = new HapticTile(j, i);
      tiles[i * numCols + j].setTexId(0);
    }
  }
}


void draw() {
  background(0);

  for(int i = 0; i < numRows; i++)
  {
    for(int j = 0; j < numCols; j++)
    {
      tiles[i * numCols + j].draw();
    }
  }
}

void mousePressed() {
  //if(!debug) return;

  float x = (float)mouseX / width * numCols;
  float y = (float)mouseY / height * numRows;

  HapticTile tile = tiles[(int)y * numCols + (int)x];
  tile.setTexId((tile.getTexId() + 1) % 6);
}

void keyPressed() {
  float x = (float)mouseX / width * numCols;
  float y = (float)mouseY / height * numRows;

 HapticTile tile = tiles[(int)y * numCols + (int)x];
 tile.trigger();

}

void oscEvent(OscMessage theOscMessage) {
    println("### received an osc message. with address pattern "+
          theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());

  if(theOscMessage.checkAddrPattern("/niw/crumpleparams")==true) {

    int x = theOscMessage.get(0).intValue();
    int y = theOscMessage.get(1).intValue();
    float f0 = theOscMessage.get(2).floatValue();
    float f1 = theOscMessage.get(3).floatValue();
    float f2 = theOscMessage.get(4).floatValue();
    float f3 = theOscMessage.get(5).floatValue();
    float f4 = theOscMessage.get(6).floatValue();
    float f5 = theOscMessage.get(7).floatValue();
    float f6 = theOscMessage.get(8).floatValue();
    float f7 = theOscMessage.get(9).floatValue();
    float f8 = theOscMessage.get(10).floatValue();
    float f9 = theOscMessage.get(11).floatValue();
    float f10 = theOscMessage.get(12).floatValue();
    float f11 = theOscMessage.get(13).floatValue();
    float f12 = theOscMessage.get(14).floatValue();

    HapticTile tile = tiles[(int)(y-1) * numCols + (int)(x-1)];
    tile.setParameters(f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12);
  }
  else if(theOscMessage.checkAddrPattern("/niw/preset")==true) {

    int x = theOscMessage.get(0).intValue();
    int y = theOscMessage.get(1).intValue();
    String s = theOscMessage.get(2).stringValue();

    HapticTile tile = tiles[(int)(y-1) * numCols + (int)(x-1)];
    tile.setTexId(s);
  }
  else if(theOscMessage.checkAddrPattern("/niw/trigger")==true) {

    int x = theOscMessage.get(0).intValue();
    int y = theOscMessage.get(1).intValue();

    HapticTile tile = tiles[(int)(y-1) * numCols + (int)(x-1)];
    tile.trigger();
  }
  else if(theOscMessage.checkAddrPattern("/niw/preset/all")==true) {

    String s = theOscMessage.get(0).stringValue();

    for(int i = 0; i < numRows; i++)
    {
      for(int j = 0; j < numCols; j++)
      {
        HapticTile tile = tiles[i * numCols + j];
        tile.setTexId(s);
      }
    }
  }
  else if(theOscMessage.checkAddrPattern("/niw/trigger/all")==true) {

    for(int i = 0; i < numRows; i++)
    {
      for(int j = 0; j < numCols; j++)
      {
        HapticTile tile = tiles[i * numCols + j];
        tile.trigger();
      }
    }
  }
}