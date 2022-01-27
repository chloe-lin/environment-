import java.awt.Robot; 

//colour pallette 
color black = #000000; //oak planks 
color white = #FFFFFF; //empty space 
color blue  = #C8E7FF; //mossy bricks 

//textures 
PImage mossystone, wood; 

//map variables 
int gridSize; 
PImage map; 

//robot for mouse control 
Robot rbt; 
boolean skipFrame; 

boolean wkey, akey, skey, dkey; 
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ; 
float leftRightHeadAngle, upDownHeadAngle; 

void setup() { 
  size(displayWidth, displayHeight, P3D); 
  mossystone = loadImage("mossystone.png"); 
  wood = loadImage("wood.jpg"); 
  textureMode(NORMAL); 

  wkey = akey = skey = dkey = false; 

  eyeX = width/2; 
  eyeY = 9*height/10; 
  eyeZ = height/2; 

  focusX = width/2; 
  focusY = height/2; 
  focusZ = height/2 - 100; 

  upX = 0; 
  upY = 1; 
  upZ = 0; 

  leftRightHeadAngle = radians(270);

  try { 
    rbt = new Robot();
  } 
  catch(Exception e) { 
    e.printStackTrace();
  }
  skipFrame = false; 

  //initialize map 
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() { 
  background(0); 

  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ); 
  drawFloor();
  drawFocalpoint();
  drawMap(); 
  controlCamera();
}

void drawMap() { 
  for (int x = 0; x < map.width; x++) { 
    for (int y = 0; y < map.height; y++) { 
      color c  = map.get(x, y); 
      if (c == blue) { 
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossystone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossystone, gridSize); 
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossystone, gridSize);
      } 
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, wood, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, wood, gridSize); 
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, wood, gridSize);
      }
    }
  }
}

void drawFocalpoint() { 
  pushMatrix(); 
  translate(focusX, focusY, focusZ);
  sphere(5); 
  popMatrix();
}

void drawFloor() { 
  stroke(255); 
  for (int x = -2000; x <= 2000; x = x + 100) { 
    for (int z = -2000; z <=2000; z = z + 100) {
      //line(x, height, -2000, x, height, 2000); 
      //line(-2000, height, x, 2000, height, x);
      //line(x, height-gridSize*3, -2000, x, height-gridSize*3, 2000); 
      //line(-2000, height-gridSize*3, x, 2000, height-gridSize*3, x);
      texturedCube(x, height, z, wood, gridSize);
      texturedCube(x, height-gridSize*4, z, wood, gridSize);
    }
  }
}

void controlCamera() {  
  if (wkey) { 
    eyeX = eyeX + cos(leftRightHeadAngle)*10; 
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) { 
    eyeX = eyeX - cos(leftRightHeadAngle)*10; 
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) { 
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10; 
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10; 
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2)*10;
  }

  if (skipFrame == false) { 
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01; 
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  } 

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5; 
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300; 
  focusZ = eyeZ + sin(leftRightHeadAngle)*300; 
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (mouseX > width-2) { 
    rbt.mouseMove(width-3, mouseY); 
    skipFrame = true;
  } else if (mouseX < 2) { 
    rbt.mouseMove(3, mouseY); 
    skipFrame = false;
  } else { 
    skipFrame = false;
  }
}


void keyPressed() { 
  if (key == 'W' || key == 'w') wkey = true; 
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
} 

void keyReleased() { 
  if (key == 'W' || key == 'w') wkey = false; 
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
