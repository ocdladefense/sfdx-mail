public class ContactEmail extends MailGenerator {

    

    
    
    public ContactEmail(Id contactId) {
		this.recordIds.add(contactId);
    }
    
    public ContactEmail() {
        
    }  
    

    
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> contactIds) {
        
        MessageWhoIdWhatId whoIsIt;
        
        Account a = new Account(Name='My Test Account');
        insert a;
        
        Contact c = new Contact(AccountId=a.Id,FirstName = 'Jane',LastName='Doe',Email='jbernal.web.dev@gmail.com');
        insert c;        
        

        return new MessageWhoIdWhatId(c.Id,null);
    }
    

  

      
    public override List<MailMessage> getMessages() {
    
		System.debug(data);
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :recordIds];
		List<MailMessage> emails = new List<MailMessage>();

        
        // String tplName = 'Membership Renewal Confirmation';
        // tplName = 'AC19 Update';
        
        // MailMessageTemplate tpl = MailMessageTemplate.fromSObject(tplName);
        
        
        for(Contact c :contacts){
			MailMessage msg = new MailMessage(c.Id, null);
            msg.setTo(c.Email);
			// msg.setTemplate(tpl);
            emails.add(msg);
        }

        
        // Collection of MailMessage objects.
        // The iterator will apply the template specified in setTemplate().
        // MailMessageIterator queue = new MailMessageIterator(emails);
        // queue.setTemplate(tpl);
        
        // MailClient client = new MailClient();
        // client.send(queue);
        
        return emails;
    }
    

    
    
    public override void afterSend(List<MailSendStatus> results) {
        

    }

    

}