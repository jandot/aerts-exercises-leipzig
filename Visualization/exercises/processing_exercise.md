# Hands-on exercise data visualization {.unnumbered}
Author - Jan Aerts, Data Visualization Lab, KU Leuven - http://datavislab.org

In this exercise, we will use the Processing tool ([http://processing.org](http://processing.org)) to generate visualizations based on a flights dataset. This tutorial holds numerous code snippets that can by copy/pasted and modified for your own purpose.

![flights](images/flights_double.png)

# Introduction to Processing
Processing is a language based on java, with its own development environment. Although it is basically java, much of the boilerplate code is not necessary. It therefore becomes a language accessible to people with little or no programming background.

![Processing IDE](images/Processing-1_2_1.png)

## Download and install Processing
Processing can be downloaded from [http://processing.org/download/](http://processing.org/download/). Download it into your **C:\\workdir** folder. (It will **not** work if it is downloaded to your desktop.)

## A minimal script
A minimal script is provided below.

*Script 1*
```java
[1]  size(400,400);
[2]  
[3]  fill(255,0,0);
[4]  ellipse(100,150,20,20);
[5]  
[6]  fill(0,255,0);
[7]  rect(200,200,50,60);
[8]  
[9]  stroke(0,0,255);
[10] strokeWeight(5);
[11] line(150,5,150,50);
```
This code generates the following image:

![minimal output](images/minimal_output.png)

The numbers at the front of each line are the *line numbers* and are actually not part of the program. We've added them here to be able to refer to specific lines. So if you type in this piece of code, *do not type the line numbers*.

Let's walk through each line. The script is made up of a list of **statements**. The first line in the script `size(400,400);` sets the **dimensions of the resulting image**. In this case, we'll generate a picture of 400x400 pixels.
Next, (line `[3]`) we set the **colour** of anything we draw to red. The `fill` function takes 3 parameters, which are the values for red, green, and blue (RGB), ranging from 0 to 255. We then draw an **ellipse** with its center at horizontal position 100 pixels and vertical position 150 pixels. Note that the vertical position counts from the top down instead of from the bottom up. The **point `(0,0)` is at the top left** rather than the bottom left... For the ellipse we set both the horizontal and vertical diameter to 20 pixels, which results in a circle.
The next thing we do (line `[6]`) is set the colour of anything that we will draw to green `fill(0,255,0);`, and draw a **rectangle** at position `(200,200)` with width set to 50 and height to 60.

Finally, we set the colour of lines to blue (`stroke(0,0,255);`), the stroke weight to 5 pixels `strokeWeight(5);`, and draw a **line** `line(150,5,150,50);`. This line runs from point `(150,5)` to `(150,50)`.

Both `fill` and `stroke` are used to set colour: `fill` to set the colour of the shape, `stroke` to set the colour of the border around that shape. In case of *lines*, only the `stroke` colour can be set.

Several drawing primitives exist, including `line`, `rect`, `triangle`, and `ellipse` (a circle is an ellipse with the same horizontal and vertical radius). A treasure trove of information for these is available in the [Processing reference pages](http://processing.org/reference/).

Apart from these primitives, Processing contains functions that modify properties of these primitives. These include setting the fill color (`fill`), color of lines (`stroke`), and line weight (`lineWeight`). Again, the reference pages host all information.

## Variables, loops and conditionals
What if we want to do something multiple times? Suppose we want to draw 10 lines underneath each other. We could do that like this:

*Script 2*
```java
[1]  size(500,150);
[2]  background(255,255,255);
[3]  line(100,0,400,0);
[4]  line(100,10,400,10);
[5]  line(100,20,400,20);
[6]  line(100,30,400,30);
[7]  line(100,40,400,40);
[8]  line(100,50,400,50);
[9]  line(100,60,400,60);
[10] line(100,70,400,70);
[11] line(100,80,400,80);
[12] line(100,90,400,90);
```
This generates this image:

![lines](images/loop.png)

Of course this is not ideal: what if we have 5,000 datapoints to plot? To handle real data, we will need variables, loops, and conditionals.

In the code block above, we can replace the hard-coded numbers with **variables**. These can be integers, floats, strings, arrays, etc. To declare an integer variable, we have to prefix it with `int`. The statement `int startX = 100;` below therefore means "create an integer called startX, and give it the value of 100".

*Script 3*
```java
[1] size(500,150);
[2] int startX = 100;
[3] int stopX = 400;
[4] background(255,255,255);
[5] for ( int i = 0; i < 10; i++ ) {
[6]   line(100,i*10,400,i*10);
[7] }
```
A loop looks like this:
```java
for ( int i = 0; i < 10; i++ ) {
	// do something
}
```

We first set the variables `startX` and `stopX` to `100` and `400`. We then **loop** over values `i`, which starts at `0` and increases in each loop as long as it is smaller than `10`. In each loop, a `line` is drawn. 

We can use **conditionals** to for example distinguish odd or even lines by colour.
*Script 4*
```java
[1]  size(500,150);
[2]  int startX = 100;
[3]  int stopX = 400;
[4]  background(255,255,255);
[5]  strokeWeight(2);
[6]  for ( int i = 0; i < 10; i++ ) {
[7]    if ( i%2 == 0 ) {
[8]      stroke(255,0,0);
[9]    } else {
[10]     stroke(0,0,255);
[11]   }
[12]   line(startX,i*10,stopX,i*10);
[13] }
```
In this code snippet, we check in each loop if `i` is even or odd, and let the stroke colour depend on that result. An `if`-clause has the following form:
```java
if ( *condition* ) {
	// do something
} else {
	// do something else
}
```
The condition `i%2 == 0` means: does dividing the number `i` with 2 result in a remainder of zero? Note that we have to use 2 equal-signs here (`==`) instead of just one (`=`). This is so to distinguish between a test for equality, and an assignment. Don't make errors against this...

![oddeven](images/oddeven.png)

## Exercise data
The data for this exercise concerns **flight information** between different cities. Each entry in the dataset contains the following fields:

* from_airport
* from_city
* from_country
* from_long
* from_lat
* to_airport
* to_city
* to_country
* to_long
* to_lat
* airline
* airline_country
* distance

### Getting the data
In the directory **xyz**, create a new folder called `data`. Download the file [**http://bitbucket.org/jandot/flamesworkshop/downloads/flights.csv**](http://bitbucket.org/jandot/flamesworkshop/downloads/flights.csv) into this new folder.

### Accessing the data from Processing
Let's write a small script in Processing to visualize this data. The **visual encoding** that we'll use for each flight will be the following:

* x position is defined by longitude of departure airport
* y position is defined by latitude of departure airport

*Script 5*
```java
[1]  Table table = loadTable("flights.csv","header");
[2]  
[3]  size(800,800);
[4]  noStroke();
[5]  fill(255,0,0,10); // colour = red; transparency = 10%
[6]  
[7]  background(255,255,255); // set background to white
[8]  for ( TableRow row : table.rows() ) {
[9]      float from_long = row.getFloat("from_long");
[10]     float from_lat = row.getFloat("from_lat");
[11]     float x = map(from_long,-180,180,0,width);
[12]     float y = map(from_lat,-180,180,height,0);
[13]     ellipse(x,y,3,3);
[14] }
```

The resulting image:

![scatterplot](images/flights_map.png)

You can see that the resulting image shows a map of the world, with areas with high airport density clearly visible. Notice that the data itself does not contain any information where the continents, oceans and coasts are; still, these are clearly visible in the image.

Let's go through the code:

* [1] The data from the file "flights.csv" is read into a variable `table` which is of type `Table`. The `"header"` indicates that the first line of the file is a list of column headers.
* [8] This is another way to loop over a collection, instead of the `for ( int i = 0; i < 10; i++ ) { }` we used before. In this line, we loop over all `table.rows()`, and each time we put the new row into a variable `row`.
* [9] `row.getFloat("from_long")` extracts the value from the `from_long` column from that row and makes it a `float`. This is then stored in the variable `from_long`.
* [11] In this line, we transform the longitude value to a value between 0 and the width of our canvas.

The `map` function is very useful. It is used to **rescale** values. In our case, longitude values range from `-180` to `180`. The `x` position of the dots on the screen, however, have to be between 0 and 800 (because that's the width of our canvas, as set in `canvase(800,800);`). In this case, we can even use the variable `width` instead of `800`, because `width` and `height` are set automatically when we call the statement `size(800,800);`.
You see that the `map` function for `y` recalculates the `from_lat` value to something between `height` and `0`, instead of between `0` and `height`. The reason is that the *origin* of our canvas is at the top-left corner instead of the bottom-left one so we have to flip coordinates.

We can add additional information to this visualization. In the next code block, we alter our script so that colour of the dots is red for domestic flights and blue for international flights. In addition, the size of the dots is proportional to the distance of that particular flight.

*Script 6*
```java
[1]  Table table = loadTable("flights.csv","header");
[2]  
[3]  size(800,800);
[4]  noStroke();
[5]  
[6]  background(255,255,255); // set background to white
[7]  for ( TableRow row : table.rows() ) {
[8]      float from_long = row.getFloat("from_long");
[9]      float from_lat = row.getFloat("from_lat");
[10]     String from_country = row.getString("from_country");
[11]     String to_country = row.getString("to_country");
[12]     int distance = row.getInt("distance");
[13]     
[14]     float x = map(from_long,-180,180,0,width);
[15]     float y = map(from_lat,-180,180,height,0);
[16]     if ( from_country.equals(to_country) ) {
[17]       fill(255,0,0,10);
[18]     } else {
[19]       fill(0,0,255,10);
[20]     }
[21]     float r = map(distance, 1, 15406, 3, 15);
[22]     
[24]     ellipse(x,y,r,r);
[25] }
```

In line [21], we rescale the value of the distance (min = 1, max = 15406) to a minimum of 3 and maximum of 15. That value is than used as the radius `r`.

![flights_coloured](images/flights_coloured.png)

From this picture, we can deduce many things:

* Airports tend to be located on land => plotting latitude and longitude recreates a worldmap.
* Blue international flights tend to depart from coastal regions.
* There are few domestic flights within Europe.
* Longer flights (departure airports with larger radius) tend to leave in coastal regions

### Interactivity
It is often the interactivity in data visualization that helps gaining insights in that data and finding new hypotheses. Up until now, we have generated static images. How can we add interactivity?

As a first use case, say that we want the radius of the dots to depend on the position of the mouse instead of the distance of the flight: if our mouse is at the left of the image, all dots should be small; if it is at the right, they should be large. We will change the line `float r = map(distance,1,15406,3,15);` to include information on the mouse position.

This time, instead of creating a simple image, this image will have to be **redrawn** constantly taking into account the mouse position. For this, we have to rearrange our code a little bit. Some of the code has to run only once to initialize the visualization, while the rest of the code has to be rerun constantly. We do this by putting the code that we have either in the `setup()` or the `draw()` function:
```java
[1] // define global variables here
[2] void setup() {
[3] 	// code that has to be run only once
[4] }
[5] void draw() {
[6] 	// code that has to be rerun constantly
[7] }
```

The `setup()` function is only run once; the `draw()` function is run by default 60 times per second.

Let's put all statements we had before into one of these two functions:

*Script 7*
```java
[1]  Table table;
[2]  
[3]  void setup() {
[4]    size(800,800);
[5]    table = loadTable("flights.csv","header");
[6]    noStroke();
[7]  }
[8]  
[9]  void draw() {
[10]   background(255,255,255); // set background to white
[11]   for ( TableRow row : table.rows() ) {
[12]     float from_long = row.getFloat("from_long");
[13]     float from_lat = row.getFloat("from_lat");
[14]     String from_country = row.getString("from_country");
[15]     String to_country = row.getString("to_country");
[16]     int distance = row.getInt("distance");
[17]     
[18]     float x = map(from_long,-180,180,10,width-10);
[19]     float y = map(from_lat,-180,180,height-10,10);
[20]     if ( from_country.equals(to_country) ) {
[21]       fill(255,0,0,10);
[22]     } else {
[23]       fill(0,0,255,10);
[24]     }
[25]     float r = map(distance, 0, 15406, 3, 15);
[26]     
[27]     ellipse(x,y,r,r);
[28]   }
[29] }
```

The `draw()` function is run 60 times per second. This means that 60 times per second each line in the input table is processed again to draw a new circle. As this is quite compute intensive, your computer might actually not be able to redraw 60 times per second, and show some lagging. For simplicity's sake, we will however not go into optimization here.

Some things to note:

* We have to define the `table` variable at the top.
* We have to set the background every single redraw. If we wouldn't, each picture is drawn on top of the previous one.

Now how do we adapt this so that the radius of the circles depends on the x-position of my pointer? Luckily, Processing provides two variables called `mouseX` and `mouseY` that are very useful. `mouseX` returns the x position of the pointer. So basically the only thing we have to do is replace `float r = map(distance, 0, 15406, 3, 15);` with `float r = map(mouseX, 0, 800, 3, 15);` (Note that we changed the `15406` to `800`.) If we do that, and our mouse is towards the right side of the image, we get the following picture:

![scatterplot_largedots](images/scatterplot_largedots.png)

**Some optimization**
Let's optimize this code a tiny bit. We could for example remove the lines that handle the `distance` because we don't use them. However, we'll leave those in because we'll use them in the next example...
Something else that we can do is **limit the number of times the picture is redrawn**. As long as I don't move my mouse I don't have to redraw the picture. To do that, we add `noLoop();` to the `setup()` function, and add a new function at the bottom, called `mouseMoved()`. In this new function, we tell Processing to `redraw()` the canvas. The resulting code looks like this:

*Script 8*
```java
[1]  Table table;
[2]  
[3]   void setup() {
[4]   size(800,800);
[5]    table = loadTable("flights.csv","header");
[6]    noLoop();
[7]    noStroke();
[8]  }
[9]  
[10] void draw() {
[11]   background(255,255,255); // set background to white
[12]   for ( TableRow row : table.rows() ) {
[13]     float from_long = row.getFloat("from_long");
[14]     float from_lat = row.getFloat("from_lat");
[15]     String from_country = row.getString("from_country");
[16]     String to_country = row.getString("to_country");
[17]     int distance = row.getInt("distance");
[18]     
[19]     float x = map(from_long,-180,180,10,width-10);
[20]     float y = map(from_lat,-180,180,height-10,10);
[21]     if ( from_country.equals(to_country) ) {
[22]       fill(255,0,0,10);
[23]     } else {
[24]       fill(0,0,255,10);
[25]     }
[26]     float r = map(mouseX, 0, 800, 3, 15);
[27]     
[28]     ellipse(x,y,r,r);
[29]   }
[30] }
[31] 
[32] void mouseMoved() {
[33]   redraw();  
[34] }
```

**More useful interactivity**
This interactivity can be made more useful: we can use the mouse pointer as a **filter**. For example: *if our mouse is at the left only short distance flights are drawn; if our mouse is at the right only long distance flights are drawn*.

*Script 9*
```java
[1] Table table;
[2] 
[3] void setup() {
[4]   size(800,800);
[5]   table = loadTable("flights.csv","header");
[6]   noLoop();
[7]   noStroke();
[8] }
[9] 
[10] void draw() {
[11]   background(255,255,255); // set background to white
[12]   for ( TableRow row : table.rows() ) {
[13]     int distance = row.getInt("distance");
[14]     float mouseXMin = mouseX - 25;
[15]     float mouseXMax = mouseX + 25;
[16]     float minDistance = map(mouseXMin, 0, 800, 0, 15406);
[17]     float maxDistance = map(mouseXMax, 0, 800, 0, 15406);
[18] 
[19]     if ( minDistance < distance && distance < maxDistance ) {
[20]       float from_long = row.getFloat("from_long");
[21]       float from_lat = row.getFloat("from_lat");
[22]       String from_country = row.getString("from_country");
[23]       String to_country = row.getString("to_country");
[24]   
[25]       float x = map(from_long,-180,180,10,width-10);
[26]       float y = map(from_lat,-180,180,height-10,10);
[27]       if ( from_country.equals(to_country) ) {
[28]         fill(255,0,0,10);
[29]       } else {
[30]         fill(0,0,255,10);
[31]       }
[32]       ellipse(x,y,3,3);
[33]     }
[34]   }
[35] }
[36] 
[37] void mouseMoved() {
[38]   redraw();  
[39] }
```
We will only draw flights if their duration is between a calculated `minDistance` and `maxDistance`. That's what we do on line [19]: the `&&` indicates `and`. Of course we first have to calculate `minDistance` and `maxDistance`. That's what we do on lines [14] to [17]. In lines [14] and [15], we say that we will be looking 25 pixels at either side of the mouse position. If the pointer is at position 175, `mouseMin` is set to 150 and `mouseMax` to 200. This pixelrange is then translated into distance range on lines [16] and [17].

Now it gets interesting. We can now look a bit deeper into the data... If we have our mouse at the left side of the image, it looks like this:

![short_distances](images/flights_shortdistances.png)

Having the mouse in the middle to the canvas gives us this image:

![medium_distances](images/flights_mediumdistances.png)

Playing with this visualization, there are some signals that pop up. Moving left and right at about 70-90 pixels from the left, we see a "snake" moving along the north-east coast of Brazil (see Figure below, also indicating position of mouse). This indicates that most of these flights probably go to the same major city in that country. Other dynamic patterns appear in Europe as well.

![snake_brazil](images/snake_brazil.png)

**Buttons and sliders**
Of course many tools have buttons and sliders. Let's implement those in Processing. Instead of using the mouse position as a filter as before, why don't we make a slider to do the same? Unfortunately, this is a bit more complex that it should be... So let's first start with a **button**. To create a button, what we basically do is draw a rectangle, and check if the mouse position is within the area of that rectangle when we press the mouse button.

*Script 10*
```java
[1] Table table;
[2] boolean grey;
[3] 
[4] void setup() {
[5]   size(800,800);
[6]   table = loadTable("flights.csv","header");
[7]   grey = true;
[8]   noLoop();
[9]   noStroke();
[10] }
[11]
[12] void draw() {
[13]   background(255,255,255); // set background to white
[14]   fill(100,100,100);
[15]   rect(50,100,20,20);
[16]   for ( TableRow row : table.rows() ) {
[17]     int distance = row.getInt("distance");
[18]     float mouseXMin = mouseX - 25;
[19]     float mouseXMax = mouseX + 25;
[20]     float minDistance = map(mouseXMin, 0, 800, 0, 15406);
[21]     float maxDistance = map(mouseXMax, 0, 800, 0, 15406);
[22]
[23]     if ( minDistance < distance && distance < maxDistance ) {
[24]       float from_long = row.getFloat("from_long");
[25]       float from_lat = row.getFloat("from_lat");
[26]       String from_country = row.getString("from_country");
[27]       String to_country = row.getString("to_country");
[28]   
[29]       float x = map(from_long,-180,180,10,width-10);
[30]       float y = map(from_lat,-180,180,height-10,10);
[31]       
[32]       if ( grey == true ) {
[33]         fill(100,100,100,10);
[34]       } else {
[35]         if ( from_country.equals(to_country) ) {
[36]           fill(255,0,0,10);
[37]         } else {
[38]           fill(0,0,255,10);
[39]         }
[40]       }
[41]       ellipse(x,y,3,3);
[42]     }
[43]   }
[44] }
[45] 
[46] void mouseClicked() {
[47]   if ( mouseX > 50 && mouseX < 70 &&
[48]        mouseY > 100 && mouseY < 120 ) {
[49]     if ( grey == true ) {
[50]       grey = false;
[51]     } else {
[52]       grey = true;
[53]     }
[54]     redraw();
[55]   }
[56] }
[57] 
[58] void mouseMoved() {
[59]   redraw();  
[60] }
```

Now, we basically keep track of a variable called `grey` which can be `true` or `false` (such variable is called a "boolean"). If it is `true` then all points will be drawn in grey; if it is `false` then the points will be blue or red just like before.

We define the boolean `grey` at the top (line [2]) and gave it a value of `true` in the setup (line [7]). Then, we draw a little square (line [15]) just so that we have something to point at. Next, we change the line [27-31] from script 9 into line [32-40] in script 10. This first checks if the boolean `grey` is set to true, and sets the fill colour based on that information. Finally, we create a new method called `mouseClicked` (line [46-56]) to handle the actual click event itself. This method (which really must be called "mouseClicked") will be run every time you click the mouse. If you do so, it will check if the position of the mouse is within the range of the rectangle that we drew in the beginning. If it is, it changes the value of `grey` and redraws the map. See the reference guide on the Processing.org website for more information on `mouseClicked()`.

*Note that there is basically no connection between the rectangle we draw at line [15] and the actual click event: we have to check if our mouse is over the rectangle ourselves; we're not able to say "if this rectangle is clicked". We could just as well remove line [15] (so that we don't see a rectangle) and the visualization would still work exactly the same. The only problem would be that you wouldn't know where the region that we define in lines [47-48] actually is...*

Now let's implement an actual **slider**. This looks a lot like what we had before in script 9, but we obviously have to change some things. Let's start with the final script, which was adapted from script 9:

*Script 11*
```java
[1] Table table;
[2] float circlePosition;
[3] 
[4] void setup() {
[5]   size(800,800);
[6]   table = loadTable("flights.csv","header");
[7]   noLoop();
[8]   circlePosition = 50;
[9] }
[10] 
[11] void draw() {
[12]   background(255,255,255); // set background to white
[13]   stroke(150,150,150);
[14]   line(50,150,150,150); // draw the line of 100 pixels long
[15]   noStroke();
[16]   fill(150,150,150);
[17]   ellipse(circlePosition,150,10,10);
[18]   
[19]   for ( TableRow row : table.rows() ) {
[20]     int distance = row.getInt("distance");
[21]     float circleXMin = circlePosition - 2;
[22]     float circleXMax = circlePosition + 2;
[23]     float minDistance = map(circleXMin, 50, 150, 0, 15406);
[24]     float maxDistance = map(circleXMax, 50, 150, 0, 15406);
[25] 
[26]     if ( minDistance < distance && distance < maxDistance ) {
[27]       float from_long = row.getFloat("from_long");
[28]       float from_lat = row.getFloat("from_lat");
[29]       String from_country = row.getString("from_country");
[30]       String to_country = row.getString("to_country");
[31] 
[32]       float x = map(from_long,-180,180,10,width-10);
[33]       float y = map(from_lat,-180,180,height-10,10);
[34]       
[35]       if ( from_country.equals(to_country) ) {
[36]         fill(255,0,0,10);
[37]       } else {
[38]         fill(0,0,255,10);
[39]       }
[40]       ellipse(x,y,3,3);
[41]     }
[42]   }
[43] }
[44] 
[45] void mouseDragged() {
[46]   if ( abs(mouseX - circlePosition) <= 5 &&
[47]        abs(mouseY - 150) <= 5 &&
[48]        mouseX >= 50 && mouseX <= 150 ) {
[49]     circlePosition = mouseX;
[50]   }
[51]   redraw();
[52] }
```

![slider](images/slider.png)

So what changed? We now define a variable (a float) called `circlePosition` at the top and set its initial value to 50 on line [8]. At the start of the `draw()` function [13-17], we also draw a line that will serve as a guide as well as the actual circle. Furthermore, we change lines [21-24] to refer to the `circlePosition` instead of `mouseX`. Note that that includes using +/- 2 instead of +/- 25 as a buffer, and using the minimum and maximum values of the line (i.e. 50 and 150) instead of those of the mouse in the map functions. Finally, we write the `mouseDragged()` function at the bottom (lines [45-52]). A "mouse-drag" in Processing-speak means: pressing the mouse button, then moving the mouse to another position, and finally releasing the mouse button. The `mouseDragged()` function looks a lot like the `mouseClicked()` function in script 10. We want to make sure that when we are on top of the circle when we start dragging (both horizontally [46] and vertically [47]). Also, we need to make sure that we cannot drag the circle further than the minimum or maximum value [48]. If the situation complies to these three conditions, we change the `circlePosition` to `mouseX`, which basically means that the circle follows the mouse. Don't forget the `redraw()` or the scene will not be updated. Question: what happens if you drag the mouse too fast? Why is that? And just for laughs: remove the conditions on line [48] and see what happens if you start interacting with the visualization...


# Whereto from here?

There are many different ways to show this information. This exact same dataset was visualized by Till Nagel during the visualization challenge in 2012 from visualising.org. Part of his entry is shown in Figure 13.

![Entry by Till Nagel](images/till_nagel.png)

Till focused on domestic flights, and wanted to show how many of these are served by domestic airlines or by foreign airlines.

Also have a look at Aaron Koblin's visualization of flight patterns at http://www.aaronkoblin.com/work/flightpatterns/.

## Exercise

* Alter the script to map other data attributes to these visuals. Can you find new insights?
* What other ways of visualizing this data could you think of?