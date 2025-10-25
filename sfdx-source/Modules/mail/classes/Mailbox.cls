public class Mailbox extends MailGenerator {

    private List<MailMessage> messages = new List<MailMessage>();
    
    
    
    
    public override List<MailMessage> getMessages() {
        return this.messages;
    }
    
    public void addMessage(MailMessage message) {
        this.messages.add(message);
    }
    
    
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds) {
        
        return new MessageWhoIdWhatId(null,null);
    }
}