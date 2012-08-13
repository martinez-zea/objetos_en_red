import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;

Client myClient; //instancia del cliente
WebResource myWebResource; //recurso a consultar

void setup() { 
  size(200, 200);
  
  myClient = Client.create();
  //endpoint del API
  myWebResource = myClient.resource("http://api.thingspeak.com/channels/9/feed.json");
} 

void draw() { 
 
} 

void getSimpleResource(){
  String response = myWebResource.get(String.class);
  println(response);
}

void getResourceWithParams(){
  MultivaluedMap queryParams = new MultivaluedMapImpl();
  queryParams.add("results", "10");
  String response = myWebResource.queryParams(queryParams).get(String.class);
  println (response);
}

void mousePressed(){
  switch (mouseButton){
    case LEFT:
      getResourceWithParams();
      break;
    case RIGHT:
      getSimpleResource();
      break;
  }  
}

