global class ProductConfirmationEmail extends MailGenerator {

    
    private OrderItem record;
    
      
    
    public ProductConfirmationEmail(OrderItem record) {
        this.record = record;
    }
    
    
    public ProductConfirmationEmail() {}
    
    
    
    public String getSubject() {
		return record.Product2.ConfirmationEmailSubject__c;
    }
    
    
    public String getBody() {
		return record.Product2.ConfirmationEmailBody__c;
    }
    
    public Id getWhoId() {
        return null == record.Contact__c ? record.Order.BillToContactId : record.Contact__c;
    }
    
    public Id getWhatId() {
        return record.Id;
    }
    
    public String getTo() {
        return null == record.Contact__c ? record.Order.BillToContact.Email : record.Contact__r.Email;
    }
    
    public List<String> getQueryFields() {
        return new List<String>{
            'Id',
            'Product2Id',
            'Order.BillToContactId','Order.BillToContact.Email',
            'PricebookEntryId',
            'Contact__c',
            'Contact__r.FirstName',
            'Contact__r.LastName',
            'Contact__r.Email',
            'Product2.ConfirmationEmailSubject__c',
            'Product2.ConfirmationEmailBody__c'
        };
        //FROM OrderItem WHERE Id = :this.recordIds
    }
    
    
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds) {
        
        MessageWhoIdWhatId whoIsIt;
        
        Id productId = recordIds[0];
        
        Account a = new Account(Name='My Test Account');
        insert a;
        
        Contact c = new Contact(FirstName = 'Jane',LastName='Doe',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
        
        PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :productId LIMIT 1];
        
        Order o = new Order(EffectiveDate=System.today(),Status='Draft',PriceBook2Id = ClickpdxCore.Application.config.getStdPriceBookId(),AccountId=a.Id);
        insert o;
        
        OrderItem line = new OrderItem(Contact__c=c.Id, LastName__c = c.LastName,OrderId=o.Id, PricebookEntryId = entry.Id, Quantity = 1.0,UnitPrice=1.00); 
        insert line;

        
        return new MessageWhoIdWhatId(c.Id,line.Id);
    }
    
      
    /*
     *  Should return a MailMessage object
     *   appropriate to this class.
     */
    public override List<MailMessage> getMessages(){
 
        List<OrderItem> lines;
        Id MY_KEN_MORROW_ID = 'a23VJ00000Efbzd'; // Temporary fix to use new email method for Ken Morrow tickets (Products).

        
        lines = [SELECT Id, Product2Id, Order.BillToContactId, Order.BillToContact.Email, PricebookEntryId, Contact__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                 Product2.EnableConfirmationEmails__c, Product2.ConfirmationEmailSubject__c, Product2.ConfirmationEmailBody__c FROM OrderItem WHERE Id = :this.recordIds];
        
        
		List<MailMessage> emails = new List<MailMessage>();

        for(OrderItem line :lines) {
            
            // Don't send an email if this functionality is disabled for the Product.
            if(!line.Product2.EnableConfirmationEmails__c) continue;
            
            ProductConfirmationEmail data = new ProductConfirmationEmail(line);
            // Each Product potentially has a template.  
            // Abstract the subject/body parts of the template into a template object.
            // This object can be used later.
  
            // In order of preferred templates.
            // If a template is specified for this specific product, use it.
            // If a template is provided for the Event, use that.
            // If both of those options are empty, use the legacy Subject and Body fields defined on the Product.
            MailMessageTemplate tpl1 = ProductConfirmationEmail.getMailMessageTemplate(line.Product2Id);
            MailMessageTemplate tpl2 = ProductConfirmationEmail.getParentMailMessageTemplate(line.Product2Id);
            MailMessageTemplate tpl3 = new MailMessageTemplate(data.getSubject(),data.getBody()); 
            
            
            MailMessageTemplate tpl = tpl1 ?? tpl2 ?? tpl3;
            if(null == tpl) {
                System.debug('PRODUCT_CONFIRM_ERROR: Confirm enabled but no confirmation email found.');
                continue;
            }
              
            MailMessage email = new MailMessage(data.getWhoId(), data.getWhatId());
            email.setTo(data.getTo());
			email.setTemplate(tpl);
            
            emails.add(email);
        }
        
        return emails;
    }

    
    public static MailMessageTemplate getParentMailMessageTemplate(Id product2Id) {
        Boolean hasEventTemplate = False;
        
        return hasEventTemplate ? new MailMessageTemplate('My subject', 'My <h1>HTML Body</h1>') : null;
    }
    

    
    public static MailMessageTemplate getMailMessageTemplate(Id product2Id) {
        
        
        List<MessageTemplate__c> emailTemplates = [SELECT Id, Subject__c, HtmlBody__c FROM MessageTemplate__c
            WHERE Name = 'Product Confirmation' AND Product2__c=:product2Id LIMIT 1];
        
        if(null == emailTemplates || emailTemplates.size() == 0) return null;
        
        String subject = emailTemplates[0].Subject__c;
        String body = emailTemplates[0].HtmlBody__c;
        
        return new MailMessageTemplate(subject,body);
    }
}