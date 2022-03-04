Spaceship s1;
Star[] stars = new Star[100];
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<PowerUp> PowerUp = new ArrayList<PowerUp>();
int score, level, rockTime, rockCount;
boolean play;
Timer rockTimer, puTimer;
PImage startScreen, gameOver;

void setup() {
  size(1000, 1000);
  s1 = new Spaceship();
  rockCount = 0;
  play = false;
  score = 0;
  level = 1;
  rockTime = 1000;
  rockTimer = new Timer(rockTime);
  rockTimer.start();
  puTimer = new Timer(5000);
  puTimer.start();
  play = false;
  startScreen = loadImage("start.png");
  gameOver = loadImage("GameOver.png");
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
}

void draw() {
  background(0);

  //check for the status of the play boolean
  if (!play) {
    startScreen();
  } else {
    if (frameCount % 1000 == 10) {
      level ++;
    }


    infoPanel();

    //Render stars
    for (int i = 0; i < stars.length; i++) {
      stars[i].display();
      stars[i].move();
      if (stars[i].reachedBottom()) {
        stars[i].y=-10;
      }
    }

    // Adding a rock based on the rock timer
    if (rockTimer.isFinished()) {
      rocks.add(new Rock(int(random(width)), -50));
      rockTimer.start();
    }


    // Render Rocks and detect ship collision
    for (int i=0; i<rocks.size(); i++) {
      Rock rock = rocks.get(i);
      rock.display();
      rock.move();
      if (rock.reachedBottom()) {
        rockCount++;
        rocks.remove(rock);
      }
      if (rock.intersect(s1)) {
        s1.health-=rock.health;
        rocks.remove(rock);
        score+=rock.diam;
      }
    }

    // Timer for Rocks
    if (rockTimer.isFinished()) {
      rocks.add(new Rock(int(random(width)), -100));
      rockTimer.start();
    }
    // Timer for Power Ups
    if (puTimer.isFinished()) {
      PowerUp.add(new PowerUp(int(random(width)), -100));
      puTimer.start();
    }
// Render powerup and detect ship collision
    for(int i = 0; i< PowerUp.size(); i++) {
      PowerUp pu = PowerUp.get(i);
      pu.display();
      pu.move();
      if(pu.intersect(s1)) {
        if(pu.type == 'h') {
          s1.health += 100;
        } else if(pu.type == 'l') {
          s1.laserCount += 100;
        } else {
          // add turret
        }
        PowerUp.remove(pu);
      }
      if(pu.reachedBottom()) {
        PowerUp.remove(pu);
      }
    }

    // Render lasers and detect rock collision
    for (int i=0; i<lasers.size(); i++) {
      Laser laser = lasers.get(i);
      for (int j=0; j<rocks.size(); j++) {
        Rock rock = rocks.get(j);
        if (laser.intersect(rock)) {
          lasers.remove(laser);
          rock.diam-=50;
          if (rock.diam<10) {
            rocks.remove(rock);
            score+=rock.health;
          }
        }
      }
      laser.display();
      laser.move();
      if (laser.reachedTop()) {
        lasers.remove(laser);
      }
    }

    // Render the spaceship
    noCursor();
    s1.display(mouseX, mouseY);

    // check the status of the play boolean and load game over if false
    if (s1.health<1 || rockCount > 9) {
      //play = false;
      gameOver();
      noLoop();
    }
  }
}
void infoPanel() {
  fill(127, 127);
  rectMode(CORNER);
  rect(0, 0, width, 50);
  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("RockCount" + rockCount +"Score:" + score + " Level:" + level + "Health:" + s1.health + "Ammo:" + s1.laserCount, width/2, 40);
}
void startScreen() {
  background(0); // cinaider using graphic
  textAlign(CENTER);
  textSize(40);
  fill(255);
  text("Welcome to spaceGame!", width/2, height/2);
  text("by Timothy Romanovsky", width/2, height/2+30);
  text("press spaceBar to Start", width/2, height/2+60);
  if (mousePressed) {
    play = true;
  }
}
void gameOver() {
  background(0);
  textAlign(CENTER);
  textSize(40);
  fill(255);
  text("game over!", width/2, height/2);
  text("final Score"+score, width/2, height/2+30);
  text("level achived"+level, width/2, height/2+60);
}

void mousePressed() {
  if (s1.fire()) {
    if (s1.turret == 1) {
      lasers.add(new Laser(s1.x, s1.y));
      s1.laserCount--;
    } else if (s1.turret == 2) {
      lasers.add(new Laser(s1.x-10, s1.y));
      lasers.add(new Laser(s1.x+10, s1.y));
      s1.laserCount--;
    }
  }
}

void keyPressed() {
  if (keyPressed) {
    if (key == ' ' ) {
      if (s1.turret == 1) {
        lasers.add(new Laser(s1.x, s1.y));
        s1.laserCount--;
      } else if (s1.turret == 2) {
        lasers.add(new Laser(s1.x-10, s1.y));
        lasers.add(new Laser(s1.x+10, s1.y));
        s1.laserCount--;
      }
    }
  }
}
