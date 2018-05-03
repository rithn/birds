Boid barry;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;

int depth = 160;

float globalScale = 1;
float eraseRadius = 20;
String tool = "boids";

// boid control
float maxSpeed;
float friendRadius;
float crowdRadius;
float avoidRadius;
float coheseRadius;

boolean option_friend = true;
boolean option_crowd = true;
boolean option_avoid = true;
boolean option_noise = true;
boolean option_cohese = true;

// gui crap
int messageTimer = 0;
String messageText = "";

void setup () {
  size(1300, 700, P3D);
  textSize(16);
  recalculateConstants();
  boids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  setupWalls();
}

// SAFE
void recalculateConstants () {
  maxSpeed = 2.1 * globalScale;
  friendRadius = 60 * globalScale;
  crowdRadius = (friendRadius / 1.3);
  avoidRadius = 90 * globalScale;
  coheseRadius = friendRadius;
}

// SAFE
void setupWalls() {
  avoids = new ArrayList<Avoid>();
  for (int x = 0; x <= (width/4); x+= 10) {
    for (int z = 0; z <= depth; z+=10){
      avoids.add(new Avoid(x, 0, z));
      avoids.add(new Avoid(x, height/2, z));
    } 
  }
  for (int y = 0; y <= (height/2); y+= 10) {
     for (int z = 0; z <= depth; z+=10){
    avoids.add(new Avoid(0, y, z));
    avoids.add(new Avoid(width/4, y, z));
    } 
  }
  for (int x = 0; x <= (width/4); x+= 10) {
     for (int y = 0; y <= (height/2); y+=10){
    avoids.add(new Avoid(x, y, 0));
    avoids.add(new Avoid(x, y, depth));
    } 
  }
}


void draw () {
  noStroke();
  colorMode(HSB);
  fill(0, 100);
  rect(0, 0, width, height);
  stroke(255);
  translate(width/2, height/4, 0);
  rotateX(PI/4);
  rotateZ(PI/4);
  fill(#590089);
  rect(0, 0, width/4, height/2);
  line(0.0,0.0,0.0,0.0,0.0,depth);
  line(width/4,0.0,0.0,width/4,0.0,depth);
  line(0.0,height/2,0.0,0.0,height/2,depth);
  line(width/4,height/2,0.0,width/4,height/2,depth);
  line(0.0,0.0,depth,width/4,0.0,depth);
  line(0.0,0.0,depth,0.0,height/2,depth);
  line(0.0,height/2,depth,width/4,height/2,depth);
  line(width/4,height/2,depth,width/4,0.0,depth);
  if (tool == "erase") {
    noFill();
    stroke(0, 100, 260);
    rect(mouseX - eraseRadius, mouseY - eraseRadius, eraseRadius * 2, eraseRadius *2);
    if (mousePressed) {
      erase();
    }
  } else if (tool == "avoids") {
    noStroke();
    fill(0, 200, 200);
    ellipse(mouseX, mouseY, 15, 15);
  }
  for (int i = 0; i <boids.size(); i++) {
    Boid current = boids.get(i);
    current.go();
    current.draw();
  }

  for (int i = 0; i <avoids.size(); i++) {
    Avoid current = avoids.get(i);
    current.go();
    current.draw();
  }

  if (messageTimer > 0) {
    messageTimer -= 1; 
  }
  drawGUI();
}

void keyPressed () {
  if (key == 'q') {
    tool = "boids";
    message("Add boids");
  } else if (key == 'w') {
    tool = "avoids";
    message("Place obstacles");
  } else if (key == 'e') {
    tool = "erase";
    message("Eraser");
  } else if (key == '-') {
    message("Decreased scale");
    globalScale *= 0.8;
  } else if (key == '=') {
      message("Increased Scale");
    globalScale /= 0.8;
  } else if (key == '1') {
     option_friend = option_friend ? false : true;
     message("Turned friend allignment " + on(option_friend));
  } else if (key == '2') {
     option_crowd = option_crowd ? false : true;
     message("Turned crowding avoidance " + on(option_crowd));
  } else if (key == '3') {
     option_avoid = option_avoid ? false : true;
     message("Turned obstacle avoidance " + on(option_avoid));
  }else if (key == '4') {
     option_cohese = option_cohese ? false : true;
     message("Turned cohesion " + on(option_cohese));
  }else if (key == '5') {
     option_noise = option_noise ? false : true;
     message("Turned noise " + on(option_noise));
  } else if (key == ',') {
     setupWalls(); 
  }
  recalculateConstants();

}

// SAFE
void drawGUI() {
   if(messageTimer > 0) {
     fill((min(30, messageTimer) / 30.0) * 255.0);

    text(messageText, 10, height - 20); 
   }
}

// SAFE
String s(int count) {
  return (count != 1) ? "s" : "";
}

String on(boolean in) {
  return in ? "on" : "off"; 
}

// SAFE
void mousePressed () {
  switch (tool) {
  case "boids":
    boids.add(new Boid(((mouseX-width/4)/sqrt(3)+(mouseY - (height/2))), (mouseY-(height/2))-((mouseX-(width/4))/sqrt(3)), depth/2));
    message(boids.size() + " Total Boid" + s(boids.size()));
    break;
  case "avoids":
    avoids.add(new Avoid((mouseX-(width/4))/sqrt(3)+(mouseY - height/2), (mouseY-(height/2))-((mouseX-(width/4))/sqrt(3)),0));
    break;
  }
}

// SAFE
void erase () {
  for (int i = boids.size()-1; i > -1; i--) {
    Boid b = boids.get(i);
    if (abs(b.pos.x - mouseX) < eraseRadius && abs(b.pos.y - mouseY) < eraseRadius) {
      boids.remove(i);
    }
  }

  for (int i = avoids.size()-1; i > -1; i--) {
    Avoid b = avoids.get(i);
    if (abs(b.pos.x - mouseX) < eraseRadius && abs(b.pos.y - mouseY) < eraseRadius) {
      avoids.remove(i);
    }
  }
}

// SAFE unused
void drawText (String s, float x, float y) {
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}


void message (String in) {
   messageText = in;
   messageTimer = (int) frameRate * 3;
}
