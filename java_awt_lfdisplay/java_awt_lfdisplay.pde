//
//
//Automated program to spin object in Blender and take screenshots
//from the Looking Glass device
//
//Written by Kerem Bozkaya
//based on an original program by Eren Akcin
//Project Team: Kerem Bozkaya, Cansu Deniz Yetkin, Bulut Bolcal, Caglar Balik, supervised by Oguz Yetkin

import java.awt.*;
import java.awt.event.*;

PImage screenshoti;

int rec ;
Robot robot;
PFont pfont;
Point save_p;
 
void setup() {
  size(320, 240);
  try { 
    robot = new Robot();
    robot.setAutoDelay(0);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  pfont = createFont("Impact", 32);
}
 
void draw() {
  background(#ffffff);
  fill(#000000);
  
  Point p = getGlobalMouseLocation();
  
  textFont(pfont);
  text("now x=" + (int)p.getX() + ", y=" + (int)p.getY(), 10, 32);
  
  if (save_p != null) {
  text("save x=" + (int)save_p.getX() + ", y=" + (int)save_p.getY(), 10, 64);
  }
}

void keyPressed() {
  switch(key) {
  case 's':
    save_p = getGlobalMouseLocation();
    break;
  case 'm':
    if (save_p != null) {
      mouseMove((int)save_p.getX(), (int)save_p.getY());
    }
    break;
  case 'c':
  case ' ':
    if (save_p != null) {
      mouseMoveAndClick((int)save_p.getX(), (int)save_p.getY());
      for(int i=0;i<1;i++){
        for(int j=1;j<=369;j++){
        mouseMove((int)save_p.getX()+(j),(int)save_p.getY()+i*5);
        screenshot();
        String fileName = "image"+String.format("%03d_%03d",i,j)+".png";
        println(fileName);
        screenshoti.save(savePath(fileName));
        delay(20000);
        }
      }
    }
    break;
  }
}

Point getGlobalMouseLocation() {
  // java.awt.MouseInfo
  PointerInfo pointerInfo = MouseInfo.getPointerInfo();
  Point p = pointerInfo.getLocation();
  return p;  
}

void mouseMove(int x, int y) {
  robot.mouseMove(x, y);
}

void mouseMoveAndClick(int x, int y) {
  robot.mouseMove(x, y);
  robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
}

void screenshot() {
  try {
    screenshoti = new PImage(new Robot().createScreenCapture(new Rectangle(-1536, 0, 1536, 2048)));
  } catch (AWTException e) { }
}
