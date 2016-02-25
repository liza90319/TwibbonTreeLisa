/* //<>//
Starry nightsky poetic interaction for Breast Cancer Awareness survivors
 Author: Biqing Li
 */


import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

Twitter twitterInstance;
Query queryForTwitter;

String searchString[] = {
  "#breastcancer", 
  "#breastcancerawareness", "#RIP"};


List<Status> tweets;

int yPos = 0;
int xPos = 0;


//Build an ArrayList to hold all of the words that we get from the imported tweets
ArrayList<String> words = new ArrayList();

//Build an Arraylist to hold all of the tweet messages we get from Twitter
ArrayList<String> modifiedtweets = new ArrayList();

//Build an Arraylist to hold all of the image URLs we get from Twitter
ArrayList<String> URL = new ArrayList();
ArrayList<PImage> ProfileImages = new ArrayList();

// create the arrays to hold our word lists
List<String> diagnosis, treatment, recovery, wordsofinspiration;

String urlPattern = "https?.*?( |$)"; //should find all URLs (unless someone posts a URL starting in ftp:// or some other, far less common protocol)
String handlePattern = "@.*?( |$)"; //looks for A-Z, a-z, 0-9, or _ in any combination between 1 and 15 characters long, following an @
String hashtagPattern = "#.*?( |$)"; //looks for any characters following a # sign, and ending in a space or the end of the tweet




String rawTweet[];
String modifiedTweet ="";

int currentTweet;
int mouseClick = 0;

float bx;
float by;
float boxSize =75;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0;
float yOffset = 0.0;

int mouseRelease = 1;

PImage treeBranch;
PImage ribbon;
PImage webImg;
PImage PinkCursor;

//DIMMING THE BACKGROUND
float numOfFrame;
boolean dimming = true;

PFont font1, font2, font3, defaultFont;

//constants
int Y_AXIS = 1;
int X_AXIS = 2;

float r=255;
float g=205;
float b=229;

int numOfWords;


//DECLARE
ShootingStar myShootingStar;

// the twinlking star locations
int[] starX = new int[200];
int[] starY = new int[200];

//Create strings for text
String[] inspirationalWords;
float[] wordTransparency;


//println(numOfWords);
int[] wordX;
int[] wordY;

int[] ribbonX=new int[150];
int[] ribbonY=new int[150];
int[] ribbonSize = new int[150];

float[] ribbonTransparency;

//ADJUST RIBBON SIZE AND PLACEMENTS HERE
int ribbonXMin=150;
int ribbonXMax=850;
int ribbonYMin=50;
int ribbonYMax=500;
int ribbonSizeMin=10;
int ribbonSizeMax=30;


boolean[] wordVisibility;
int overlapValue = 20;

color[] starColor = new color[1000];
int starSize = 5; // the size of the stars

// the tail of the shooting star
int[] shootX = new int[30];
int[] shootY = new int[30];
int METEOR_SIZE = 8; // initial size when it first appears
float meteorSize = METEOR_SIZE; // size as it fades

// distance a shooting star moves each frame - varies with each new shooting star
float ssDeltaX, ssDeltaY;
// -1 indicates no shooting star, this is used to fade out the star
int ssTimer = -1;
// starting point of a new shooting star, picked randomly
int startX, startY;

PFont RibbonFont;

