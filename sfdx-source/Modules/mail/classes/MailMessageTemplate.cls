public class MailMessageTemplate {

    private String body;
    
    
    private String subject;
    
    
    public MailMessageTemplate(String body) {
       this(body,null); 
    }
      
    public MailMessageTemplate(String subject, String body) {
        this.subject = subject;
        this.body = body;
    }
    
    public String mergeSubject(MailMessage mail) {
        return null == mail.getWhoId() ? mail.getSubject() : MailMessageFormatter.doMerge(this.getSubject(),mail.getWhoId(),mail.getWhatId());
    }
    
    public String mergeBody(MailMessage mail) {
        return null == mail.getWhoId() ? mail.getBody() : '<div style="font-size:12pt;">'+MailMessageFormatter.doMerge(this.getBody(),mail.getWhoId(),mail.getWhatId())+'</div>';
    }
    
    /**
     * Note: This is beta functionality and will overwrite the existing subject and body of
     *  the message, if any.
     */
    public static MailMessageTemplate fromSObject(String name) {
        
        MailTemplate__c tpl = [SELECT Id, Subject__c, HtmlBody__c  FROM MailTemplate__c
            WHERE Name = :name LIMIT 1];
        
        String subject = tpl.Subject__c;
        String body = tpl.HtmlBody__c;
        
        return new MailMessageTemplate(subject,body);
    }
    
    
    public String getBody() {
        return this.body;
    }
    
    
    public String getSubject() {
        return this.subject;
    }
}