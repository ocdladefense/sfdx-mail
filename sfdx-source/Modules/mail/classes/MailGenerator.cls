public abstract class MailGenerator implements Iterable<MailMessage> {

    protected List<Id> recordIds = new List<Id>();
    
	protected Map<String,Object> data = new Map<String,Object>();
    
	protected String tplName = null;

    
    

    
    public virtual void setTemplate(String name) {
        this.tplName = name;
    }
    
    public void setRecordIds(List<Id> recordIds) {
    	this.recordIds = recordIds;    
    }
    

    
    public abstract List<MailMessage> getMessages();
    
	public abstract MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds);
    
    public virtual void afterSend(List<MailSendStatus> results) {
        
    } 
    
    
    /**
     * The iterator performs processing during iteration.
     * In this case, if a template is chosen, it substitutes the merged template for the subject
     * and body of the emails.
     */
    public virtual MailMessageIterator iterator() {
        
        MailMessageTemplate tpl = null == this.tplName ? null : MailMessageTemplate.fromSObject(this.tplName);
        return null == tpl ? new MailMessageIterator(getMessages()) : new MailMessageIterator(getMessages(), tpl);
    }
}