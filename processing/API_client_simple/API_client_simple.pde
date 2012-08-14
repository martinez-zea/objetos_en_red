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
  //endpoint del API a interactuar
  postResource = myClient.resource("http://api.openkeyval.org/objetos_en_red-posTest");
  
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
  
  String response = postResource.get(String.class); //hace la peticion GET
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
  
  MultivaluedMap queryParams = new MultivaluedMapImpl(); //objeto que agrupa los parametros
  queryParams.add("results", "10"); // agrega "?results=10" al query
  //hace el query con los parametros especificados
  String response = postResource.get(String.class);
  
  // ciclo Try and Except para la manipulacion JSON
  try {
    //el string con la respuesta se convierte en un Objeto de Java
    Object obj = parser.parse(response);
    //luego se convierte en un Objeto de la clase simple-json
    JSONObject jsonObj = (JSONObject) obj;
    
       
    //extraemos cada uno de los campos del objecto
    println("resource data \n================= ");
    println("posX: " + jsonObj.get("posX"));
    println("posY: " + jsonObj.get("posY"));
    
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
  dataJson.put("posX", str(random(width)));
  dataJson.put("posY", str(random(height)));
  
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
      getResourceAndParse();
      break;
    case RIGHT:
      getSimpleResource();
      break;
    case CENTER:
      postData();
      break;
  }  
}

