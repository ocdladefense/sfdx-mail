@isTest
public class MailClientTest {

	private static Account a;
    
    private static Contact c;  
      
     
      
    public MailClientTest() {


       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
    }
    
    
	@isTest
    static void testClient() {
        
        MailClientTest test = new MailClientTest();
        
		MailClient client = new MailClient();
        client.reset();  
        client.getMailbox('outbox'); 
            
        MailMessage msg = client.compose('jbernal.web.dev@gmail.com');
        msg.setSubject('TEST EMAIL');
        msg.setBody('Hello, {!Contact.FirstName}!');

        client.addMessages(new List<MailMessage>{msg});
        
        MailSendStatus[] statuses = client.send(msg);
        

        // Messaging.SingleEmailMessage forceMsg = client.toSingleEmailMessage('jbernal.web.dev@gmail.com', 'TEST EMAIL', '{!Contact.FirstName}', c.Id, null);
    }
    
    
    @isTest
    static void testMailSendStatuses() {
        
        MailSendStatus status = new MailSendStatus();
        status.dateSent = System.today();
        status.isSuccess = False;
        status.message = 'foobar';
    }
      

    
    @isTest
    static void testMessages() {
        MailMessage msg = new MailMessage('jbernal.web.dev@gmail.com','TEST MESSAGE', 'Hello World!');
        
        try {
            throw new MailClientException('Testing mail client exception.');
        } catch(Exception e) {
            
        }
    }

}