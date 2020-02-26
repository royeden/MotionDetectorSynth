import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.sound.*;
SqrOsc [] squareOsc = new SqrOsc [3];
Sound sound;

//https://pages.mtu.edu/~suits/notefreqs.html
float [] lowestNotes = {
  220.0, //A3
  261.63, //C4
  329.63 //E4
};
float [] highestNotes = {
  1760.0, //A6
  2093.0, //C7
  2637.02 //E7
};

int resolution = 4; //Adjust resolution (the higher the number, the less resolution there is)

Capture video;
OpenCV opencv;

void setup() {
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  fullScreen();
  video = new Capture(this, width/resolution, height/resolution);
  opencv = new OpenCV(this, width/resolution, height/resolution);
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  
  for (int i = 0; i < 3; i++) {
    squareOsc[i] = new SqrOsc(this);
    squareOsc[i].play();
  }
  
  sound = new Sound(this);
  sound.volume(0.4);

  video.start();
}

void draw() {
  background(0);
  scale(resolution);
  
  translate(video.width,0);
  scale(-1,1);
  
  opencv.loadImage(video);
  
  opencv.updateBackground();
  
  opencv.dilate();
  opencv.erode();

  for (Contour contour : opencv.findContours()) {
    Rectangle box = contour.getBoundingBox();
    for (int i = 0; i < 3; i++) {
      float freq = map(box.x + box.y, 0, width + height, lowestNotes[i], highestNotes[i]);
      squareOsc[i].freq(freq);
    }
    contour.draw();
  }
}

void captureEvent(Capture c) {
  c.read();
}
