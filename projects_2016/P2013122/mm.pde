import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


static String OAuthConsumerKey = "*";      //Σε αυτό το κομμάτι γίνεται η σύνδεση με το twitter ώστε να ληφθούν δεδομένα (χρειάζονται τα keys and access tokens από το χρήστη)
static String OAuthConsumerSecret = "*";
static String AccessToken = "*";
static String AccessTokenSecret = "*";
TwitterStream twitter = new TwitterStreamFactory().getInstance(); 

int width = 950;                   //Δηλώνεται το ύψος και το πλάτος του διαδραστικού frame    
int height = 658;
int y;                            //Δηλώνονται οι counters που μετράνε τα tweets που περιέχει τα ζητούμενα keywords
int keyword1Counter = 0;                                 
int keyword2Counter = 0;
int totalCounter=0;


String keyword1 = "good";               //Σε αυτό το σημείο δηλώνονται τα δύο strings (keywords) που ο κώδικας θα κληθεί να εντοπίσει στο περιεχόμενο των tweets
String keyword2 =  "bad";
color keyword1Color = color(24, 108, 149);
color keyword2Color = color(13, 135, 168);

PImage bgimage;                          
PFont f;
PImage img;


AudioPlayer player;
Minim minim;//audio context


void setup()
{
  
  minim = new Minim(this);
  player = minim.loadFile("music.mp3", 2048);     //Background ήχος
  player.play();
  player.loop();                                
  
  connectTwitter();                              //Καλούνται οι functions για την εδραίωση της σύνδεσης στο twitter και το tracking των keywords
  twitter.addListener(listener);
  
   
  
  String keywords[] = {keyword1, keyword2};                      
  twitter.filter(new FilterQuery().track(keywords));    //Εντοπίζει τα ζητούμενα keywords

  size(950, 658);                                      //Frame size
  f = createFont("Segoe UI", 14);
  textFont(f);



 totalCounter=keyword1Counter+keyword2Counter;       //Counter συνολικών Tweets

  bgimage = loadImage("logo.jpg");       //Background εικόνα
  background(bgimage);
}

void draw()                                 // Εμφάνιση δεδομένων στο διαδραστικό frame της εφαρμογής
{
 totalCounter=keyword1Counter+keyword2Counter;

 
  fill(color(80, 212, 236));                                   //μπάρες αποτελεσμάτων
  rect(width*0, height*.1, width*.3, height*.05);
  rect(width*.7, height*.1, width*1, height*.05);
  rect(width*.9, height*.05, width*2, height*.05);

  
  
  fill(color(26, 17, 132)); 
  text(keyword1, width*.05, height*.125);
  text("Counter" +":  "+ keyword1Counter, width*.13, height*.125);
  
  
  text(keyword2, width*.75, height*.125);
  text("Counter" +":  "+ keyword2Counter, width*.83, height*.125);
 
  

  text(" Total" +" : " + totalCounter, width*.900, height*.085);
 
  
  
  double percent = (double)keyword1Counter / (keyword1Counter+keyword2Counter);       
  fill(color(244, 255, 255));                                                                            //Χρώματα μπαρών ποσοστών 
  rect(width*0, height*.15, (int)(width*percent), height*.03);
  fill(color(255, 255, 255));
  rect((int)(width*percent), height*.15, width*1, height*.03);
  
  fill(keyword1Color);
  text(Double.toString(round((float)percent*1000)/(int)10)+"%", (int)(percent*width/2.5), (int)height*.17);                //μεγέθη μπαρών ποσοστών
  fill(keyword2Color);                                                                                                 
  text(Double.toString(100-round((float)percent*1000)/(int)10)+"%", width-(int)((1-percent)*width/1.9), (int)height*.17);  
  
 
 
}




void connectTwitter() {                                                                   // Αρχική σύνδεση για τη λήψη δεδομένων
twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
AccessToken accessToken = loadAccessToken();
twitter.setOAuthAccessToken(accessToken);
}

private static AccessToken loadAccessToken() {                                            // Φόρτωση σύνδεσης
return new AccessToken(AccessToken, AccessTokenSecret);
}


StatusListener listener = new StatusListener() {                                           // Το πρόγραμμα "ακούει" για νέα tweets
  
  
  public void onStatus(Status status) {
    if (status.getText().indexOf(keyword1)!= -1)
    {
     keyword1Counter++;                                                               //Εάν το νέο tweet που άκουσε το πρόγραμμα περιέχει το 1ο keyword, αυξάνει τον ανάλογο counter 
      image(loadImage((status.getUser().getMiniProfileImageURL())), (int)random(width*.45), height-(int)random(height*0.7));   //Λαμβάνει random μini progile's photos των χρηστών στους οποίους το tweet ανήκει
    }
    if (status.getText().indexOf(keyword2)!= -1) 
    {
      keyword2Counter++;                                                                        //το ίδιο συμβαίνει και για το δεύτερο keyword
      image(loadImage((status.getUser().getMiniProfileImageURL())), width-(int)random(width*.45), height-(int)random(height*0.7));
    } 
  }
  public void onStallWarning(StallWarning stallwarning){}                                              //συναρτήσεις που καλούνται για την ενημέρωση και βοήθεια του χρήστη σε περίπτωση προβλήματος
  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {}
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {}
  public void onScrubGeo(long userId, long upToStatusId) {
  System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }
  public void onException(Exception ex) {
    ex.printStackTrace();
  }

};