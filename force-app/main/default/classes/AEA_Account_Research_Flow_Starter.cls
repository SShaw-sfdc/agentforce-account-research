/**
 * Launches the Agentforce_Account_Research_Report_Creator_Flow_AEA
 * for a specified Account via a Queueable job.
 */
public with sharing class AEA_Account_Research_Flow_Starter {

  @InvocableMethod(
    label       = 'Start AEA Account Research Report'
    description = 'Enqueues the AEA Research Flow for the given Account Id.'
  )
  public static List<String> startFlow(List<Id> accountIds) {

    List<String> results = new List<String>();

    for (Id accountId : accountIds) {

      // 1. Hand off to the NEW AEA Queueable job
      System.enqueueJob(new AEA_Account_Research_Queueable(accountId));

      // 2. Get the Account name for user-friendly feedback
      String accountName = [
        SELECT Name
        FROM  Account
        WHERE Id = :accountId
        LIMIT 1
      ].Name;

      // 3. Success toast sent back to Agentforce
      results.add(
        'I have successfully started an account research report on '
        + accountName
        + '. I will notify you when the Agent has finished the research. 🔔'
      );
    }

    return results;
  }
}