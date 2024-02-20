public class MailMessage {

    
    private Id whoId;
      
    private Id whatId;
    
    private String subject;
    
    private String body;
    
    private String to;
    
    private Boolean sampled = False;
    
    // When True, indicates that the message should not be sent, either using
    // a targetObjectId or a To: addressed to a real customer,
    // but instead should be overridden typically with the email of the given user.
    private Boolean isTestMessage = False;
    
    private MailMessageTemplate template;
    
    


    // Default constructor.
    public MailMessage() {}
    
    
    public MailMessage(Id contactId) {
        this.whoId = contactId;
    }
    
    
    public MailMessage(String to, String subject, String body) {
        this.to = to;
		this.subject = subject;
        this.body = body;
    }
    
    
    public MailMessage(Id whoId, Id whatId, String subject, String body) {
        this.whoId = whoId;
        this.whatId = whatId;
        this.subject = subject;
        this.body = body;
    }
    
    
    public MailMessage(Id whoId, Id whatId) {
        this.whoId = whoId;
        this.whatId = whatId;
    }
    
    

    
    
    // Important when creating mock records that will be rolled back.
    // This is used by the MailClient to make sure whoId/whatId are not attached to the mail message,
    // as Sfdc validates these ids at send time.
    public void setSampled(Boolean isSampled) {
        this.sampled = isSampled;
    }
    
    public void setTest(Boolean isTest) {
        this.isTestMessage = isTest;
    }
    
    public Boolean isTest() {
        return this.isTestMessage;
    }
    
    public Boolean isSampled() {
        return this.sampled;
    }
    
    
    public void setTemplate(MailMessageTemplate tpl) {
        this.template = tpl;
    }
    
    
    public MailMessageTemplate getTemplate() {
        return this.template;
    }
    

    public Id getWhoId() {
        return this.whoId;
    }
    
    
    public Id getWhatId() {
        return this.whatId;
    }
    
    
    public String getSubject() {
        return this.subject;
    }
    
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    
    public String getBody() {
        return this.body;
    }
    
    
    public void setBody(String body) {
        this.body = body;
    }
    
    
    public void setTo(String email) {
        this.to = email;
    }
    
    
    public String getTo() {
        return this.to;
    }
    
    
    


   
    
}