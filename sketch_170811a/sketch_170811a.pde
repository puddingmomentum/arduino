import ddf.minim.*; //<>// //<>// //<>// //<>//
/* This requires speakers or headphones to be attached
 or else the audio will fail to load
 */

import processing.serial.*;
import java.io.File;
import java.util.Vector;
import java.util.Collections;

Serial myPort;
int nl = int('\n');
String sInput = "0";
int currPlayer = -1;

int numSounds = 0;
Minim minim;
AudioPlayer[] player;

PFont font;

short portIndex = 0;
String portName;
String filename;
String dir;
Vector<File> files;


void setup() {
  // put your setup code here, to run once:
  size(640, 480);
  font = createFont("Arial", 16, true);

  minim = new Minim(this);
  println(" Connecting to -> " + Serial.list()[portIndex]);
  try {
    portName = Serial.list()[portIndex];
  } 
  catch (ArrayIndexOutOfBoundsException ae) {
    println("Index error. Serial list: " + Serial.list());
    return;
  }
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(nl);

  dir = new String("C:\\Users\\rober\\Development\\arduino\\sketch_170811a\\sounds");
  files = new Vector<File>();

  getdir(dir, files);
  numSounds = files.size();
  System.out.println(numSounds);

  player = new AudioPlayer[numSounds];

  int i = 0;
  for (File f : files) {
    player[i] = minim.loadFile(f.getAbsolutePath());
    i++;
  }

  frameRate(10);
}

void draw() {
  background(255);
  stroke(255);
  textFont(font, 36);
  fill(0);  
  sInput = "";
  int iInput = 0;
  String[] list;
  

  if (myPort.available() > 0) {
    sInput = myPort.readString();
    //    System.out.println(sInput);
    list = split(sInput, '\r');
    ArrayList<Integer> values = new ArrayList<Integer>(15);
    try {
      for (String a : list) {
        if (!a.isEmpty()) { 
          try {
            values.add( (new Integer(a)).intValue() );
          } 
          catch (NumberFormatException e) {
          }
        }
      }
    } 
    catch (NullPointerException np) {
    }
    Collections.sort(values);
    //for (Integer i : values) {
    //  System.out.println("Sorted: " + i);
    //}
    if (!values.isEmpty()) {
      iInput = values.get(0);
      System.out.println("Top Value: " + iInput);

      if (iInput > 100) {
        if (currPlayer == files.size() || currPlayer == -1) {currPlayer = 0;}
          else {currPlayer++;}
          println("currPlayer: " + currPlayer);        
          //try {
        //  if (player[currPlayer].isPlaying()) { player.pause(); }
        //} catch (ArrayIndexOutOfBoundsException ae) {}
        if (!sInput.isEmpty()) {
          text(sInput, 10, 100);
        }
 //       currPlayer = round(random(numSounds));
        player[currPlayer].play();
        //while (player[currPlayer].isPlaying()) {}
        delay(1000);
        player[currPlayer].pause();
        player[currPlayer].rewind();
        player[currPlayer].cue(0);
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
  //  File f;
  File[] list;
  try {
    //    f = new File(dir);
    list  = new File(dir).listFiles(new MyFilter());

    for (File f : list) {
      System.out.println(f.getName());
      files.add(f);
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