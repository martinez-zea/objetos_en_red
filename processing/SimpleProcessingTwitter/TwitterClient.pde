/*

Just a simple Processing and Twitter thingy majiggy

RobotGrrl.com

Code licensed under:
CC-BY

*/

// First step is to register your Twitter application at dev.twitter.com
// Once registered, you will have the info for the OAuth tokens
// You can get the Access token info by clicking on the button on the
// right on your twitter app's page
// Good luck, and have fun!


class TwC{
  Twitter twitter = new TwitterFactory().getInstance();
  RequestToken requestToken;
  // This is where you enter your Oauth info
   String OAuthConsumerKey;
   String OAuthConsumerSecret; 
   String AccessToken;
   String AccessTokenSecret;
  
  // Just some random variables kicking around
  String myTimeline;
  java.util.List statuses = null;
  User[] friends;
  String[] theSearchTweets = new String[11];
  
  TwC(String oac, String oacs, String at, String ats){
    OAuthConsumerKey = oac;
    OAuthConsumerSecret = oacs;
    AccessToken = at;
    AccessTokenSecret = ats;    
  }
  
    // Initial connection
  void connect() {
    twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
    AccessToken accessToken = loadAccessToken();
    twitter.setOAuthAccessToken(accessToken);
  }
  
  // Sending a tweet
  void send(String t) {
    try {
      Status status = twitter.updateStatus(t);
      println("Successfully updated the status to [" + status.getText() + "].");
    } catch(TwitterException e) { 
      println("Send tweet: " + e + " Status code: " + e.getStatusCode());
    }
  }
  
  
  // Loading up the access token
  private AccessToken loadAccessToken(){
    return new AccessToken(AccessToken, AccessTokenSecret);
  }
  
  
  // Get your tweets
  void getTimeline() {
    try {
      statuses = twitter.getUserTimeline(); 
    } catch(TwitterException e) { 
      println("Get timeline: " + e + " Status code: " + e.getStatusCode());
    }
  
    for(int i=0; i<statuses.size(); i++) {
      Status status = (Status)statuses.get(i);
      println(status.getUser().getName() + ": " + status.getText());
    }
  }
  
  
  // Search for tweets
  void getSearchTweets(String ask) {
    String queryStr = ask;
  
    try {
      Query query = new Query(queryStr);    
      query.setRpp(10); // Get 10 of the 100 search results  
      QueryResult result = twitter.search(query);    
      ArrayList tweets = (ArrayList) result.getTweets();    
  
      for (int i=0; i<tweets.size(); i++) {	
        Tweet t = (Tweet)tweets.get(i);	
        String user = t.getFromUser();
        String msg = t.getText();
        Date d = t.getCreatedAt();	
        theSearchTweets[i] = msg.substring(queryStr.length()+1);
  
        println(theSearchTweets[i]);
      }
  
    } catch (TwitterException e) {    
      println("Search tweets: " + e);  
    }
  }
  
}
