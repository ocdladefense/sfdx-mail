public class MailMessage {

    
    private Id whoId;
     
    private Id whatId;
    
    private String subject;
    
    private String body;
    
    private String to;
    
    private Boolean sampled = False;
    
    private MailMessageTemplate template;
    
    
    // Important when creating mock records that will be rolled back.
    // This is used by the MailClient to make sure whoId/whatId are not attached to the mail message,
    // as Sfdc validates these ids at send time.
    public void setSampled(Boolean isSampled) {
        this.sampled = isSampled;
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
    
    public MailMessage() {
        
    }
    
    
    /**
     * For more information on setReferences see:
     *   https://tools.ietf.org/html/rfc2822#section-3.6.4
     * 
     */
    public static Messaging.SingleEmailMessage toSingleEmailMessage(MailMessage email){
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

        msg.setSubject(email.getSubject());    
        msg.setHtmlBody(email.getBody());
        
        // Set an explicit to address; see below to not set the whatId in this case.
        if(null != email.getTo()) {
            msg.setToAddresses(new List<String>{email.getTo()});
        }
        
        // For sampled records, avoid INVALID_CROSS_REFERENCE_ID exceptions.
        if(null == email.getTo() && !email.isSampled()) {
        	msg.setTargetObjectId(email.getWhoId());
        }
        
        // For sampled records, avoid INVALID_CROSS_REFERENCE_ID exceptions.
        if(null != email.getWhatId() && !email.isSampled()) {
        	msg.setWhatId(email.getWhatId());
        }
        
        return msg;
    }
    
    public Messaging.SingleEmailMessage toSingleEmailMessage() {
        return toSingleEmailMessage(this);
    }
   
    
}