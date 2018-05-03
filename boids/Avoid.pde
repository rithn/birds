class Avoid {
   PVector pos;
   
   Avoid (float xx, float yy, float zz) {
     pos = new PVector(xx,yy,zz);
   }
   
   void go () {
     
   }
   
   void draw () {
     stroke(0);
     rect(pos.x, pos.y, 0.5, 0.5);
   }
}
