@IsTest
private class TestSmartfridgeActions {
    @IsTest
    static void TestSendNotificationEmails() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(
            FirstName = 'foo',
            LastName = 'bar',
            Email = 'foo@bar.com',
            Username = 'foo@testbar.com',
            Alias = 'foo',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US');
        insert(u);
        Case c = new Case(Subject = 'Test Case', OwnerId = u.Id);
        List<Case> cases = new List<Case>();
        cases.add(c);
        insert(cases);
        
        Test.startTest();
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
 
        SmartfridgeActions.sendNotificationEmail(cases);
 
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
        Test.stopTest();
    }
}
