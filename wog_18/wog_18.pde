import shiffman.box2d.*;
import processing.sound.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


Box2DProcessing box2d;

ArrayList<Boundary> boundaries;
ArrayList<Body> skeleton;
ArrayList<Body> connected;
ArrayList<Blob> goo;
ArrayList<Truss> truss; 
AnchorBlob anchorgoo;
Spring spring;
Body endpoint;
SoundFile Blopsound;
SoundFile rainsound;
SoundFile bye;
PImage bg;
PImage gooball;
PImage metal;
PImage vortex;
PImage exit;
int counter;
int endsize = 20;

void setup() {

  size(800, 600);
  smooth();
  bg = loadImage("depressing.jpg");
  gooball= loadImage("gooball.png");
  metal = loadImage("metal.jpg");
  vortex = loadImage("vortex.png");
  exit = loadImage("exit.png");

  Blopsound = new SoundFile(this, "Bloping.mp3");
  rainsound = new SoundFile(this, "rainsound.mp3");
  bye = new SoundFile(this, "bye.mp3");
  rainsound.play();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Define boundaries
  boundaries = new ArrayList<Boundary>();
  //boundaries.add(new Boundary(750, 200, 100, 50)); //Right Side Block
  //boundaries.add(new Boundary(180, 425, 50, 350)); //Pole
  boundaries.add(new Boundary(450, 425, 50, 350)); // Pole
  boundaries.add(new Boundary(50, 525, 100, 150)); // Left Side Block
  // Container
  boundaries.add(new Boundary(width-7, 500, 7, 200)); 
  boundaries.add(new Boundary(width-100, 500, 7, 200)); 
  boundaries.add(new Boundary(width-55, height-3, 91, 7));

  //AnchorBlob
  anchorgoo = new AnchorBlob();

  //Blob
  goo = new ArrayList<Blob>();
  Blob b;
  // Change Number of Gooballs here
  int Goonum = 40;
  counter = Goonum;
  for (int i = 0; i < Goonum; i++) {
    b = new Blob(750, 450); 
    goo.add(b);
  }

  //Truss
  truss = new ArrayList<Truss>();

  //connectedBlobs
  connected = new ArrayList<Body>();
  for (Body skele : skeleton) {
    connected.add(skele);
  }

  // Spring
  spring = new Spring();
}

// ===================== Mouse Released =================================
void mouseReleased() {
  spring.destroy();
  for (Blob b : goo) {
    // Blob you are holding
    if (b.contains(mouseX, mouseY)) {
      for (int i = connected.size()-1; i >= 0; i--) {
        if (b.isinRange(connected.get(i))) { 
          // Create new truss
          Truss t = new Truss(b.body, connected.get(i));
          // Add truss
          truss.add(t);
          Blopsound.play();
          // Add Blob you are holding to connected ArrayList
          if (!connected.contains(b.body)){
          connected.add(b.body);
          }// if not connected
        }// if inRange
      }// for Body
    }
  }
  println("How many connected: "+connected.size());
  println("How many trusses: " + truss.size());
}

// ===================== Mouse Pressed =================================
void mousePressed() {
  for (Blob b : goo) {
    if (b.contains(mouseX, mouseY)) {
      // Make Blob follow mouse
      spring.bind(mouseX, mouseY, b);
    }
  }
}


// ===================== Draw =================================
void draw() {
  background(bg);
  box2d.step();
  textSize(20);
  fill(255);
  text("Goo Left: " + counter, 10, 20);
  if (frameCount % 1500 == 0){
    rainsound.play();
  }
  
  //Spring
  spring.update(mouseX, mouseY);

  // Blob
  for (Blob b : goo) {
    if (b.contains(mouseX, mouseY)) {
      for (int i = connected.size()-1; i >= 0; i--) {
        if (b.isinRange(connected.get(i))) {
          if (mousePressed) {
              Vec2 bpos = box2d.getBodyPixelCoord(b.body);
              Vec2 skelepos = box2d.getBodyPixelCoord(connected.get(i));
              strokeWeight(2);
              stroke(255, 150);
              line(bpos.x, bpos.y, skelepos.x, skelepos.y);
          }
        }
      }
    }
  }

  // Endpoint
  CircleShape cs = new CircleShape();
  FixtureDef ef = new FixtureDef();
  ef.shape = cs;

  BodyDef end = new BodyDef();
  end.type = BodyType.STATIC;
  end.position.set(box2d.coordPixelsToWorld(560, 50));

  endpoint = box2d.createBody(end);
  endpoint.createFixture(ef);

  Vec2 pos = box2d.getBodyPixelCoord(endpoint);
  rectMode(CENTER);
  pushMatrix();
  translate(pos.x, pos.y);
  fill(0,100);
  noStroke();
  ellipse(0, 0, endsize*2, endsize);
  image(vortex,0-endsize*8/2,0-endsize*4/2, endsize*8, endsize*4);
  popMatrix();


  //AnchorBlob
  anchorgoo.display();

  //Truss
  for (Truss t : truss) {
    t.display();
  }

  //Blob
  for (Blob b : goo) {
    b.display();
    b.win();
  }
  //Remove Blob
  for (int i = goo.size()-1; i >= 0; i--) {
    Blob b = goo.get(i);
    if (b.done()) {
      bye.play();
      bye.amp(0.7);
      goo.remove(i);
      connected.remove(b.body); // do this later.
      counter -= 1;
    }
  }

  //Boundary
  for (Boundary wall : boundaries) {
    wall.display();
  }
  
  //Spring
  spring.display();
  
}


void reset (){
  
}