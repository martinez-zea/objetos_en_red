/*
Cliente para interactuar con un API restful
Utiliza Jersey[1] y json-simple[2]

martinez-zea. 2012
http://martinez-zea.info
Public Domain

[1]http://jersey.java.net/
[2]https://code.google.com/p/json-simple/
*/

//importa las dependencias de Jersey
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;

//libreria para manipular JSON
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

Client myClient; //instancia del cliente
WebResource myWebResource; //recurso a consultar via GET
WebResource postResource; //recurso para hacer POST

JSONParser parser; //Objeto para analizar JSON

void setup() { 
  size(200, 200);
  
  //Inicializa la instancia del cliente
  myClient = Client.create();
  //endpoints del API a interactuar
  myWebResource = myClient.resource("http://api.thingspeak.com/channels/9/feed.json");
  postResource = myClient.resource("http://api.openkeyval.org/objetos_en_red-test");
  
  //instancia el parser de Json
  parser = new JSONParser();
} 

void draw() { 
 
} 

void getSimpleResource(){
  /*
  Hace una peticion simple al API, la respuesta se entrega como un
  String.
  */
  
  String response = myWebResource.get(String.class); //hace la peticion GET
  println(response); //imprime la respuesta 
}

void getResourceWithParams(){
  /*
  Hace una peticion con parametros al API, los parametros para cada
  peticion estan especificados en la documentacion de cada API. Los 
  parametros adicionales se agregan al objeto que los contiene como 
  pares (parametro, valor).
  
  La respuesta es convertida a objetos JSON de los cuales se extrae 
  luego la informacion que contienen
  */
  
  MultivaluedMap queryParams = new MultivaluedMapImpl(); //objeto que agrupa los parametros
  queryParams.add("results", "10"); // agrega "?results=10" al query
  //hace el query con los parametros especificados
  String response = myWebResource.queryParams(queryParams).get(String.class);
  
  // ciclo Try and Except para la manipulacion JSON
  try {
    //el string con la respuesta se convierte en un Objeto de Java
    Object obj = parser.parse(response);
    //luego se convierte en un Objeto de la clase simple-json
    JSONObject jsonObj = (JSONObject) obj;
    
    //se crea un nuevo Objeto con lo almacenado en el campo channel
    Object channelObj = jsonObj.get("channel");
    JSONObject channelJson = (JSONObject) channelObj;
    
    //extraemos cada uno de los campos del objecto
    println("channel data \n================= ");
    println("id: " + channelJson.get("id"));
    println("description: " + channelJson.get("description"));
    println("name:" + channelJson.get("name"));
    println("field1: " + channelJson.get("field1"));
    println("field2: " + channelJson.get("field2"));
    println("latitude: " + channelJson.get("latitude"));
    println("longitude: " + channelJson.get("longitude"));
    
    //la misma operacion anterior sobre el campo feeds
    //feeds contiene un array de objetos, para eso usamos JSONArray
    Object feedsObj = jsonObj.get("feeds");
    JSONArray feedsArray = (JSONArray) feedsObj;
    
    //para recorerlo se usa un Iterador
    Iterator<String> iterator = feedsArray.iterator();
    println("\n\nfeeds data \n================= \n");
    
    //Recorre todos los objetos dentro del iterador
    while (iterator.hasNext()){
      //Aplica la misma tecnica anterior para acceder
      //a los datos guardados en cada campo
      Object data = iterator.next();
      JSONObject dataJson = (JSONObject) data;
      println("created at: " + dataJson.get("created_at"));
      println("field1: " + dataJson.get("field1"));
      println("field2: " + dataJson.get("field2") + "\n");
    }
    
  } catch (ParseException e){
    //Si hay algun error, aca debe imprimirse en la consola
    e.printStackTrace();
  }
}

void postData(){
  /*
  Construye un objeto JSON con la informacion a guardar y lo envia
  al endpoint del API especificado usando el metodo HTTP POST, si
  la peticion se realizo correctamente la respuesta contiene el 
  status 200 OK
  */
  
  //crea un nuevo objeto JSONObject
  JSONObject dataJson = new JSONObject();
  //agrega dos campos con sus respectivos datos
  //.put("campo", "valor")
  dataJson.put("name", "objetos en red");
  dataJson.put("millis", str(millis()));
  
  //crea un JSONArray
  JSONArray arrayJson = new JSONArray();
  //lo llena con numeros aleatorios
  arrayJson.add(str(random(1000)));
  arrayJson.add(str(random(1000)));
  arrayJson.add(str(random(1000)));
  //agrega el array al objeto JSONObject
  dataJson.put("floats", arrayJson);
  
  //crea un objeto contendra los datos a enviar
  MultivaluedMap formData = new MultivaluedMapImpl();
  //crea el campo con el nombre "data" y guarda el string JSON creado antes
  formData.add("data", dataJson.toJSONString());
  //Hace el POST al URL del API
  ClientResponse response = postResource.post(ClientResponse.class, formData);
  //finalmente imprime la respuesta enviada por el servidor
  println(response);
}

void mousePressed(){
  switch (mouseButton){
    case LEFT:
      getResourceWithParams();
      break;
    case RIGHT:
      getSimpleResource();
      break;
    case CENTER:
      postData();
      break;
  }  
}

