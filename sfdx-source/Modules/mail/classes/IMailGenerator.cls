public interface IMailGenerator {
    
    List<MailMessage> getMessages(List<Id> recordIds);
    
	MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds);
    
    void afterSend(List<MailSendStatus> results);
    
    void setData(Map<String,Object> data);
}