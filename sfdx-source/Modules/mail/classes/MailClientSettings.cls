public virtual class MailClientSettings {

    
    protected Map<String,Object> config = new Map<String,Object>();
    

    
    
    public MailClientSettings(Map<String,Object> config) {
		  this.config = config;   
    }
    
    public MailClientSettings() {
        this.config = new Map<String,Object>();
        String letterheadName = 'OcdlaEmailLetterhead';
        String letterhead;

        OrgWideEmailAddress owa;
        
        try {
          owa = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'OCDLA' LIMIT 1];
        } catch(System.QueryException e) {
          owa = null;
        }

        this.config.put('leaderheadName', letterheadName);
        this.config.put('orgWideEmailAddressId', null == owa ? null : owa.Id);
        this.config.put('senderDisplayName', 'OCDLA');
        this.config.put('senderDomain', 'ocdla.my.site.com');
        this.config.put('ccAddress', 'admin@ocdla.org');
        this.config.put('allOrNothing', False);
        
        try {
          List<SObject> records = Database.query('SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt WHERE DeveloperName = :letterheadName LIMIT 1');
          letterhead = (String)records[0].get('ClickpdxCore__Value__c');
        } catch(Exception e) {
            letterhead = 'Your branded email content: {{content}}.';
        }

		    this.config.put('letterhead',letterhead);
    }
    
    public Object get(String key) {
        return this.config.get(key);
    }
}