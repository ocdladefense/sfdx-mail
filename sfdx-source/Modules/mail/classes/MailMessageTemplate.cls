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
        String result;
          

        	result = null == mail.getWhoId() ? mail.getSubject() : MailMessageFormatter.doMerge(this.getSubject(),mail.getWhoId(),mail.getWhatId());
  
        
        return result;
    }
    
    public String mergeBody(MailMessage mail) {
        String result;
        
        try {
            result = null == mail.getWhoId() ? mail.getBody() : '<div style="font-size:12pt;">'+MailMessageFormatter.doMerge(this.getBody(),mail.getWhoId(),mail.getWhatId())+'</div>';
        } catch(System.EmailTemplateRenderException e) {
            MailMergeException ex = new MailMergeException(e);
            ex.setMessage(this.getSubject() + ', WhoId: ' + mail.getWhoId() + ', WhatId: '+ mail.getWhatId());
            
            System.debug(ex.getMessage());
            throw ex;
        }
        
        return result;
    }
    
    /**
     * Note: This is beta functionality and will overwrite the existing subject and body of
     *  the message, if any.
     */
    public static MailMessageTemplate fromSObject(String name) {
        
        MessageTemplate__c emailTemplate = [SELECT Id, Subject__c, HtmlBody__c  FROM MessageTemplate__c
            WHERE Name = :name LIMIT 1];
        
        String subject = emailTemplate.Subject__c;
        String body = emailTemplate.HtmlBody__c;
        
        return new MailMessageTemplate(subject,body);
    }
    
    
    public String getBody() {
        return this.body;
    }
    
    
    public String getSubject() {
        return this.subject;
    }
}