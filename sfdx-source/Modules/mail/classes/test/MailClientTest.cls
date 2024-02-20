@isTest
public class MailClientTest {

	private static Account a;
    
    private static Contact c;  
      
       
      
    public MailClientTest() {


       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jose@mail.com',AccountId=a.Id);
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
        msg.setBody('Hello World!');

        client.addMessages(new List<MailMessage>{msg});
        
        MailSendStatus[] statuses = client.send(msg);
        

        Messaging.SingleEmailMessage forceMsg = client.toSingleEmailMessage('jbernal.web.dev@gmail.com', 'TEST EMAIL', '{!c.FirstName}', c.Id, null);
    }
    
    
    
    
    /**
     * MailMessage objects must first be converted to
     * Messaging.SingleEmailMessage objects before being sent by
     * the internal sfdc Messaging.sendEmail() method.
     * 
     * Here we want to confirm various aspects of the conversion.  For example,
     * a when certain properties should have side effects when converted.  When a MailMessage.isTestMessage property
     * is set to True, the resulting SingleEmailMessage object should have its TreatTargetObjectAsRecipient property set to True.
     */
    @isTest
    static void testMessageConversionFromTestToSfdc() {
        
        MailClient client = new MailClient();
        
        // do some work
		MailClientTest t = new MailClientTest();
        
        Id contactId = c.Id;
        
        MailMessage msg = new MailMessage(contactId);
        
        msg.setSubject('Hello');
        msg.setBody('Hello, Jose!');
        msg.setTest(True);
        msg.setTo(UserInfo.getUserEmail());
        Test.startTest();
        

        
        Messaging.SingleEmailMessage sfdc = client.toSingleEmailMessage(msg);
       
        String serialized = client.serialize(msg);
        
        // This object cannot be initialized without some finessing.
        // Messaging.SingleEmailMessage sfdc2 = (Messaging.SingleEmailMessage)JSON.deserialize(serialized, Messaging.SingleEmailMessage.class);
        
        // A test message, even when assigned a whoId,
        // Should not use the whoId record as the recipient.
        // During conversion this value should be False.
		System.assert(sfdc.treatTargetObjectAsRecipient == False);
        System.assert(sfdc.toAddresses == new List<String>{UserInfo.getUserEmail()});
        
        
        

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{sfdc}, True);


        
        Integer numSent = Limits.getEmailInvocations();
        System.debug('Emails sent: ' + numSent);
        Test.stopTest();
    }
    
    
    
    /**
     * MailMessage objects must first be converted to
     * Messaging.SingleEmailMessage objects before being sent by
     * the internal sfdc Messaging.sendEmail() method.
     * 
     * Here we want to confirm various aspects of the conversion.  For example,
     * a when certain properties should have side effects when converted.  When a MailMessage.isTestMessage property
     * is set to True, the resulting SingleEmailMessage object should have its TreatTargetObjectAsRecipient property set to True.
     */
    @isTest
    static void testMessageConversionFromMailMessageToSfdc() {
        
        MailClient client = new MailClient();
        
        // do some work
        // do some work
		MailClientTest t = new MailClientTest();
        
        Id contactId = c.Id;
        
        MailMessage msg = new MailMessage(contactId);
        
        msg.setSubject('Hello');
        msg.setBody('Hello, Jose!');
        
        Test.startTest();
        

        
        Messaging.SingleEmailMessage sfdc = client.toSingleEmailMessage(msg);
       
        // A message, when assigned a whoId,
        // Should use the whoId record as the recipient.
        // During conversion this value should be True for NON-test messages.
        // Also, it is the default value.
		System.assert(sfdc.treatTargetObjectAsRecipient == True);
        
        // If no To: value has been specified this should still be null,
        // even though at send-time there will be a value for the To:
        System.assert(sfdc.toAddresses == null);
        
        // Confirm that the targetObjectId was copied over to the SingleMailMessage.
        // This would come from the whoId value passed to the contructor above.
		System.assert(sfdc.targetObjectId == contactId);
        
		
		Messaging.SendEmailResult[] results;
        

        
        try {
            results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{sfdc}, True);
            
	        client.serialize(sfdc);
        } catch(System.EmailException e) {
        	throw e;    
        }  
        
        Test.stopTest();
		System.debug(results);
        
        Integer numSent = Limits.getEmailInvocations();
        System.debug('Emails sent: ' + numSent);
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