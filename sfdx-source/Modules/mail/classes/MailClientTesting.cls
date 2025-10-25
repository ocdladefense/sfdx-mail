public without sharing class MailClientTesting extends MailClientBase {

    
    
    private static String TO_EMAIL_OVERRIDE = 'jbernal.web.dev@gmail.com';

    private MailMessage[] outbox = new MailMessage[]{};
      
    private Map<String,MailMessage[]> mboxes = new Map<String,MailMessage[]>{'outbox' => outbox};

    
        
 
  
    public MailClientTesting() {
        super();
    }
    

    
    static IMailEventAction getEmailEventActionInstance(MailApiConfig config) {
       
        Type t;
        IMailEventAction afterSend;
        
        if(null == config.afterSend) return null;
        
        t = Type.forName(config.afterSend);
        
        if(null == t) return null;
        
        return (IMailEventAction)t.newInstance();
    }
    


    

    
    public override List<MailSendStatus> send(MailGenerator custom) {
        
        MailMessageIterator queue = custom.iterator();
        return send(queue);
        
        /*
         *         
        // If an explicit afterSend class was specified we MUST use that.
        IMailEventAction mailEvent;// = getEmailEventActionInstance(config);
        if(null != mailEvent) {
            mailEvent.afterSend(theResults);
        } else {
        	generator.afterSend(theResults);
        }
*/
    }

    
  
    
    
    public override List<MailSendStatus> send(MailMessageIterator queue) {
	    List<Messaging.SingleEmailMessage> out = new List<Messaging.SingleEmailMessage>();

        System.debug('Queue size is: ' +queue.size());
        
        
        while(queue.hasNext()) {
            MailMessage msg = queue.next();
            String body = useLetterhead(msg.getBody());
            msg.setBody(body);
            msg.setTest(True);
            msg.setTo(TO_EMAIL_OVERRIDE);
            Messaging.SingleEmailMessage sforce = this.toSingleEmailMessage(msg);
              
            out.add(sforce);  
		}
        
        System.debug('SingleEmailMessage[] size is: ' +out.size());
            
		Messaging.SendEmailResult[] results = send(out);
        
        // System.debug('Salesforce size is: '+results[0]);
        if(null == results || results.size() < 1) {
            throw new MailClientException('Empty!');
        }
        
        return MailSendStatus.fromSendEmailResults(out,results);
    }

    
    public override List<MailSendStatus> send(List<MailMessage> messages) {
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
        
        MailSendStatus[] theResults = MailSendStatus.fromSendEmailResults(out,results);

        
        return theResults;
    }

    
    
		
    

    /**
     * For more information on setReferences see:
     *   https://tools.ietf.org/html/rfc2822#section-3.6.4
     * 
     */
    public override Messaging.SingleEmailMessage toSingleEmailMessage(MailMessage msg) {
        
        String senderDisplayName = (String)config.get('senderDisplayName');
        String senderDomain = (String)config.get('senderDomain');
        // String ccAddress = (String)config.get('ccAddress');
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
        // sforce.setCcAddresses(new List<String>{ccAddress});
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
        
        // Remove the condition as this testing client should never treat the target object as recipient.
        if(True || msg.isTest()) {
        	sforce.setTreatTargetObjectAsRecipient(False);
        }
        
        return sforce;
    }
    
    

  

    
    public List<MailMessage> getMailbox(String key) {
        
        return this.mboxes.get(key);
    }


    

    

    
    
}