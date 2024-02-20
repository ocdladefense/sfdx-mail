WORK


NEXT UP: 
 - Latest installation URL is: https://login.salesforce.com/packaging/installPackage.apexp?p0=04tVJ0000001PArYAM
 - Review used config, especially around Letterhead in DefaultMailClientSettings.class.


TEST CLASSES
ClickpdxMailTest, OcdlaAttendeeTest, ClickpdxOrderItemsTest, ProductConfirmationEmailTest, ContactEmailTest



THESE CLASSES WILL NEED TO BE UPDATED
 - DELETE - ClickpdxStoreProductConfirmation (done on Sandbox, Production)
 - DELETE - TestClickpdxStoreProductConfirmation (done on Sandbox, Production)
  - NOTE - Find out how Letterheads are used; relevant classes to check would be:
    --> These are used in Test classes.  Revised on Sandbox and need to be uploaded to Production:
     - ClickpdxMailTest
     - OcdlaAttendeeTest
     - ClickpdxOrderItemsTest
     - ProductConfirmationEmailTest
     - ContactEmailTest


CLASS OVERVIEW
- AttendeeConfirmationEmail
- ContactEmail
- ContactEmailTest
- ExpertWitnessMailAction
- MembershipRenewalMailAction
- ProductConfirmationEmail
- ProductConfirmationEmailTest
- OcdlaMail




**DONE
IMailEventAction.afterSend... property should be renamed to to eventHandler for beforeSend, afterSend.
IMailEventAction.beforeSend... this property needs to be added.
(idea how to query for mailmessages considering the email report can query for them)


DONE - Create a new SObject MessageTemplate__c with its respective fields.
DONE - update the MailMessageTemplate class to use the new SObject.
DONE - Modify the Production instance: copy over records from OcdlaEmailTemplate__c to MailTemplate__c
