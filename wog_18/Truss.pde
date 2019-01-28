class Truss {
  
  float len; 
  Body activeblob;
  Body staticblob1;   
  
  Truss(Body ab, Body sb){
    // Length of Distance Joint
    len = 60;
    
    activeblob = ab;
    staticblob1 = sb;
    
    // Create Distance Joint
    DistanceJointDef djd = new DistanceJointDef();
    
    djd.bodyA = activeblob;
    djd.bodyB = staticblob1;
    
    // Chance springiness of joint here
    djd.length = box2d.scalarPixelsToWorld(len);
    djd.frequencyHz = 2;
    djd.dampingRatio = 0.1;

    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
  }
  
  void display() {
    Vec2 active_pos = box2d.getBodyPixelCoord(activeblob);
    Vec2 pos1 = box2d.getBodyPixelCoord(staticblob1);
    stroke(0);
    strokeWeight(3);
    line(active_pos.x, active_pos.y, pos1.x,pos1.y);
  }
}