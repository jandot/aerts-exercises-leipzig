Table table = loadTable("expression_data.csv","header");

size(800,800);
background(255,255,255); // set background to white

stroke(0,0,0,50);
noFill();
ellipse(400,400,50,50);
ellipse(400,400,150,150);
ellipse(400,400,250,250);
ellipse(400,400,350,350);
ellipse(400,400,450,450);
ellipse(400,400,550,550);
ellipse(400,400,650,650);

noStroke();
fill(0,0,0);
ellipse(100,100,10,10);
ellipse(700,100,10,10);
ellipse(100,700,10,10);
ellipse(700,700,10,10);
textSize(32);
text("1",120,120);
text("2",720,120);
text("3",120,720);
text("4",720,720);

fill(0,0,255,20);
for ( TableRow row : table.rows() ) {
  String probeset = row.getString("probeset");
  float human1 = row.getFloat("human1");
  float human2 = row.getFloat("human2");
  float human3 = row.getFloat("human3");
  float human4 = row.getFloat("human4");
  float chimp1 = row.getFloat("chimp1");
  float chimp2 = row.getFloat("chimp2");
  float chimp3 = row.getFloat("chimp3");
  float chimp4 = row.getFloat("chimp4");
  
//  float x = (human2+human4)-(human1+human3);
//  float y = (human3+human4)-(human1+human2); 
  float x = (chimp2+chimp4)-(chimp1+chimp3);
  float y = (chimp3+chimp4)-(chimp1+chimp2); 
  ellipse(400+(x*20), 400+(y*20), 5, 5);
}
