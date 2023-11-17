public class MailMessageIterator implements Iterator<MailMessage> {

    private List<MailMessage> messages;
    
    private Integer currentIndex;
    
    // If set, use this template rather than
    // that attached to the message.
    private MailMessageTemplate tpl;
      
    
    public List<MailMessage> getMessages() {
        return this.messages;
    }
    
   public MailMessageIterator(List<MailMessage> messages){
       this.messages = messages;
       this.currentIndex = 0;
   }  
    
    public void reset() {
        this.currentIndex = 0;
    }
    
   public MailMessageIterator(List<MailMessage> messages, MailMessageTemplate tpl){
       this.messages = messages;
       this.tpl = tpl;
       this.currentIndex = 0;
   }  
    
	
    public void setTemplate(MailMessageTemplate tpl) {
        this.tpl = tpl;
    }
    

 
   public Boolean hasNext() { 
       return currentIndex < messages.size();
   }    
    
    public Integer size() {
        return messages.size();
    }
 
    
	/**	
	 * Each outgoing message from the next() queue
	 * Will be automatically merged into its template
	 * before processed by the MailClient.
	 */
	public MailMessage next(){
       if(hasNext()) {
           MailMessage msg = messages[currentIndex++];
           
           MailMessageTemplate tpl;
           
           if(null != this.tpl) {
               tpl = this.tpl;
           } else if(null != msg.getTemplate()) {
               tpl = msg.getTemplate();
           }
           
           
           if(null == tpl) return msg;
           
           
           String subject = tpl.mergeSubject(msg);
           String body = tpl.mergeBody(msg);
           msg.setSubject(subject);
           msg.setBody(body);
           
           return msg;
           
       } else {
           throw new NoSuchElementException('Iterator has no more elements.');
       }
   } 
    
}