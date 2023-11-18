public class DefaultMailClientSettings extends MailClientSettings {


    public DefaultMailClientSettings() {

        this.config = new Map<String,Object>();
        this.config.put('leaderheadName','OcdlaEmailLetterhead');
        this.config.put('orgWideEmailAddressId',null);
        this.config.put('senderDisplayName','MyOrg');
        this.config.put('senderDomain','default.my.site.com');
        this.config.put('ccAddress','admin@default.my.site.com');
        this.config.put('allOrNothing',True);
        this.config.put('letterhead','OcdlaEmailLetterhead');
    }

    public override String getLetterhead() {
        return 'OcdlaEmailLetterhead';
    }
}