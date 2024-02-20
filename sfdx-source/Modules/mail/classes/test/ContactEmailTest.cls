@IsTest
public class ContactEmailTest {
    

    
    public Account a;    
    
    public Contact c;
    
   	public SObject tpl;
    

    public ContactEmailTest() {
  

       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
        
         
        tpl = new MessageTemplate__c(Name='Generic Template',Subject__c = 'TEST TEMPLATE EMAIL', HtmlBody__c = 'Hello, {!Contact.Foobar__c}');
        insert tpl;
    }
        
     

    
    @isTest
    static void testWhoIdWhatId() {
        
        ContactEmailTest context = new ContactEmailTest();
        
        Id whoId = context.c.Id;
        Id whatId = null;
        
        MessageWhoIdWhatId whoIdWhatId = new MessageWhoIdWhatId(whoId,whatId);
        whoIdWhatId.getWhoId();
        whoIdWhatId.getWhatId();
    }
      
    
    
    @isTest
    static void testGetData() {
        
        ContactEmail generator = new ContactEmail();
    }
        
      
      
    @isTest
    static void previewEmails() {
        
        Test.startTest(); 
        
        	ContactEmailTest context = new ContactEmailTest(); 
        	ContactEmail generator = new ContactEmail(context.c.Id);
        	generator.getMessages();
        
        	MailApiConfig preview = new MailApiConfig();
        
        	preview.sample = True;  
			preview.generator = 'ContactEmail';
        	preview.template = 'Generic Template';
        	
			// Should we test the return values of the above method calls?
            OcdlaMail.previewEmails(new List<Id>{context.c.Id}, preview);

        
        Test.stopTest();  
    }
    
    
    
    @isTest
    static void testEmails() {
      
        ContactEmailTest context = new ContactEmailTest();
  
        Test.startTest();  

        	ContactEmail generator = new ContactEmail(context.c.Id); 
        	MailApiConfig testConfig = new MailApiConfig();
        
        	testConfig.sample = False;
			testConfig.generator = 'ContactEmail';
        	testConfig.template = 'Generic Template';  
        
            OcdlaMail.testEmails(new List<Id>{context.c.Id}, testConfig);

        Test.stopTest();  
    }
    
       
    @isTest
    static void sendEmails() {
     
        ContactEmailTest context = new ContactEmailTest();
  
        /*
         * 
msg.bccAddresses == null;

msg.bccSender = False;

msg.ccAddresses == new List<String>{'admin@ocdla.org'};

msg.charset == null;

msg.subject = 'Hello';

msg.toAddresses = null;

msg.htmlBody = '<h1>Hello</h1>';
         */ 
        Test.startTest();

        	ContactEmail generator = new ContactEmail(context.c.Id);
        	MailApiConfig config = new MailApiConfig();
        
        	config.sample = False;  
			config.generator = 'ContactEmail';
        	config.template = 'Generic Template';
        	config.afterSend = 'MembershipRenewalMailAction';
        
        	OcdlaMail.sendEmails(new List<Id>{context.c.Id}, config);
        
        	config.afterSend = 'ExpertWitnessMailAction';
        	OcdlaMail.sendEmails(new List<Id>{context.c.Id}, config);
        
        Test.stopTest();
    }
    

}