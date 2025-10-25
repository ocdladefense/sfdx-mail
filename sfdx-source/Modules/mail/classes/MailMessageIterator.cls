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
    
    
    
    public List<MailMessageIterator> split(Integer theLimit) {
        
        List<List<MailMessage>> chunks = new List<List<MailMessage>>();
        List<MailMessageIterator> iterators = new List<MailMessageIterator>();
        
        
        // Work on the chunks of objects.
        Integer chunkCounter = -1;

        for(Integer counter = 0; counter < this.messages.size(); counter++) {
            if(counter == 0 || Math.mod(counter, theLimit) == 0) {
                List<MailMessage> next = new List<MailMessage>();
                ++chunkCounter;
                chunks.add(next);
            }
            chunks[chunkCounter].add(this.messages[counter]);    
        }
        
        // Build the iterators from those chunks.
        for(Integer chunkIndex = 0; chunkIndex < chunks.size(); chunkIndex++) {
			MailMessageIterator it = new MailMessageIterator(chunks[chunkIndex], this.tpl);
            iterators.add(it);
        }
        
        return iterators;
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
	 * before being processed by the MailClient.
	 */
	public MailMessage next(){
       if(hasNext()) {
           MailMessage msg = messages[currentIndex++];
           
           MailMessageTemplate tpl = null != msg.getTemplate() ? msg.getTemplate() : this.tpl;
           

           if(null == tpl) return msg; // This limits merging to the use of Templates!
           
           // Otherwise assume that templates may have merge fields and attempt to merge based on whoId/whatId.
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