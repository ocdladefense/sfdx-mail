global class MailSendStatus {
    
    webservice Boolean isSuccess = True;
    
    webservice DateTime dateSent;
    
    webservice String message;

    webservice String body;

    webservice String subject;
    
    webservice Id targetObjectId {get; set;}
    
    webservice Id whatId {get; set;}
    
    
    
    public MailSendStatus(){
        // Constructor
    }
    
    
    
    public static List<MailSendStatus> fromSendEmailResults(List<Messaging.SingleEmailMessage> messages, List<Messaging.SendEmailResult> results) {
        List<MailSendStatus> statuses = new List<MailSendStatus>();
        
        // The index of results should match the index of messages.
        Integer index = 0;
        
        for(Messaging.SendEmailResult result :results){
            MailSendStatus theStatus = new MailSendStatus();

            // Any errors associated with the Salesforce send operation for this message.
            List<Messaging.SendEmailError> theErrors;
        
            theStatus.targetObjectId = messages[index].getTargetObjectId();
            theStatus.whatId = messages[index].getWhatId();   
            theStatus.body = messages[index].getHtmlBody();
            theStatus.subject = messages[index].getSubject();
            theStatus.dateSent = System.now();

            if(!result.isSuccess()){
               	theErrors = result.getErrors();
                theStatus.isSuccess = False;
                theStatus.message = theErrors[0].getStatusCode() + ': '+theErrors[0].getMessage();
            } else {
                theStatus.isSuccess = True;
                theStatus.message = 'Email sent successfully.';
            }

         
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