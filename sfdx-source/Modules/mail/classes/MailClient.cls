public class MailClient extends MailClientBase {

    	
    private MailMessage[] outbox = new MailMessage[]{};
    
        
    private Map<String,MailMessage[]> mboxes = new Map<String,MailMessage[]>{'outbox' => outbox};
 
   
  
    public MailClient() {
        super();
        this.config = new MailClientSettings();
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
     
    


    public override List<MailSendStatus> send(MailGenerator custom) {
        
        MailMessageIterator queue = custom.iterator();
        return send(queue);
    }
        
    public override List<MailSendStatus> send(MailMessageIterator messages) {
	    List<Messaging.SingleEmailMessage> out = new List<Messaging.SingleEmailMessage>();
            

        if(null == messages || messages.size() == 0) {
        	throw new MailClientException('NO_MAIL_MESSAGES: There are no messages in the queue.');
        }
        
        while(messages.hasNext()) {
            MailMessage msg = messages.next();
            String body = useLetterhead(msg.getBody());
            msg.setBody(body);
            Messaging.SingleEmailMessage sforce = this.toSingleEmailMessage(msg);
              
            out.add(sforce);  
		}
        

            
		Messaging.SendEmailResult[] results = send(out);

        
        List<MailSendStatus> statuses = MailSendStatus.fromSendEmailResults(out,results);
        this.afterSend(statuses);
        return statuses;
    }

    
    public override List<MailSendStatus> send(List<MailMessage> messages) {
	    List<Messaging.SingleEmailMessage> out = new List<Messaging.SingleEmailMessage>();
            
        if(null == messages || messages.size() == 0) {
        	throw new MailClientException('NO_MAIL_MESSAGES: There are no messages in the queue.');
        }
        
        
        for(MailMessage msg : messages) {
            
            String body = useLetterhead(msg.getBody());
            msg.setBody(body);
            Messaging.SingleEmailMessage sforce = this.toSingleEmailMessage(msg);
              
            out.add(sforce);  
		}

            
		Messaging.SendEmailResult[] results = send(out);

        
        List<MailSendStatus> statuses = MailSendStatus.fromSendEmailResults(out,results);
        this.afterSend(statuses);
        return statuses;
    }

    
    
    public override void afterSend(List<MailSendStatus> results) {
        
		List<MailMessage__c> messages = new List<MailMessage__c>();
         
        for(MailSendStatus status :results) {
            Id contactId = status.targetObjectId;
            
            if(null == contactId) continue;
            
            //try {
                MailMessage__c m = new MailMessage__c(Contact__c=status.targetObjectId, 
                                                      Subject__c=status.subject,
                                                      Body__c=status.body,
                                                      DateSent__c=status.dateSent,
                                                      Status__c=status.message);
                                                      m.Name = status.subject + ' - ' + status.dateSent.format();
                
                messages.add(m);
            //} catch(System.DmlException e) {
            //    continue;
            //}
        }  
        
        insert messages;
    }    



    public override Messaging.SingleEmailMessage toSingleEmailMessage(MailMessage msg) {
        
        String senderDisplayName = (String)config.get('senderDisplayName');
        String senderDomain = (String)config.get('senderDomain');
        String ccAddress = (String)config.get('ccAddress');
        Id orgWideEmailAddressId = null != config.get('orgWideEmailAddressId') ? (Id)config.get('orgWideEmailAddressId') : null;
        
    
        Messaging.SingleEmailMessage sforce = new Messaging.SingleEmailMessage();
        sforce.setSubject(msg.getSubject());    
        sforce.setHtmlBody(msg.getBody());
        
        // Set an explicit to address; see below to not set the whatId in this case.
        if(null != msg.getTo()) {
            sforce.setToAddresses(new List<String>{msg.getTo()});
        }

        // sforce.setSenderDisplayName();
        // Neccessary because in this implementation the merge has already happened.
        sforce.setTreatBodiesAsTemplate(False);
        sforce.saveAsActivity = False;
        String rand = '<'+ Math.random() + '@' + senderDomain + '>';
        sforce.setReferences(rand);
        sforce.setInReplyTo(rand);
        sforce.setCcAddresses(new List<String>{ccAddress});
        sforce.setSenderDisplayName(null);
        
        if(msg.hasFileAttachments()) {
            sforce.setFileAttachments(msg.getFileAttachments());
        }
        
        
        if(null != orgWideEmailAddressId) {
            sforce.setOrgWideEmailAddressId(orgWideEmailAddressId);
        }
        
        // For sampled records, avoid INVALID_CROSS_REFERENCE_ID exceptions.
        if(null != msg.getWhoId() && !msg.isSampled()) {
            sforce.setTargetObjectId(msg.getWhoId());
        }

        // For sampled records, avoid INVALID_CROSS_REFERENCE_ID exceptions.        
        if(null != msg.getWhatId() && !msg.isSampled()) {
        	sforce.setWhatId(msg.getWhatId());
        }
        
        if(msg.isTest()) {
        	sforce.setTreatTargetObjectAsRecipient(False);
        }
        
        return sforce;
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