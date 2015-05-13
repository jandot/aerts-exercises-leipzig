Table table = loadTable("expression_data.csv","header");

size(900,800);
background(255,255,255); // set background to white

stroke(0,0,0,50);
noFill();
line(100,100,100,700);
line(200,100,200,700);
line(300,100,300,700);
line(400,100,400,700);
line(500,100,500,700);
line(600,100,600,700);
line(700,100,700,700);
line(800,100,800,700);

stroke(0,0,0,5);
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
  
  stroke(255,0,0,50);
  if ( (human1+human2+human3+human4)/(chimp1+chimp2+chimp3+chimp4) > 2 ) {
    line(100, 100+(human1*30), 200, 100+(human2*30));
    line(200, 100+(human2*30), 300, 100+(human3*30));
    line(300, 100+(human3*30), 400, 100+(human4*30));
    line(400, 100+(human4*30), 500, 100+(chimp1*30));
    line(500, 100+(chimp1*30), 600, 100+(chimp2*30));
    line(600, 100+(chimp2*30), 700, 100+(chimp3*30));
    line(700, 100+(chimp3*30), 800, 100+(chimp4*30));
  }
  stroke(0,0,255,50);
  if ( (human1+human2+human3+human4)/(chimp1+chimp2+chimp3+chimp4) < 0.5 ) {
    line(100, 100+(human1*30), 200, 100+(human2*30));
    line(200, 100+(human2*30), 300, 100+(human3*30));
    line(300, 100+(human3*30), 400, 100+(human4*30));
    line(400, 100+(human4*30), 500, 100+(chimp1*30));
    line(500, 100+(chimp1*30), 600, 100+(chimp2*30));
    line(600, 100+(chimp2*30), 700, 100+(chimp3*30));
    line(700, 100+(chimp3*30), 800, 100+(chimp4*30));
  }

}
