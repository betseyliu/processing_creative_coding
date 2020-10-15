int POINT_NUMBER = 100;

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

  float distance(Point p) {
    float dx = x - p.x;
    float dy = y - p.y;
    return sqrt(dx * dx + dy * dy);
  }

  void rotate(Point p, float a) {
    float dx = x - p.x;
    float dy = y - p.y;

    x = p.x + cos(a) * dx - sin(a) * dy;
    y = p.y + sin(a) * dx + cos(a) * dy;
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
  saveFrame(filename + ".jpg");
  render();
}

void render() {
  // evenlyDistributedPoints();
  // sparseUpAndDensePoints();
  // insideCirclePoints();
  // matrixOfPoints();
  // evenlyDistributedPointsInCircle();
  // linkPoints();
  // rotateAroundCenter();
  // rotateAroundPoint();
  linkRotatePoint();
}


// 均匀分布的点
void evenlyDistributedPoints() {
  VisualPoint[] points = new VisualPoint[POINT_NUMBER]; // 创建数组，个数为1000；
  for(int i = 0; i < POINT_NUMBER; i++) {
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


// y轴下密上疏的点
void sparseUpAndDensePoints() {
  VisualPoint[] points = new VisualPoint[POINT_NUMBER];
  
  for(int i = 0; i < POINT_NUMBER; i++) {
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

// 位于一个圆内的点
void insideCirclePoints() {
  VisualPoint[] points = new VisualPoint[POINT_NUMBER];
  
  for(int i = 0; i < POINT_NUMBER; i++) {
    float radian = random(TAU);
    // float radius = random(450);
    float radius = pow(random(1), .1) * 450;
    float x = cos(radian) * radius;
    float y = sin(radian) * radius; // 对随机数进行映射
    float w = random(1, 20);
    color c = color(random(200));    
    points[i] = new VisualPoint(x, y, w, c);
  }
  translate(width / 2, height /2);
  for(VisualPoint p: points) {
    p.display();
  }
}

// 矩阵分布
void matrixOfPoints() {
  int col = 49;
  int row = 49;
  float margin = 50;
  VisualPoint[] points = new VisualPoint[col * row];


  for(int c = 0; c < col; c++) {
    for(int r = 0; r < row; r++) {
      float x = map(r, 0, col - 1, margin, width - margin);
      float y = map(c, 0, row - 1, margin, height - margin);
      float w = 5;
      color cl = color(150);

      int index = r + row * c;

      if(index % 2 == 0) {
        w = 10;
        cl = color(0);
      }

      points[index] = new VisualPoint(x, y , w, cl);
    }
  }
  for(VisualPoint p: points) {
    p.display();
  }
}

// 判断是否是素数
boolean isPrime(int number) {
  for(int i = 2; i <= int(number / 2 + 1); i++) {
    if(number % i == 0) return false;
  }

  return true;
}

// 圆内部均匀分布的点
void evenlyDistributedPointsInCircle() {
  ArrayList<VisualPoint> points = new ArrayList<VisualPoint>();

  float radius = 300;
  float radian = 0;
  float arc = 20;
  int count = 0;
  int index = 0;

  while(radius < 450) {
    float x = cos(radian) * radius;
    float y = sin(radian) * radius;
    float w = random(1, 15);
    color c = color(random(200));
    if(isPrime(index)) {
      w = 10;
      c = color(255, 0 , 0);
    }

    VisualPoint p = new VisualPoint(x, y, w, c);
    points.add(p);

    int n = int(TAU * radius / arc);
    radian += TAU / n;
    count++;
    index++;
    if(count == n) {
      radius += 20;
      count = 0;
      radian = 0;
    }

  }

  translate(width / 2, height / 2);
  for(VisualPoint p: points) {
    p.display();
  }
}

// 根据距离连接点
void linkPoints() {
  Point[] points = new Point[POINT_NUMBER];
  float maxDistance = 300;

  for(int i = 0; i < POINT_NUMBER; i++) {
    points[i] = new Point(random(width), random(height));
  }

  for(int i = 0; i < points.length; i++) {
    Point a = points[i];

    for(int j = i + 1; j < points.length; j++) {
      Point b = points[j];
      float d = b.distance(a);

      if (d < maxDistance) {
        float alpha = map(d, 0, maxDistance, 255,  0);
        float weight = map(d, 0, maxDistance, 2, 0);

        stroke(0, alpha);
        strokeWeight(weight);
        line(a.x, a.y, b.x, b.y);
      }

    }
  }
}

// 围绕中心点旋转
void rotateAroundCenter() {
  Point center = new Point(width / 2, height / 2);
  float a = 0.01;

  VisualPoint[] points = new VisualPoint[POINT_NUMBER];

  for(int i = 0; i < points.length; i++) {
    float x = random(width);
    float y = random(height);
    float w = random(1, 3);
    color c = color(random(200));

    points[i] = new VisualPoint(x, y, w, c);
  }

  for(int time = 0; time < 100; time++) {
    for(int i = 0; i < points.length; i++) {
      points[i].rotate(center, a);
      points[i].display();
    }
  }

}

// 围绕前一点转
void rotateAroundPoint() {
  float a = 0.01;

  VisualPoint[] points = new VisualPoint[POINT_NUMBER];

  for(int i = 0; i < points.length; i++) {
    float x = random(width);
    float y = random(height);
    float w = random(1, 3);
    color c = color(random(200));

    points[i] = new VisualPoint(x, y, w, c);
  }

  for(int time = 0; time < 100; time++) {
    for(int i = 0; i < points.length  - 1; i++) {
      points[i].rotate(points[i + 1], a);
      points[i].display();
    }
  }

}

void linkRotatePoint() {
  Point[] points = new Point[POINT_NUMBER];

 
  for(int i = 0; i < POINT_NUMBER; i++) {
    float x = random(width);
    float y = random(height);

    points[i] = new Point(x, y);
  }

  float maxDistance = 300;

  for(int t = 0; t < 20; t++) {
    // 旋转规则
    for(int i = 0; i < points.length; i++) {
      int index = (i + 1) % points.length;
      points[i].rotate(points[index], 0.01);
    }
    // 距离规则
    for(int i = 0; i < points.length; i++) {
      Point a = points[i];
      for(int j = i + 1; j < points.length; j++) {
        Point b = points[j];
        float d = b.distance(a);
        if(d < maxDistance) {
          float alpha = map(d, 0, maxDistance, 255,  0);
          float weight = map(d, 0, maxDistance, 2, 0);

          stroke(0, alpha);
          strokeWeight(weight);
          line(a.x, a.y, b.x, b.y);
        }
      }
    }
  }
}