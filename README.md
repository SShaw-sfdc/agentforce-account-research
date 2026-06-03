# Agentforce - Account Research with AEA

An unmanaged Salesforce package that enables Agentforce to perform deep account research using a multi-agent system. An Agentforce Employee Agent acts as a "Researcher Sub-Agent," performing recursive web searches, analyzing findings, and returning structured intelligence to a backend automation flow.

## Architecture

1. **Trigger** - A user asks their Agent (e.g., "Run a deep dive on Acme Corp") in the chat window.
2. **Orchestration** - The Agent identifies the Account ID and hands off the request to an asynchronous background process (Queueable Apex).
3. **Recursive Research** - A Flow launches and calls the Employee Agent multiple times. For each section of the report (News, Strategy, Competitors), the Agent uses the "Search the Web" action to find live data.
4. **Synthesis** - Generative AI Prompt Templates transform the Agent's research notes into a polished, HTML-formatted report.
5. **Delivery** - The final report is saved to a custom object and the user is notified via the bell icon.

## Package Components

| Type | Components |
|------|-----------|
| Apex Classes | `AEA_Account_Research_Flow_Starter`, `AEA_Account_Research_Queueable` |
| Flows | `Agentforce_Account_Research_Report_Creator_Flow_AEA`, `Agentforce_Account_Research_Task`, `Agentforce_Account_Research_Report_Creator_Maintain_Most_Recent_Flag` |
| Subagents | `Agentforce_Account_Research_AEA` (Orchestrator), `In_Depth_Web_Research` (Researcher) |
| Agent Actions | `Start_AEA_Account_Research_Report`, `Agentforce_Account_Research_Task` |
| Prompt Templates | `Account_Intelligence_Research_Report_Generator`, `Source_Counter`, `Account_Intelligence_Research_Summarizer`, `Account_Intelligence_Research_Report_Comparison`, `Agentforce_Account_Research_Task` |
| Custom Object | `Account_Research_Report__c` |
| Custom Notification | `Account_Research_Complete_Notification` |
| Lightning Page | `Enhanced_Account_Research_Report_Record_Page` |

## Install

### Prerequisites

- Einstein Generative AI enabled
- Agentforce enabled

### Package Install

Install via this URL:

```
https://login.salesforce.com/packaging/installPackage.apexp?p0=04tKY000000hnz5
```

If you encounter an error, retry and select "Rename conflicting components in package" during installation.

### Post-Install Setup

See the full [Install & Setup Guide](docs/Agentforce_Employee_Agent_AEA_Orchestrated_Account_Research.pdf) for detailed configuration steps (~20 min):

1. Configure the Research Sub-Agent (Employee Agent with `In_Depth_Web_Research` subagent)
2. Configure the User-Facing Agent (add `Agentforce_Account_Research_AEA` subagent)
3. Configure the Flow (add research sub-agent actions to the orchestration flow)
4. Configure the Account Record Page (add related list for reports)
5. Validate the setup

## Authors

- Hunter Reh, AI Architect, Salesforce Partner Solutions
- Stephanie Shaw, Senior AI Architect, Salesforce Partner Solutions

## Disclaimer

This package is intended solely for informational and demonstration purposes (proof-of-concept). It is not production-ready and requires design, security review, customization, testing, and validation to meet specific business, legal, and compliance requirements. See the full disclaimer in the setup guide.
