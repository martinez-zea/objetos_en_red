

import javax.mail.*;
import javax.mail.internet.*;

Message[] msgs = new Message[1];

Message lastMessage;
int lastMessageCount;
boolean firstCheck = true;
/*
String email = "email@server.domain";
String server = "mail.server.domain";
String pass = "password";
*/

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
    Properties props = System.getProperties();

  //puerto de email sin ssl en dreamhost
    props.put("mail.imap.port", "993");
    
    //seguridad
    /*
    props.put("mail.imap.starttls.enable", "true");
    props.setProperty("mail.imap.socketFactory.fallback", "false");
    props.setProperty("mail.imap.socketFactory.class","javax.net.ssl.SSLSocketFactory");
    */
    props.setProperty("mail.store.protocol", "imaps");

    //Auth auth = new Auth();
    
    // Make a session
    Session session = Session.getDefaultInstance(props, null);
    //Store store = session.getStore("pop3");
    Store store = session.getStore("imaps");
    store.connect(imap_host, email, pass);
    
    // Get inbox
    Folder folder = store.getFolder("INBOX");
    folder.open(Folder.READ_ONLY);
    System.out.println(folder.getMessageCount() + " total messages.");
    
    // Get array of messages and display them
    //msgs = folder.getMessages();
 
    if(lastMessageCount < folder.getMessageCount()){
      if(firstCheck){
        println("first check");
        lastMessageCount = folder.getMessageCount();
        msgs[0] = folder.getMessages()[folder.getMessageCount() - 1];
        firstCheck = false;
        
      }else{
        println("normal check");

        int newMessageCount = abs(folder.getMessageCount() - lastMessageCount);
        //int startMessage = folder.getMessageCount() - 1;
        //int endMessage = folder.getMessageCount() - newMessageCount;
        msgs[0] = folder.getMessages()[folder.getMessageCount() - 1];
        lastMessageCount = folder.getMessageCount();
      }

      for(int i = 0; i < msgs.length; i ++){
        System.out.println("---------------------");
        //System.out.println("Message # " + (i+1));
        System.out.println("From: " + msgs[i].getFrom()[0]);
        System.out.println("Subject: " + msgs[i].getSubject());
        System.out.println("Message:");
        String content = msgs[i].getContent().toString(); 
        System.out.println(content);
         
      
    }
    }
    
    // Close the session
    folder.close(false);
    store.close();
    
  } 
  // This error handling isn't very good
  catch (Exception e) {
    e.printStackTrace();
  }
}

// A function to send mail
void sendMail() {
  // Create a session
  Properties props=new Properties();

  // SMTP Session for gmail
  
  props.put("mail.transport.protocol", "smtp");
  props.put("mail.smtp.host", smtp_host);
  props.put("mail.smtp.port", "587");
  props.put("mail.smtp.auth", "true");
  // We need TTLS, which gmail requires
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
  Session session = Session.getDefaultInstance(props, new Auth());

  try
  {
    // Crea un nuevo mensaje
    MimeMessage message = new MimeMessage(session);

    // Define el remitente
    message.setFrom(new InternetAddress(email, "Cafetera"));

    // Define el destinatario
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("zea@randomlab.net", false));

    // Subject and body
    message.setSubject("Hello World!");
    message.setText("Ping from processing. . .");

    // We can do more here, set the date, the headers, etc.
    Transport.send(message);
    
    /* otra forma de hacerlo por ssl
    Transport transport = session.getTransport("smtps");
    transport.connect(host, 587, email, pass );
    transport.sendMessage(message, message.getAllRecipients());
    */
    
    //transport.close(); 
   
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

