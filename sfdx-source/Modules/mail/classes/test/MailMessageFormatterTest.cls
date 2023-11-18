@isTest
public class MailMessageFormatterTest {

    
    
	private static Account a;
    
    private static Contact c;  
      
     
      
    public MailMessageFormatterTest() {


       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
    }
    
    
    @isTest
    static void testHtmlTidyFilter() {
        String result = HtmlTidyFilter.filter('foobar');
        result = TextPlainToTextHtmlFilter.filter('foobar');
    }
    
    @isTest
    static void testErrors() {
        try {
        	throw new MailMessageFormatterException('ERROR');
        } catch(Exception e) {
            System.debug('ERROR TESTED.');
        }
    }
    
    
    @isTest
    static void testMailMessageFormatter() {
        
        MailMessageFormatterTest tester = new MailMessageFormatterTest();
        
        MailClientTest test = new MailClientTest();
        
        DefaultMailClientSettings config = new DefaultMailClientSettings();
        
        String letterhead = (String)config.get('letterhead');
        
        MailMessageFormatter brand = new MailMessageFormatter();
       
        
        String result2 = MailMessageFormatter.doMerge('{!Contact.FirstName}',c.Id);
    }
    
}