void setup() {
  size(1000, 800);
  noCursor();
  numOfFrame = 0;
  
  //TREE BRANCH
  treeBranch=loadImage("treeoflife.png");
  ribbon=loadImage("ribbon.png");
  //Pink Cursor
  PinkCursor=loadImage("pink_cursor.png");
  
  //FONT
  font1 = createFont("anotherBrushPen.ttf",80);
  font2 = createFont("PrintClearly.otf",25); 
  font3 = createFont("PrintDashed.otf",100);
  defaultFont = createFont("OpenSans-Bold.ttf",20);
  
  
  
  //textFont(font1);
        //println(URL);
        // webImg = loadImage(URL[k], "png");
        //image(webImg,starX[k],starY[k]);
        //ellipse(starX[k], starY[k], 10, 10); //drawing circle where text should be
   //text("test this tweet", 500,400,200,500);
  

  //SET UP RIBBON BOX
  bx = width/2.0;
  by = height/4.0;
  rectMode(RADIUS);

  //CONFIGURATE TWITTER
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("SSLkyRqHSnQr7i88dp1oDk5FN");
  cb.setOAuthConsumerSecret("Woa1Yjx116bb6Qwdn20wmhpmdHpmxcBwD60bKlq7QMVDIsL93n");
  cb.setOAuthAccessToken("480462489-u1LZwX7mCdEpDgIHnFHg7XwA5CndcpZSrPqhzN7F");
  cb.setOAuthAccessTokenSecret("X63iEo292Soc3ZDFvD701zlWqzLoyHdqRwMzInZhbg7kS");

  twitterInstance = new TwitterFactory(cb.build()
    ).getInstance();

  queryForTwitter = new Query("#breastcancer -RT");
  queryForTwitter.setCount(150);

  FetchAndDrawTweets();

  //get words from lists
  inspirationalWords = loadStrings("wordsofinspiration.txt");
  numOfWords = inspirationalWords.length;
  wordX = new int[numOfWords];
  wordY = new int[numOfWords];
  
  //println(numOfWords);

  //assign array size as numOfWords 
  wordVisibility=new boolean[numOfWords];

  //initialize wordTransparency
  wordTransparency = new float[numOfWords];

  //INITIALIZE Shooting Star
  myShootingStar = new ShootingStar();
  currentTweet = 0;

    
 for (int i = 0; i < ribbonX.length; i++) {
   //ribbonXMin, ribbonXMax, ribbonYMin, ribbonYMax, ribbonSizeMin, ribbonSizeMax
 
   ribbonX[i] = (int)random(ribbonXMin,ribbonXMax);
   ribbonY[i] = (int)random(ribbonYMin,ribbonYMax);
   ribbonSize[i] = (int)random(ribbonSizeMin,ribbonSizeMax);
  }
 
 //Create profile URL locations
 //String URL[] = new String[100];
 
 
  // create the star locations
  for (int i = 0; i < starX.length; i++) {
    starX[i] =(int)random(width);
    starY[i] = (int)random(height);
    starColor[i] = color((int)random(200, 255));
  }
  print("star locations generated");
  //create ribbon placement locations

  // create the word locationss
  for (int i = 0; i < wordX.length; i++) {
    wordX[i] =(int)random(100,800);
    wordY[i] = (int)random(100,600);
    wordVisibility[i] = false;

    for (int overlap=0; overlap < i; overlap++) {
      int oldPos = wordY[overlap];
      int newPos = wordY[i];
      if ((newPos > oldPos-overlapValue) && (newPos < oldPos+overlapValue)) {
        //println("Found overlap!");
        wordY[i] += overlapValue;
      }
    }
  }
}



void draw() {

  if(dimming){
    numOfFrame+=5;
  }
  else{
    numOfFrame-=6;
    if(numOfFrame<0){
      numOfFrame = 0;
      dimming=true;
    }
  }
  
 DrawStarwithTweets();
  
  
  //CALL FUNCTIONALITY
  myShootingStar.run();
  
  
  //Place tree on canvas
  tint(255,200);
  image(treeBranch,0,0);
  tint(255);
 
  
  //PLACE RIBBON ON TREE
   MousePress();
 
  //MAKE CURSOR FOLLOW MOUSE
  image(PinkCursor,mouseX,mouseY);
  
  //TEST IF CURSOR IS OVER THE BOX
  /*if (mouseX > bx-boxSize && mouseX < bx+boxSize && 
      mouseY > by-boxSize && mouseY < by+boxSize) {
    overBox = true;  
    if(!locked) { 
      stroke(255); 
      fill(153);
      } 
    } else {
      stroke(153);
      fill(153);
      overBox = false;
    }
    
    // Draw the box
    image(ribbon,boxSize,boxSize*1.5); 
    */
    // rect(bx, by, boxSize, boxSize);
  }



void FetchAndDrawTweets() {
  try
  {
    QueryResult result = twitterInstance.search(queryForTwitter);
    //QueryResult result2 = twitter.search(hashtag);

    ArrayList tweets = (ArrayList) result.getTweets();
    currentTweet = currentTweet +1;

    if (currentTweet >= tweets.size()) {
      currentTweet = 0;
    }
    // draw the stars

    for (int i= 0; i<tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
     
      
      //URL=indURL;
      //INITIALIZE
      User user = t.getUser();
      //String URL[i] = t.getBiggerProfileImageURL();
      //print(URL[i]);
      //URL.get(i)=user.getMiniProfileImageURL();
      String temp = user.getProfileImageURL();
      ProfileImages.add(loadImage(temp,"png"));
      URL.add(temp);
      print(URL);
      
      //image(ProfileImages.get(i),10*i,10*i);
  


      //int followerCount = user.getFollowersCount();
      //println(user.getFollowersCount());
      String msg = t.getText();


      modifiedTweet=msg.replaceAll(urlPattern, "");
      modifiedTweet=modifiedTweet.replaceAll(handlePattern, "survivor");
      modifiedTweet=modifiedTweet.replaceAll("#breastcancer", "breast cancer");
      modifiedTweet=modifiedTweet.replaceAll("#", " ");
      
      modifiedtweets.add(modifiedTweet);
      
      //println("modifiedtweets.size"+" " +modifiedtweets.size());

      fill(255, 0, 0);
      //println("modifiedTweet :"+modifiedTweet);
      //ellipse(i*random(width), i*random(height), starSize, starSize);        
      //println(URL);
      //println("draw tweets finished");
    }//for loop
  }
  catch (TwitterException te)
  {
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }
}


