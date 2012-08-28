

TwC twitter;

void setup() {
  
  size(100,100);
  background(0);
  
  twitter = new TwC(" ",//OAuthConsumerKey 
                    " ", //OAuthConsumerKeySecret
                     " ", //AccessToken
                     " " //AccessTokenSecret
                    );
  twitter.connect();
  twitter.send("hello world! from #processing");
}


void draw() {
  background(0);
}





