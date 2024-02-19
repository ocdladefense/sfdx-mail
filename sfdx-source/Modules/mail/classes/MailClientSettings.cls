public abstract class MailClientSettings {

    
    protected Map<String,Object> config = new Map<String,Object>();
    

    protected List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();


    protected String fromAddress;


    protected Id orgWideEmailAddressId;
    
    


    public MailClientSettings(Map<String,Object> config) {
		  this.config = config;   
    }
    
    public virtual void setFrom(String address) {
        this.fromAddress = address;
    }

    public MailClientSettings() {

        List<OrgWideEmailAddress> owa = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress LIMIT 1];

        this.orgWideEmailAddressId = owa.size() > 0 ? owa[0].Id : null;
        /*
        this.config = new Map<String,Object>();
        String letterhead;
        List<OrgWideEmailAddress> owa = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'OCDLA' LIMIT 1];
        this.config.put('leaderheadName','OcdlaEmailLetterhead');
        this.config.put('orgWideEmailAddressId',owa.Id);
        this.config.put('senderDisplayName','OCDLA');
        this.config.put('senderDomain','ocdla.my.site.com');
        this.config.put('ccAddress','admin@ocdla.org');
        this.config.put('allOrNothing',True);
        
        letterhead = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName = 'OcdlaEmailLetterhead' LIMIT 1].ClickpdxCore__Value__c;
		    this.config.put('letterhead',letterhead);
        */
    }
    
    public Object get(String key) {
        return this.config.get(key);
    }

    public abstract String getLetterhead();


    /*
    The optional opt_allOrNone parameter specifies whether sendEmail prevents delivery of all other messages when any of the messages fail due to an error (true), or whether it allows delivery of the messages that don't have errors (false). The default is true.
    */
    public virtual Boolean getAllOrNothing() {
        return False;
    }

    public virtual String getReplyToAddress() {
        return null; //'info@ocdla.org'
    }

    public virtual Id getOrgWideEmailAddressId() {
        return this.orgWideEmailAddressId;//config.get('orgWideEmailAddressId');
    }

    public virtual List<String> getCcAddresses() {
        return new List<String>();
    }

    public virtual String getInReplyTo() {
        return '<'+ Math.random() + '@' + this.getFromAddressDomain() + '>';
    }

    public virtual String getReferences() {
        return '<'+ Math.random() + '@' + this.getFromAddressDomain() + '>';
    }

    public virtual String getFromAddressDomain() {
        String fromAddress = this.getFromAddress();
        if(null == fromAddress) {
            throw new MailClientException('CONFIGURATION_ERROR: From address is required in order to send email.');
        }
        String[] parts = fromAddress.split('\\@');

        if(parts.size() != 2) {
            throw new MailClientException('CONFIGURATION_ERROR: From address must be in a valid format.');
        }

        return parts[1];
    }

    public virtual String getFromAddress() {
        return 'info@ocdla.org';
    }

    public virtual String getSenderDisplayName() {
        return null;
        // String senderDisplayName = (String)config.get('senderDisplayName');
    }
}