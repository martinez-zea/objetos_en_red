

import javax.mail.*;
import javax.mail.internet.*;

Message lastMessage;
int lastMessageCount;
boolean firstCheck = true;

String email = "user@gmail.com";
String smtp_host = "smtp.gmail.com";
String imap_host = "imap.gmail.com";
String pass = "password";

void setup() {
  size(200,200);
  lastMessageCount = 0;
}

void draw(){

}


void checkMail() {
  try {
    
    Properties props = new Properties();

    //
    props.put("mail.imap.port", "993");
    
    //seguridad
    /*
    props.put("mail.imap.starttls.enable", "true");
    props.setProperty("mail.imap.socketFactory.fallback", "false");
    props.setProperty("mail.imap.socketFactory.class","javax.net.ssl.SSLSocketFactory");
    */
    props.setProperty("mail.store.protocol", "imaps");

    //Auth auth = new Auth();
    
    // Crea una sesion
    Session receive_session = Session.getDefaultInstance(props, null);
    Store store = receive_session.getStore("imaps");
    store.connect(imap_host, email, pass);
    
    // Obtiene el Inbox
    Folder folder = store.getFolder("INBOX");
    folder.open(Folder.READ_ONLY);
    System.out.println(folder.getMessageCount() + " total messages.");

    if(lastMessageCount < folder.getMessageCount()){
      if(firstCheck){
        println("first check");
        lastMessageCount = folder.getMessageCount();
        lastMessage = folder.getMessages()[folder.getMessageCount() - 1];
        firstCheck = false;
        
      }else{
        println("normal check");
        int newMessageCount = abs(folder.getMessageCount() - lastMessageCount);
        lastMessage = folder.getMessages()[folder.getMessageCount() - 1];
        lastMessageCount = folder.getMessageCount();
      }

        println("--------- BEGIN MESSAGE------------");
        println("From: " + lastMessage.getFrom()[0]);
        println("Subject: " + lastMessage.getSubject());
        println("Message:");
        String content = lastMessage.getContent().toString(); 
        println(content);
        println("--------- END MESSAGE------------");

    }else{
      println("Usted no teine mensajes nuevos");
    }
    
    // Cierra la sesion
    folder.close(false);
    store.close();
  } 
  // Gestion de errores muy basica
  catch (Exception e) {
    e.printStackTrace();
  }
}

// Envia email a travez de smtp
void sendMail() {

  Properties props=new Properties();

  // SMTP Session for gmail
  
  props.put("mail.transport.protocol", "smtp");
  props.put("mail.smtp.host", smtp_host);
  props.put("mail.smtp.port", "587");
  props.put("mail.smtp.auth", "true");
  
  // Necesitamos TLS para gmail
  props.put("mail.smtp.starttls.enable","true");
  /*
  //configuracion para ssl
  props.put("mail.transport.protocol", "smtps");
  props.put("mail.smtp.host", server);
  props.put("mail.smtp.socketFactory.port", "587");
  props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
  props.put("mail.smtp.socketFactory.fallback", "false");
  */
  // Crea una sesion
  Session send_session = Session.getInstance(props, null);

  try
  {
    // Crea un nuevo mensaje
    MimeMessage message = new MimeMessage(send_session);

    // Define el remitente
    message.setFrom(new InternetAddress(email, "Cafetera"));

    // Define el destinatario
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("zea@randomlab.net", false));

    //Asunto y cuerpo del mensaje
    message.setSubject("Hello World!");
    message.setText("Ping from processing. . .");
    
    
    //Autenticacion y envio del mensaje
    Transport transport = send_session.getTransport("smtp");
    transport.connect(smtp_host, 587, email, pass );
    transport.sendMessage(message, message.getAllRecipients());
    transport.close(); 
   
    println("Mail sent!");
 
}
  catch(Exception e)
  {
    e.printStackTrace();
  }
}

void keyReleased(){
  if(key == 's'){
    sendMail();
  }
  if(key == 'c'){
    checkMail();
  }
}

