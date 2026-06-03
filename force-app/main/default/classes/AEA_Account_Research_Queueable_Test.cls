@isTest
private class AEA_Account_Research_Queueable_Test {

    @isTest
    static void testQueueableCanBeConstructed() {
        Account testAccount = new Account(Name = 'Test Corp');
        insert testAccount;

        AEA_Account_Research_Queueable job = new AEA_Account_Research_Queueable(testAccount.Id);
        System.assertNotEquals(null, job, 'Queueable should be constructable with an Account Id');
    }

    @isTest
    static void testQueueableExecuteCallsFlow() {
        Account testAccount = new Account(Name = 'Test Corp');
        insert testAccount;

        AEA_Account_Research_Queueable job = new AEA_Account_Research_Queueable(testAccount.Id);

        try {
            Test.startTest();
            System.enqueueJob(job);
            Test.stopTest();
            System.assert(false, 'Expected FlowException due to missing prompt template inputs');
        } catch (System.FlowException e) {
            System.assert(
                e.getMessage().contains('Missing required input parameter'),
                'Flow should fail due to missing prompt template inputs in test context'
            );
        }
    }
}
