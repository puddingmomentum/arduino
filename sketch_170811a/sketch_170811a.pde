import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.serial.*;
import java.io.File;
import java.util.Vector;
import java.util.Collections;

Serial myPort;
int nl = int('\n');
String sInput = "0";
Minim minim;
AudioPlayer player;
PFont font;
short portIndex = 0;
String portName;
String filename;
String dir;
Vector<File> files;


void setup() {
  // put your setup code here, to run once:
  size(640, 480, P2D);
  font = createFont("Arial", 16, true);


  println(" Connecting to -> " + Serial.list()[portIndex]);
  portName = Serial.list()[portIndex];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(nl);

  dir = new String("/home/rob/sketchbook/arduino/sketch_170811a/sounds");
  files = new Vector<File>();

  int retval = getdir(dir, files);
  System.out.println(files.firstElement().getPath());
  //for (File f : files) {
  //  System.out.println(f.getName());
  //}

  // filename = filename.replaceAll(" ", "\ ");

  frameRate(10);
  minim = new Minim(this);
}

void draw() {
  background(255);
  stroke(255);
  textFont(font, 36);
  fill(0);  
  sInput = "";
  int iInput = 0;
  String[] list;

  filename = files.firstElement().getPath();  // change to random choice or sequential
  player = minim.loadFile(filename, 1024);

  if (myPort.available() > 0) {
    sInput = myPort.readString();
    //    System.out.println(sInput);
    list = split(sInput, '\r');
    ArrayList<Integer> values = new ArrayList<Integer>(15);
    for (String a : list) {
      if (!a.isEmpty()) { 
        try {
          values.add( (new Integer(a)).intValue() );
        } 
        catch (NumberFormatException e) {
        }
      }
    }
    Collections.sort(values);
    //for (Integer i : values) {
    //  System.out.println("Sorted: " + i);
    //}
    if (!values.isEmpty()) {
      iInput = values.get(0);
      System.out.println("Top Value: " + iInput);

      if (iInput > 100) {
        if (player.isPlaying()) { player.pause(); }
        if (!sInput.isEmpty()) {
          text(sInput, 10, 100);
        }
        player.play();
      }
    }
  }
}

//void sort(ArrayList<Integer> list) {
//  Collections.sort(list, new Comparator<Integer>() {
//    @Override
//      public int compare(Integer i1, Integer i2) {
//      return i1.intValue() > i2.intValue();
//    }
//  });
//}

int getdir(String dir, Vector<File> files) {
  File f;
  File[] list;
  try {
    f = new File(dir);
    list  = f.listFiles(new MyFilter());

    for (File fi : list) {
      System.out.println(fi.getName());
      files.add(fi);
    }
  } 
  catch (NullPointerException e) {
    return -1;
  }

  return 0;
}

class MyFilter implements java.io.FilenameFilter {
  boolean accept(File dir, String name) {
    return name.endsWith(".wav");
  }
}