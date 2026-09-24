public class EventManagerEmail extends MailGenerator {
    

    // Id of the Event from which to draw records.
    private Id eventId;
    
    
    
    public EventManagerEmail(Id eventId) {
        super();
        this.eventId = eventId;
    }
    
    
    public EventManagerEmail() {
        super();
    }
      
      
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds) {
        
        MessageWhoIdWhatId whoIsIt;
        
        return whoIsIt;
    }
    

      
    
    /*
     *  Should return a EmailMessage object
     *   appropriate to this class.
     */
    public override List<MailMessage> getMessages() {
 
        List<Id> eventIds = new List<Id>();
		List<Registration__c> regs;
        
        
        regs = [SELECT Id, Contact__c, Event__c FROM Registration__c WHERE Id = :this.recordIds];


		List<MailMessage> emails = new List<MailMessage>();

        
        for(Registration__c reg :regs) {
            MailMessage email;
        	Id whoId = reg.Contact__c;
            Id whatId = reg.Id;
            email = new MailMessage(whoId, whatId);
            emails.add(email);
        }
        
        return emails;
    }
    
    
    

}