void DrawStarwithTweets() {
  noStroke();
  strokeWeight(1);    

  //r = 51;
  //g = 0;
  //b = 25;
  
  color b1 = color(250, 100, 138);
  color b2 = color(0, 0, 0);

  setGradient(0, 0, width, height+numOfFrame, b2, b1, Y_AXIS);

 
  for (int j = 0; j < starX.length; j++) {
   
    fill(random(50, 255)); // makes them twinkle
    if (random(10) < 1) {
      starColor[j] = (int)random(200, 255);
    }
    fill(starColor[j]);
    ellipse(starX[j], starY[j], starSize*random(1, 1.5), starSize*random(1, 1.5));
    
    //if hover over a star, do the following
    for (int k=0; k<starX.length-1; k++) {
      if (dist(mouseX, mouseY, starX[k], starY[k]) < starSize*2) {
        dimming=false;
        String tweetText;
        if (k<modifiedtweets.size()) {
          tweetText=modifiedtweets.get(k);
          
        } else {
          tweetText=modifiedtweets.get(k%modifiedtweets.size()); 
         
        }
        fill(214,181,196,255);
        textLeading(1);
        tint(255);
        textFont(font2);
        //println(URL);
        //webImg = loadImage(URL[k], "png");
        //image(webImg,starX[k],starY[k]);
        //ellipse(starX[k], starY[k], 10, 10); //drawing circle where text should be
        textAlign(CENTER, BOTTOM);
        tint(132, 11, 76,100);
        text(tweetText, starX[k],starY[k]);
        if(k>=100){
          
          image(ProfileImages.get(k%modifiedtweets.size()),starX[k],starY[k]);
        }
        else{
          image(ProfileImages.get(k),starX[k],starY[k]);
        }
        //println(k+":"+tweetText);
       // noLoop();
       tint(255);
        println(tweetText,starX[k], starY[k]);

        for (int word=0; word<inspirationalWords.length; word++) {
          if (tweetText.contains(" " + inspirationalWords[word] + " ")) {
            //println(inspirationalWords[word]);
            wordVisibility[word] = true;
            wordTransparency[word] += 1;

        //<>//
            if (wordTransparency[word] > 255) {
              wordTransparency[word]=255;
            }
          }
        }//for
      }//if
    }//for
  }//for


  for (int i=0; i< wordVisibility.length; i++) {

    if (wordTransparency[i]<0) {
      wordTransparency[i] = 0;
    }

    if (wordVisibility[i]==true) {
      wordTransparency[i] -= 0.5;

      fill(255, 255, 255, wordTransparency[i]);
      //if ((wordX[i] < 200 && wordY[i]<800) || (wordX[i] > 800 && wordY[i]<800) ) {
        textFont(font1);
        text(inspirationalWords[i], wordX[i]+20, wordY[i]-20, 120, 80);
       
        //println(inspirationalWords[i]);
        //placeRibbon();
      //}
      /*else {
        textFont(font1);
        wordX[i]= 600+10*i;
        wordY[i]= 100+20*i;
        
        text(inspirationalWords[i], wordX[i], wordY[i], 250, 200);
        //println("wordX is:"+" " +wordX[i]+ "wordY is:" + " " + wordY[i]);
        //println("inspirationalWords[i] is:"+inspirationalWords[i]+" " +"wordX[i] is:" + wordX[i] +" "+ "wordY[i] is:"+ wordY[i]);
      }*/
    }
  }//for
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);
  // choose axis
  if (axis == Y_AXIS) {
    /*nested for loops set pixelsin a basic table structure */
    // column
    for (int i=x; i<=(x+w); i++) {
      // row
      for (int j = y; j<=(y+h); j++) {
        color c = color(
          (red(c1)+(j-y)*(deltaR/h)), 
          (green(c1)+(j-y)*(deltaG/h)), 
          (blue(c1)+(j-y)*(deltaB/h)) 
          );
        set(i, j, c);
      }
    }
  } else if (axis == X_AXIS) {
    // column 
    for (int i=y; i<=(y+h); i++) {
      // row
      for (int j = x; j<=(x+w); j++) {
        color c = color(
          (red(c1)+(j-x)*(deltaR/h)), 
          (green(c1)+(j-x)*(deltaG/h)), 
          (blue(c1)+(j-x)*(deltaB/h)) 
          );
        set(j, i, c);
      }
    }
  }
}

