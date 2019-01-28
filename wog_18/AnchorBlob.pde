class AnchorBlob {
  
  float bodyRadius;
  float radius;
  float totalPoints;
  int size;

  
  ConstantVolumeJointDef cvjd = new ConstantVolumeJointDef();
  
  AnchorBlob () {
    skeleton = new ArrayList<Body>();
    
    size = 40;
    radius = 15;
    totalPoints = 4;
    bodyRadius = 5;
    
    // Define position of box of AnchorBlob
    // Based on lower left corner
    int boxxpos = 40;
    int boxypos = 455;
    int [] Ax = {boxxpos, boxxpos+(int)bodyRadius*10, boxxpos+(int)bodyRadius*10, boxxpos};
    int [] Ay = {boxypos-(int)radius, boxypos-(int)radius, boxypos-(int)radius-(int)bodyRadius*10, boxypos-(int)radius-(int)bodyRadius*10};

    for (int i = 0; i < totalPoints; i++) {
      int x = Ax[i];
      int y = Ay[i];
      

      BodyDef bd = new BodyDef();
      bd.type = BodyType.STATIC;

      bd.fixedRotation = true; // no rotation!
      bd.position.set(box2d.coordPixelsToWorld(x, y));
      Body body = box2d.createBody(bd);

      // The body is a circle
      CircleShape cs = new CircleShape();
      cs.m_radius = box2d.scalarPixelsToWorld(bodyRadius);

      // Define a fixture
      FixtureDef fd = new FixtureDef();
      fd.shape = cs;


      fd.density = 1;

      // Finalize the body
      body.createFixture(fd);
      // Add it to the volume
      cvjd.addBody(body);


      // Store our own copy for later rendering
      skeleton.add(body);
    }
    box2d.world.createJoint(cvjd);
  }
  
   void display() {

    // Draw the outline
    beginShape();
    noFill();
    stroke(0);
    strokeWeight(5);
    for (Body b: skeleton) {
      Vec2 pos = box2d.getBodyPixelCoord(b);
      vertex(pos.x, pos.y);
    }
    endShape(CLOSE);

    // Draw the individual circles
    for (Body b: skeleton) {
      // We look at each body and get its screen position
      Vec2 pos = box2d.getBodyPixelCoord(b);
      pushMatrix();
      translate(pos.x, pos.y);
      image(gooball,0-size/2,0-size/2,size,size);
      popMatrix(); 
    }
  }
}