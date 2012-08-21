/*
Cliente para interactuar con un API restful
Utiliza Jersey[1] y json-simple[2]

El backend donde se guarda la data es una
instancia de couchdb[3]

martinez-zea. 2012
http://martinez-zea.info
Public Domain

[1]http://jersey.java.net/
[2]https://code.google.com/p/json-simple/
[3]https://couchdb.apache.org/
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
WebResource couchdbResource; //recurso a consultar via GET
                             // y actualizar via POST

JSONParser parser; //Objeto para analizar JSON

float posX;
float posY;
String rev;

void setup() { 
  size(400, 400);
   
  //Inicializa la instancia del cliente
  myClient = Client.create();
  //endpoint del API a interactuar
  couchdbResource = myClient.resource("https://martinez-zea.iriscouch.com/objetos_red/localization/");
  
  //instancia el parser de Json
  parser = new JSONParser();
} 

void draw() { 
   rect(posX,posY,10,10);
} 

void getSimpleResource(){
  /*
  Hace una peticion simple al API, la respuesta se entrega como un
  String.
  */
  String response = couchdbResource.get(String.class); //hace la peticion GET
  println(response); //imprime la respuesta  
}

void getResourceAndParse(){
  /*
  Hace una peticion con parametros al API, los parametros para cada
  peticion estan especificados en la documentacion de cada API. Los 
  parametros adicionales se agregan al objeto que los contiene como 
  pares (parametro, valor).
  
  La respuesta es convertida a objetos JSON de los cuales se extrae 
  luego la informacion que contienen
  */
  
  //hace el query a la bd
  String response = couchdbResource.get(String.class);
  
  // ciclo Try and Except para la manipulacion JSON
  try {
    //el string con la respuesta se convierte en un Objeto de Java
    Object obj = parser.parse(response);
    //luego se convierte en un Objeto de la clase simple-json
    JSONObject jsonObj = (JSONObject) obj;
    
    posX = float((String)jsonObj.get("posX"));
    posY = float((String)jsonObj.get("posY"));
    rev = (String)jsonObj.get("_rev");
    
    //extraemos cada uno de los campos del objecto
    println("resource data \n================= ");
    println("posX: " + posX);
    println("posY: " + posY);
    println("rev: " + rev);
    
  } catch (ParseException e){
    //Si hay algun error, aca debe imprimirse en la consola
    e.printStackTrace();
  }
}

void postData(){
  /*
  Construye un objeto JSON con la informacion a guardar y lo envia
  al endpoint del API especificado usando el metodo HTTP PUT, si
  la peticion se realizo correctamente la respuesta contiene el 
  status 200 OK
  */
  
  //crea un nuevo objeto JSONObject
  JSONObject dataJson = new JSONObject();
  //agrega dos campos con sus respectivos datos
  //.put("campo", "valor")
  dataJson.put("posX", str(random(width)));
  dataJson.put("posY", str(random(height)));
  dataJson.put("_rev", rev);
 
  //Hace el PUT al URL del API
  ClientResponse response = couchdbResource.put(ClientResponse.class, dataJson.toJSONString());
  //finalmente imprime la respuesta enviada por el servidor
  println("server response data \n================= ");
  println(response);
}

void mousePressed(){
  switch (mouseButton){
    case LEFT:
      getResourceAndParse();
      break;
      
    case RIGHT:
      postData();
      break;
      
    case CENTER:
      getSimpleResource();
      break;
  }  
}

