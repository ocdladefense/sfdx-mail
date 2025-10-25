public class SendMailBatch implements Queueable, Finalizer {

    // Instance of MailClient that will be used to send the email.
    public MailClientBase client;
    
    // Iterator used to generate the MailMessages.
    public MailMessageIterator queue;
    
    
    public SendMailBatch(MailMessageIterator queue, MailClientBase client) {
        this.queue = queue;
        this.client = client;
    }
    
    
    public void execute(QueueableContext context) {
		MailSendStatus[] results = this.client.send(this.queue);
    }
    
    
    public void execute(FinalizerContext context) {
        
        
    }
    
    
}