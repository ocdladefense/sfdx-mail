public virtual class MailClientSettings {

    
    private Map<String,Object> config = new Map<String,Object>();
    

    
    
    public MailClientSettings(Map<String,Object> config) {
		this.config = config;   
    }
    
    public MailClientSettings() {
        this.config = new Map<String,Object>();
        String letterhead;
        OrgWideEmailAddress owa = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'OCDLA' LIMIT 1];
        this.config.put('leaderheadName','OcdlaEmailLetterhead');
        this.config.put('orgWideEmailAddressId',owa.Id);
        this.config.put('senderDisplayName','OCDLA');
        this.config.put('senderDomain','ocdla.my.site.com');
        this.config.put('ccAddress','admin@ocdla.org');
        this.config.put('allOrNothing',False);
        
        letterhead = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName = 'OcdlaEmailLetterhead' LIMIT 1].ClickpdxCore__Value__c;
		this.config.put('letterhead',letterhead);
    }
    
    public Object get(String key) {
        return this.config.get(key);
    }
}