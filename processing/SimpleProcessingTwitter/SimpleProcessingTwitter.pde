

TwC twitter;
ArrayList searchResult;

void setup() {
  
  size(100,100);
  background(0);
  
  twitter = new TwC(" ",//OAuthConsumerKey 
                    " ", //OAuthConsumerKeySecret
                     " ", //AccessToken
                     " " //AccessTokenSecret
                    );
  twitter.connect();
 //twitter.send("hello world! from #processing");
  
  //busqueda 
  searchResult = twitter.search("#testing");
  for (int i=0; i<searchResult.size(); i++) {	
        Tweet t = (Tweet)searchResult.get(i);	
        String user = t.getFromUser();
        String msg = t.getText();
        Date d = t.getCreatedAt();	
        println(msg);
  }
}


void draw() {
  background(0);
}





