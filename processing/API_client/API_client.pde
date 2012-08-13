/*
Cliente para interactuar con un API restful
Utiliza Jersey[1] y Gson[2]

martinez-zea. 2012
http://martinez-zea.info
Public Domain

[1]http://jersey.java.net/
[2]https://code.google.com/p/google-gson/
*/

//importa las dependencias de Jersey
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
//libreria para manipular JSON
//import com.google.gson.*;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

Client myClient; //instancia del cliente
WebResource myWebResource; //recurso a consultar

JSONParser parser;

void setup() { 
  size(200, 200);
  
  myClient = Client.create();
  //endpoint del API
  myWebResource = myClient.resource("http://api.thingspeak.com/channels/9/feed.json");
  
  parser = new JSONParser();
} 

void draw() { 
 
} 

void getSimpleResource(){
  /*
  Hace una peticion simple al API, la respuesta se entrega como un
  String que luego es convertido a JSON para facil manipulacion
  */
  
  //Gson responseJson = new Gson(); //variable para guardar la respuesta en JSON
  String response = myWebResource.get(String.class); //hace la peticion GET
  //responseJson.toJson(response); //serializa el string en Json

  println(response); //imprime la respuesta 
}

void getResourceWithParams(){
  /*
  Hace una peticion con parametros al API, los parametros para cada
  peticion estan especificados en la documentacion de cada API. Los 
  parametros adicionales se agregan al objeto que los contiene como 
  pares (parametro, valor).
  */
  
  //Gson responseJson = new Gson();
  MultivaluedMap queryParams = new MultivaluedMapImpl(); //objeto que agrupa los parametros
  queryParams.add("results", "10"); // agrega "?results=10" al query
  //hace el query con los parametros especificados
  String response = myWebResource.queryParams(queryParams).get(String.class);
  //responseJson.toJson(response);
  
  try {
    Object obj = parser.parse(response);
    JSONObject jsonObj = (JSONObject) obj;
    
    Object channelObj = jsonObj.get("channel");
    JSONObject channelJson = (JSONObject) channelObj;
    println("channel data \n================= ");
    println("id: " + channelJson.get("id"));
    println("description: " + channelJson.get("description"));
    println("name:" + channelJson.get("name"));
    println("field1: " + channelJson.get("field1"));
    println("field2: " + channelJson.get("field2"));
    println("latitude: " + channelJson.get("latitude"));
    println("longitude: " + channelJson.get("longitude"));
    
    Object feedsObj = jsonObj.get("feeds");
    JSONArray feedsArray = (JSONArray) feedsObj;
    Iterator<String> iterator = feedsArray.iterator();
    println("\n\nfeeds data \n================= \n");
    while (iterator.hasNext()){
      Object data = iterator.next();
      JSONObject dataJson = (JSONObject) data;
      println("created at: " + dataJson.get("created_at"));
      println("field1: " + dataJson.get("field1"));
      println("field2: " + dataJson.get("field2") + "\n");
    }
    
  } catch (ParseException e){
    e.printStackTrace();
  }
  
  //println (response);
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

