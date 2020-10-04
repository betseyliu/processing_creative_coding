
class Point {
  float x, y; // x, y 坐标属性
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Point() {    // 构造函数重载
    x = 0;
    y = 0;
  }
  
  Point copy() {
    return new Point(x, y); // 返回一个副本
  }
}

class VisualPoint extends Point {
  float w; // 大小
  color c; // 颜色
  
  VisualPoint(float x, float y, float w, color c) {
    super(x, y); // 把x，y参数传递给父类Point的构造函数
    this.w = w;
    this.c = c;
  }
  
  void display() {
    stroke(c);  // 设置颜色
    strokeWeight(w); // 设置大小
    point(x,  y); // 绘制点
  }
}

void setup() {
  String filename = this.getClass().getName();
  size(1000, 1000);
  background(255);
  ellipseMode(RADIUS);
  rectMode(CORNER);
  stroke(0);
  noFill();
  render();
  saveFrame(filename + ".jpg");
}

void render() {
  //evenlyDistributedPoints();
  sparseUpAndDensePoints();
}


// 均匀分布的点
void evenlyDistributedPoints() {
  VisualPoint[] points = new VisualPoint[1000]; // 创建数组，个数为1000；
  for(int i = 0; i < 1000; i++) {
    float x = random(width);
    float y = random(height);
    float w = random(1, 20);
    color c = color(random(200));
    
    points[i] = new VisualPoint(x, y, w, c);
  }
  
  for(VisualPoint p: points) {
    p.display();
  }
}


void sparseUpAndDensePoints() {
  VisualPoint[] points = new VisualPoint[1000];
  
  for(int i = 0; i < 1000; i++) {
    float x = random(width);
    float random = pow(random(1), .2); // 用幂函数转换随机数
    float y = map(random, 0, 1, 0, height); // 对随机数进行映射
    float w = random(1, 20);
    color c = color(random(200));    
    points[i] = new VisualPoint(x, y, w, c);
  }
  
  for(VisualPoint p: points) {
    p.display();
  }
}
