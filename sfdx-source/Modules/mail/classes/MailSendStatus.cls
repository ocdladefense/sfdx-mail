global class MailSendStatus {
    
    webservice Boolean isSuccess = True;
    
    webservice DateTime dateSent;
    
    webservice String message;
    
    webservice Id targetObjectId {get; set;}
    
    webservice Id whatId {get; set;}
    
    
    
    public MailSendStatus(){}
    
    
    
    public static List<MailSendStatus> fromSendEmailResults(List<Messaging.SingleEmailMessage> messages, List<Messaging.SendEmailResult> results) {
        List<MailSendStatus> statuses = new List<MailSendStatus>();
        
        Integer index = 0;
        for(Messaging.SendEmailResult result :results){
            MailSendStatus theStatus = new MailSendStatus();
            List<Messaging.SendEmailError> theErrors;
            
            if(!result.isSuccess()){
               	theErrors = result.getErrors();
                
                theStatus.isSuccess = False;
                theStatus.targetObjectId = theErrors[0].getTargetObjectId();
                theStatus.message = theErrors[0].getStatusCode() + ': '+theErrors[0].getMessage();

            } else {
                theStatus.isSuccess = True;
                theStatus.targetObjectId = messages[index].getTargetObjectId();
            }

            theStatus.whatId = messages[index].getWhatId();            
            statuses.add(theStatus);
            index++;
        }
        
        if(results.size() != statuses.size()) {
            throw new MailSendException('Status array is discordant.');
        }
        
        return statuses;
    }
    
    private class MailSendException extends Exception {}
}