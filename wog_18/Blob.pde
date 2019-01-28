class Blob {

  Body body;
  float size;
  int range;

  Blob(float x, float y) { // changed to floats
      
    range = 70;
    size = 12; 
    Vec2 center = new Vec2(x, y);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(size/2);

    // Define fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 100;
    fd.restitution = 0;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }


  void killBody() {
    box2d.destroyBody(body);
  }

  void win() {
    for (Body b : connected) {
      Vec2 bpos = box2d.getBodyPixelCoord(b);
      Vec2 endpos = box2d.getBodyPixelCoord(endpoint);
      if (dist(bpos.x, bpos.y, endpos.x, endpos.y)<endsize/2+size/2) {
        noLoop();
      }
    }
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body); 
    // Check if off screen
    if (pos.y > height+size) {
      killBody();
      return true;
    }
    return false;
  }
  
  boolean isinRange(Body other){
    Vec2 activepos = box2d.getBodyPixelCoord(body);
    Vec2 pos1 = box2d.getBodyPixelCoord(other);
    if (this.body == other){
      return false;
    }
    if (dist(activepos.x, activepos.y, pos1.x, pos1.y) < range){
          return true;
        }
        return false;
  }
  
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    image(gooball,0-size*4/2,0-size*4/2,size*4,size*4);
    popMatrix();
  }
}