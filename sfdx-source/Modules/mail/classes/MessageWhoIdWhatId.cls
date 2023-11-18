public class MessageWhoIdWhatId {
    private Id whoId;
    
    private Id whatId;
    
    public MessageWhoIdWhatId(Id whoId, Id whatId) {
        this.whoId = whoId;
        this.whatId = whatId;
    }
    
    public Id getWhoId() {
        return this.whoId;
    }
    
    public Id getWhatId() {
        return this.whatId;
    }
}