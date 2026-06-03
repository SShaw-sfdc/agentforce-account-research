@isTest
private class AEA_Account_Research_Flow_Starter_Test {

    @isTest
    static void testStartFlowReturnsConfirmation() {
        Account testAccount = new Account(Name = 'Test Corp');
        insert testAccount;

        List<String> results;
        try {
            Test.startTest();
            results = AEA_Account_Research_Flow_Starter.startFlow(
                new List<Id>{ testAccount.Id }
            );
            Test.stopTest();
        } catch (System.FlowException e) {
            // Expected: Queueable fires the flow which needs prompt template inputs
        }

        System.assertNotEquals(null, results, 'Results should be returned before async execution');
        System.assertEquals(1, results.size());
        System.assert(
            results[0].contains('Test Corp'),
            'Result should contain the account name'
        );
        System.assert(
            results[0].contains('started an account research report'),
            'Result should confirm research was started'
        );
    }

}
