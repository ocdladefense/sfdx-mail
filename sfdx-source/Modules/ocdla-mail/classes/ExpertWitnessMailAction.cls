public class ExpertWitnessMailAction implements IMailEventAction {
    
    public void afterSend(List<MailSendStatus> results) {
        
		List<Contact> affectedContacts = new List<Contact>();
         
        for(MailSendStatus status :results) {
            Contact c = new Contact(Id=status.targetObjectId);
            if(status.isSuccess) {
                c.ExpertWitnessUpdateEmailSent__c = True;
                c.ExpertWitnessUpdateDateSent__c = System.now();
            }
            else {
               c.MailStatus__c = status.message;
            }
            
            affectedContacts.add(c);
        }  
        
        update affectedContacts;
    }
}