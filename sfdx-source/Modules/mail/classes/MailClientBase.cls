public abstract class MailClientBase {


	protected MailClientSettings config;
    
    private static Integer MAX_ASYNC_QUEUE_SIZE = 10;
 
  
    public MailClientBase() {
        this.config = new MailClientSettings();
    }

    
    public MailMessage compose() {
     	return new MailMessage();
    }
    
    
    public MailMessage compose(String to) {
        
        MailMessage mail = new MailMessage();
        mail.setTo(to);
        
        return mail;
    }
    
    
    public String useLetterhead(String content) {
        String letterhead = (String)config.get('letterhead');
        return null != letterhead ? letterhead.replace('{{content}}', content) : content; 
    }
 


 
    public List<MailSendStatus> send(MailMessage msg) {
        
        List<MailMessage> msgs = new List<MailMessage>();
        
        msgs.add(msg);
        
        return send(new MailMessageIterator(msgs));
    }

    
    public List<Id> sendAsync(MailGenerator custom) {
        
        List<Id> jobIds = new List<Id>();
        
        MailMessageIterator queue = custom.iterator();
        
        List<MailMessageIterator> queues = queue.split(MAX_ASYNC_QUEUE_SIZE);
        
        System.debug('Number of queues is: ' + queues.size());
        
        // List<MailSendStatus> statuses = new List<MailSendStatus>();
        
        for(Integer i = 0; i<queues.size(); i++) {
            Id jobId = System.enqueueJob(new SendMailBatch(queues[i], this));
            jobIds.add(jobId);
        }
        
        return jobIds;
    }
    

    public abstract List<MailSendStatus> send(MailGenerator custom);
       
    
    public abstract List<MailSendStatus> send(MailMessageIterator messages);

    
    public abstract List<MailSendStatus> send(List<MailMessage> messages);

    
    

    
    public Messaging.SendEmailResult[] send(List<Messaging.SingleEmailMessage> theMessages){
        return Messaging.sendEmail(theMessages, (Boolean)config.get('allOrNothing'));
    }
 
		
    


    public abstract Messaging.SingleEmailMessage toSingleEmailMessage(MailMessage msg);
    
    

        

    public String serialize(MailMessage msg) {
        return this.serialize(this.toSingleEmailMessage(msg));
    }
    
    
    
    public String serialize(Messaging.SingleEmailMessage sfdc) {
       
        String fooby = JSON.serialize(sfdc, True);
        Map<String,Object> obj = (Map<String,Object>)JSON.deserializeUntyped(fooby);

        for(String key : obj.keySet()) {
            System.debug(key + ': '+obj.get(key));
        }
        
        return JSON.serialize(obj, True);
    }
    
    
    public virtual void afterSend(List<MailSendStatus> results) {}
    

    
    
}