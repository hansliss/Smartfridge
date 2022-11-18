public with sharing class SmartfridgeActions {
    @InvocableMethod(iconName='slds:standard:email' label='Send Notification Email' description='Sends a notification email using a named email template.' category='Case')
    public static void sendNotificationEmail(List<Case> cases) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName = 'Notify_Smartfridge_owner'];
        for (Case c : cases) {
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemp.Id, c.OwnerId, c.Id);
            List<User> rusers = [select Id,Email from User where Id = :c.OwnerId];
            List<String> recipients = new List<String>();
            for (User r : rusers) {
                recipients.add(r.Email);
            }
            //System.debug(recipients);

            String emailSubject = email.getSubject();
            String emailTextBody = email.getPlainTextBody();
            String emailHTMLBody = email.getHtmlBody();

            //email.setTargetObjectId(c.OwnerId);
            email.setTreatTargetObjectAsRecipient(false);
            
            email.setSubject(emailSubject);
            email.setPlainTextBody(emailTextBody);
            email.setHtmlBody(emailHTMLBody);
            email.setSaveAsActivity(false);
            email.setToAddresses(recipients);
            emailList.add(email);
        }
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }    
    }
}