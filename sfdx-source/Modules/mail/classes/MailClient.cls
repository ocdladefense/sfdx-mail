public class MailClient {

  	
    private MailMessage[] outbox = new MailMessage[]{};
    
        
    private Map<String,MailMessage[]> mboxes = new Map<String,MailMessage[]>{'outbox' => outbox};
        
        
	private MailClientSettings config;
    
        
 
  
    public MailClient() {
        this.config = new DefaultMailClientSettings();
    }

    public MailClient(MailClientSettings config) {
        this.config = config;
    }

    
    @testVisible
    private void reset(){
        this.deleteMailbox('outbox');
    }
    
    public void deleteMailbox(String mbox) {
        this.mboxes.put('outbox',new MailMessage[]{});
    }
    

    
    public void addMessages(List<MailMessage> emails) {
        for(MailMessage email : emails) {
            this.addMessage(email);
        }
    }
    
    public void addMessage(MailMessage msg) {
        this.outbox.add(msg);        
    }
     
    


    public String doEmailPreview(){
        String previewAll = '';
        
        for(MailMessage m :this.outbox){
            previewAll += '';//m.mergeBody();
        }
        
        return previewAll;
    }

 
    
    public MailMessage compose() {
     	return new MailMessage();
    }
    
    
    public MailMessage compose(String to) {
        
        MailMessage mail = new MailMessage();
        mail.setTo(to);
        
        return mail;
    }
    
    
    
 


 
    public List<MailSendStatus> send(MailMessage msg) {
        
        List<MailMessage> msgs = new List<MailMessage>();
        
        msgs.add(msg);
        
        return send(new MailMessageIterator(msgs));
    }

    
    public String useLetterhead(String content) {
        String letterhead = (String)config.get('letterhead');
        return null != letterhead ? letterhead.replace('{{content}}', content) : content; 
    }
    

    public List<MailSendStatus> send(MailGenerator custom) {
        
        MailMessageIterator queue = custom.iterator();
        return send(queue);
    }
        
    public List<MailSendStatus> send(MailMessageIterator messages) {
	    List<Messaging.SingleEmailMessage> out = new List<Messaging.SingleEmailMessage>();
            

        
        System.debug('Queue size is: ' +messages.size());
        
        
        while(messages.hasNext()) {
            MailMessage msg = messages.next();
            String body = useLetterhead(msg.getBody());
            msg.setBody(body);
            Messaging.SingleEmailMessage sforce = this.toSingleEmailMessage(msg);
              
            out.add(sforce);  
		}
        
        System.debug('SingleEmailMessage[] size is: ' +out.size());
            
		Messaging.SendEmailResult[] results = send(out);
        System.debug('Salesforce size is: '+results[0]);
        if(null == results || results.size() < 1) {
            throw new MailClientException('Empty!');
        }
        
        return MailSendStatus.fromSendEmailResults(out,results);
    }

    
    public List<MailSendStatus> send(List<MailMessage> messages) {
	    List<Messaging.SingleEmailMessage> out = new List<Messaging.SingleEmailMessage>();
            
        System.debug('Queue size is: ' +messages.size());
        
        
        for(MailMessage msg : messages) {
            
            String body = useLetterhead(msg.getBody());
            msg.setBody(body);
            Messaging.SingleEmailMessage sforce = this.toSingleEmailMessage(msg);
              
            out.add(sforce);  
		}
        
        System.debug('SingleEmailMessage[] size is: ' +out.size());
            
		Messaging.SendEmailResult[] results = send(out);
        System.debug('Salesforce size is: '+results[0]);
        if(null == results || results.size() < 1) {
            throw new MailClientException('Empty!');
        }
        
        return MailSendStatus.fromSendEmailResults(out,results);
    }

    
    
    public Messaging.SingleEmailMessage toSingleEmailMessage(MailMessage msg) {
        
        String senderDisplayName = (String)config.get('senderDisplayName');
        String senderDomain = (String)config.get('senderDomain');
        String ccAddress = (String)config.get('ccAddress');
        Id orgWideEmailAddressId = (Id)config.get('orgWideEmailAddressId');
        
    
        Messaging.SingleEmailMessage sforce = msg.toSingleEmailMessage();


        // sforce.setSenderDisplayName();
        // Necessary because in this implementation the merge has already happened.
        sforce.setTreatBodiesAsTemplate(False);
        sforce.saveAsActivity = False;
        String rand = '<'+ Math.random() + '@' + senderDomain + '>';
        sforce.setReferences(rand);
        sforce.setInReplyTo(rand);
        sforce.setReplyTo('info@ocdla.org');
        sforce.setCcAddresses(new List<String>{ccAddress});
        // sforce.setSenderDisplayName('OCDLA Orders');
        sforce.setOrgWideEmailAddressId(orgWideEmailAddressId);
        
        // For sampled records, avoid INVALID_CROSS_REFERENCE_ID exceptions.
        if(null != msg.getWhoId() && !msg.isSampled()) {
    		sforce.setTargetObjectId(msg.getWhoId());
        }

        // For sampled records, avoid INVALID_CROSS_REFERENCE_ID exceptions.        
        if(null != msg.getWhatId()  && !msg.isSampled()) {
        	sforce.setWhatId(msg.getWhatId());
        }
        
        return sforce;
    }
    
    public Messaging.SendEmailResult[] send(List<Messaging.SingleEmailMessage> theMessages){
        return Messaging.sendEmail(theMessages, (Boolean)config.get('allOrNothing'));
    }
 
		
    


    
    
    /**
     * For more information on setReferences see:
     *   https://tools.ietf.org/html/rfc2822#section-3.6.4
     * 
     */
    public Messaging.SingleEmailMessage toSingleEmailMessage(String to, String subject, String body, Id whoId){
        return toSingleEmailMessage(to,subject,body,whoId,null);
    }
    
   
    
    public Messaging.SingleEmailMessage toSingleEmailMessage(String to, String subject, String body, Id whoId, Id whatId){
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

        String senderDisplayName = (String)config.get('senderDisplayName');
        String senderDomain = (String)config.get('senderDomain');
        String ccAddress = (String)config.get('ccAddress');
        Id orgWideEmailAddressId = (Id)config.get('orgWideEmailAddressId');
        
        msg.setSubject(subject);
        msg.setToAddresses(new List<String>{to});
        msg.setCcAddresses(new List<String>{ccAddress});
        msg.setSenderDisplayName(senderDisplayName);
        msg.setHtmlBody(body);
        msg.setTreatBodiesAsTemplate(False); // Necessary because in this implementation the merge has already happened.
        msg.setTargetObjectId(whoId);
        msg.saveAsActivity = False;
        msg.setWhatId(whatId);
        String rand = '<'+ Math.random() + '@' + senderDomain + '>';
        msg.setReferences(rand);
        msg.setInReplyTo(rand); 
        
        return msg;
    }
    

    
    public List<MailMessage> getMailbox(String key) {
        
        return this.mboxes.get(key);
    }

        

    
    

    

    
    
}