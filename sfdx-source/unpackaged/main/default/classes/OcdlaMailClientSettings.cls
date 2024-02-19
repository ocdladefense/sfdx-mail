public class OcdlaMailClientSettings {

    public OcdlaMailClientSettings() {
        List<OrgWideEmailAddress> owa = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'OCDLA' LIMIT 1];
    }
}