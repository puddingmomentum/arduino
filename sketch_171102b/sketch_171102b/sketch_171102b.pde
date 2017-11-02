import ddf.minim.*;

/* This requires speakers or headphones to be attached
   or else the audio will fail to load
*/

Minim minim;
AudioPlayer player;

void setup() {
  minim = new Minim(this);
  File f = new File("C:\\Users\\rober\\Development\\arduino\\sketch_170811a\\sounds\\Eye_of_the_Tiger_Hit_1.wav");
  player = minim.loadFile(f.getAbsolutePath());
  //println(f.getAbsolutePath());
}

void draw() {
  player.play(); //<>//
//  while (player.isPlaying()) {}
  delay(1000);
  println("Song finished");
  player.pause();
  player.rewind();
  player.cue(0);

}