void placeRibbon(){
  //println(ribbonX.length);
  float imageRotation = random(-90,90);
  for(int i =0;i<ribbonX.length;i++){
    
     if(dist(500, 300, ribbonX[i], ribbonY[i]) < 300){
       //line(500,300,ribbonX[i],ribbonY[i]);
       tint(255, 50+i);
       image(ribbon,ribbonX[i],ribbonY[i],ribbonSize[i], ribbonSize[i]*1.8); 
     }
     else{continue;}
     tint(255);

  }
}

void MousePress(){
  if(mouseRelease==0){
     mouseRelease=1;
  }
  else{
    
    mouseRelease=0;  
  }
  placeRibbon();
     //println("mouseRelease is"+ mouseRelease); 
}


void mousePressed() {
  if(overBox) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by; 

}

void mouseDragged() {
  if(locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset; 
  }
}

void mouseReleased() {
  locked = false;
}
class ShootingStar{
  //GLOBAL VARIABLE
  int[] ShootingStarX= new int[60];
  int[] ShootingStarY= new int[60];
  int[] ShootingStarSize= new int[30];
  float ShootingstarFadeSize = 0;
  float speedX = -2;
  float speedY = -.5;
 
  //CONSTRUCTOR
    ShootingStar(){
    ShootingStarX = shootX;
    ShootingStarY = shootY;

  }
 
  //FUNCTIONS
  void run(){
  drawShootingStar();
  move();
  fade();
  newShootingStarInit();
  }
 
  void move(){
      // move the shooting star along it's path
    for (int i = 0; i < shootX.length-1; i++) {
      shootX[i] = shootX[i+1];
      shootY[i] = shootY[i+1];
    }
  }
 
  void fade(){
    if (ssTimer >= 0 && ssTimer < shootX.length) {
      shootX[shootX.length-1] = int(startX + ssDeltaX*(ssTimer));
      shootY[shootY.length-1] = int(startY + ssDeltaY*(ssTimer));
      ssTimer++;
      if (ssTimer >= shootX.length) {
        ssTimer = -1; // end the shooting star
      }
    }
  }
 
 
  void drawShootingStar(){
      // draw the shooting star
      for (int i = 0; i < shootX.length-1; i++) {
        int shooterSize = max(0,int(meteorSize*i/shootX.length));
        // to get the tail to disappear need to switch to noStroke when it gets to 0
        if (shooterSize > 0) {
          strokeWeight(shooterSize);
          stroke(255);
         
        }
        else
          noStroke();
        line(shootX[i], shootY[i], shootX[i+1], shootY[i+1]);
        //text(status.getText(), shootX[i], shootY[i], 0, 100);
        //ellipse(shootX[i], shootY[i], meteorSize*i/shootX.length,meteorSize*i/shootX.length);
      }
      meteorSize*=0.94; // shrink the shooting star as it fades
  }
  
  void newShootingStarInit(){
    if (random(20) < 1 && ssTimer == -1) {
      newShootingStar();
    }
  }
  
  void newShootingStar() {
    int endX, endY;
    startX = (int)random(width);
    startY = (int)random(height);
    endX = (int)random(width);
    endY = (int)random(height);
    ssDeltaX = (endX - startX)/(float)(shootX.length);
    ssDeltaY = (endY - startY)/(float)(shootY.length);
    ssTimer = 0; // starts the timer which ends when it reaches shootX.length
    meteorSize = METEOR_SIZE;
    // by filling the array with the start point all lines will essentially form a point initialy
    
    for (int i = 0; i < shootX.length; i++) {
      shootX[i] = startX;
      shootY[i] = startY;
    }
  }
  
}


class FadingText {
  String txt;
  float alpha;
  float r, g, b, x, y;

  FadingText (String _txt) {
    txt = _txt;
    alpha = 255;
    r = random(125, 255);
    g = random(125, 255);
    b = random(125, 255);

    x = random(0, 1280);
    y = random(100, 720);
  }

  void display() {
    textSize(15);
    noStroke();
    fill(r, g, b, alpha);
    text(txt, x, y);
    alpha-=4;// fading speed
  }

  boolean isDone() {  
    return alpha < 0;
  }
}

