//Oguz Yetkin 11/1/2018
//oyetkin@gmail.com
//based on code developed in conjunction with Mr. Naresh Lakshman Raman in 2012
//rotates a servo in given increments and takes a picture with a specified camera


int min_frame = 0;
int max_frame = 48;
int current_frame = min_frame;
int FRAME_INCREMENT = 1;
int capture_delay_ms = 5000;

boolean doStart = false;


import processing.video.*;
import processing.serial.*;
String filePath = "C:\\Users\\HP\\Desktop\\Holografik_3D_Nesne_Görüntüleme _Sistemi\\mikro_tarama\\";
int camera_index = 1; //determine this for your camera
int serial_port_index = 2; //determine this for your Arduino
Serial myPort;  // Create object from Serial class

Capture cam;
int hframe=0;
int done = 0;

String filebase= new String("Frame");
long start_time=0;
long time_elapsed=0;

void make_quilt(){
  String path=filePath+"tarama\\"+filebase;
  String format=".png";
  for(int i=0;i<6;i++){
    for(int j=7;j>=0;j--){
      String s=String.format("%04d",i*8+(8-j));
      println(s);
      PImage img=loadImage(path+s+format);
      image(img,j*420,i*560);
    }
  }
  save(filePath+"quilts\\quilt_qs8x6a0.75.png");
}

void right(){
  String path=filePath+"tarama\\"+filebase;
  String format=".png";
  for(int i=1;i<=max_frame;i++){
    String s=String.format("%04d",i);
    PImage img=loadImage(path+s+format);
    println(s);
    
    pushMatrix();  
    translate(width/2, height/2);  
    rotate(-HALF_PI);  
    image(img, -img.width/2, -img.height/2);  
    popMatrix();
    
    PImage imge=get(1470, 1400, 420, 560);
    imge.save(path+s+format);
  }
}

void delay(int ms) {
  try {
    Thread.sleep(ms);
  } 
  catch (InterruptedException e) {
  }
}

void setup() {
  size(3360, 3360);
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      print(i);
      print(" ");
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[camera_index]);
    cam.start();
  }
  printArray(Serial.list());
  String portName = Serial.list()[serial_port_index];
  myPort = new Serial(this, portName, 9600);
  myPort.write("\n");
  delay(500);
  myPort.write("1\n");
  delay(500);
  cam.read();
  start_time =millis();
}

void draw() {
  if(done==1){
    return;
  }
  if (cam.available() == true) {
    cam.read();

    image(cam, 0, 0, 560, 420);
    if (hframe > max_frame) {
      done = 1;
    }
    
    //start capture only after capture_delay_ms milliseconds
    time_elapsed = millis()-start_time;
    if (capture_delay_ms > time_elapsed) {
      doStart = false;
      println(capture_delay_ms-time_elapsed);
    } else {
        doStart = true;
    }

    String filename = new String();
    String frameString;

    if (done == 0 && doStart ) {
      
        frameString = "1\n";
        println(hframe+1);
        myPort.write(frameString);
        cam.read();
        println("reading camera again");
        
        delay(500);
        filename = String.format(filePath+"tarama\\%s%04d.png", filebase, hframe);
        PImage imge=get(0, 0, 560, 420);
        imge.save(filename);
        println(filename);
        delay(500);
        hframe+=FRAME_INCREMENT;
      }
    }
  
  if (done == 1) {
    myPort.stop();
    println("we are done");
    File file = new File(filePath+"tarama\\Frame0000.png");
    file.delete();
    right();
    println("rotated right");
    make_quilt();
    println("quilt made");
  }
}
