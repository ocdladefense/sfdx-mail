@IsTest
public class ContactEmailTest {
    

    
    public Account a;    
    
    public Contact c;
    
   	public MessageTemplate__c tpl;
    

    public ContactEmailTest() {
  

       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
        
         
        tpl = new MessageTemplate__c(Subject__c = 'TEST TEMPLATE EMAIL', HtmlBody__c = 'Hello, {!Contact.Foobar__c}');
        insert tpl;
        tpl = [SELECT Id, Name, Subject__c, HtmlBody__c, Label__c FROM MessageTemplate__c WHERE Id = :tpl.Id LIMIT 1];
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
        
        ContactEmailTest context = new ContactEmailTest();
        
        ContactEmail generator = new ContactEmail();
        generator.setTemplate(context.tpl.Name);
        MailMessageIterator it = generator.iterator();

        it.split(1);
    }
        
      
      
    @isTest
    static void previewEmails() {
        
        Test.startTest(); 
        
        	ContactEmailTest context = new ContactEmailTest(); 
        	ContactEmail generator = new ContactEmail(context.c.Id);
        	// generator.getMessages();
        
        	MailApiConfig preview = new MailApiConfig();
        
        	preview.sample = True;  
			preview.generator = 'ContactEmail';
        	preview.template = context.tpl.Name;
        	
			// Should we test the return values of the above method calls?
            MailApi.previewEmails(new List<Id>{context.c.Id}, preview);

        
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
        	testConfig.template = context.tpl.Name;  
        
            MailApi.testEmails(new List<Id>{context.c.Id}, testConfig);

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
        	config.template = context.tpl.Name;
        	config.afterSend = 'MembershipRenewalMailAction';
        
        	MailApi.sendEmails(new List<Id>{context.c.Id}, config);
        
        	config.afterSend = 'ExpertWitnessMailAction';
        	MailApi.sendEmails(new List<Id>{context.c.Id}, config);
        
        Test.stopTest();
    }
    

}