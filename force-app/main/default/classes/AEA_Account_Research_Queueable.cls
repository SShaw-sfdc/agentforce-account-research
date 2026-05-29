/**
 * Queueable job that launches the autolaunched Flow:
 * Agentforce_Account_Research_Report_Creator_Flow_AEA
 */
public class AEA_Account_Research_Queueable implements Queueable, Database.AllowsCallouts {

  private Id accountId;

  // Constructor
  public AEA_Account_Research_Queueable(Id accountId) {
    this.accountId = accountId;
  }

  // Execute method
  public void execute(QueueableContext context) {

    // Input variable map for the Flow
    Map<String, Object> params = new Map<String, Object>{
      'accountId' => accountId
    };

    // Instantiate and start the NEW AEA flow
    // Ensure the API Name matches your Flow's API Name exactly
    Flow.Interview.Agentforce_Account_Research_Report_Creator_Flow_AEA flow =
      new Flow.Interview.Agentforce_Account_Research_Report_Creator_Flow_AEA(params);

    flow.start();
  }
}