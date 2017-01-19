 
int barWidth = 15;
int lastBar = -1;
float x;
float y;
float easing = 0.05;

void setup() 
{
  size(1000, 700);
  colorMode(HSB, height, height, height);  
  noStroke();
  background(1000000);
}

void draw() 
{
  int whichBar = mouseX / barWidth;
  if (whichBar != lastBar) {
    int barX = whichBar * barWidth;
    fill(mouseY, height, height);
    rect(barX, 0, barWidth, height);
    lastBar = whichBar;
  }
   { 
  float targetX = mouseX;
  float dx = targetX - x;
  x += dx * easing;
  
  float targetY = mouseY;
  float dy = targetY - y;
  y += dy * easing;
  
  ellipse(x, y, 66, 66);
}
}