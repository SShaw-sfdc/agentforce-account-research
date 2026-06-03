# Packaging Notes

This document describes how to maintain and re-upload the 1GP unmanaged package for this solution.

## Packaging Org

- **Username:** trailsignup.cc2c630cd3e454@salesforce.com
- **Org ID:** 00DKY00000aUdI92AK
- **CLI alias:** `packaging-org`
- **IMPORTANT:** Log in at least once a month. Trial/signup orgs expire after 45 days of inactivity, which is what killed the original package.

## Current Package Version

- **Version:** 1.10 (Winter 2026)
- **Install URL:** https://login.salesforce.com/packaging/installPackage.apexp?p0=04tKY000000hnz5

## How to Upload a New Version

1. Make changes to the source code locally
2. Deploy to the packaging org:
   ```bash
   sf project deploy start --source-dir force-app --target-org packaging-org
   ```
3. Go to Setup > Package Manager > "Agentforce - Account Research with AEA"
4. Click Upload, set version name and number
5. Update the install URL in README.md and docs

## Known 1GP Agentforce Packaging Issues

### Problem: `dataTypeMappings` causes "duplicate value found" on install

**Symptom:** Flow with `generateAiAgentResponse` actions fails to install with:
```
duplicate value found: <unknown> duplicates value on record with id: <unknown>
```

**Cause:** The `<dataTypeMappings>` block in flow XML references `AgentInvAction__AIAgentCompositeDefault`, an auto-generated org-local Apex class. The packaging engine can't resolve it in the target org.

**Fix:** Remove all `<dataTypeMappings>` blocks and `<versionString>` tags from the flow XML before deploying to the packaging org. The Agentforce runtime re-binds these dynamically at install time.

```xml
<!-- REMOVE THIS BLOCK -->
<dataTypeMappings>
    <apexClass>AgentInvAction__AIAgentCompositeDefault</apexClass>
    <typeName>U__agentResponseApex</typeName>
</dataTypeMappings>
```

### Problem: `AnswerQuestionsWithKnowledge` duplicate entry on upload

**Symptom:** Package upload fails with:
```
duplicate entry: genAiPlannerBundles/.../plannerActions/AnswerQuestionsWithKnowledge_.../input/schema.json
```

**Cause:** Salesforce auto-provisions the `AnswerQuestionsWithKnowledge` action in every Agent's planner bundle (even if no Knowledge/Data Library is attached). It exists as a "ghost" in the metadata that's invisible in the UI but present in the XML. When the package compiler encounters it alongside other standard actions, it sees a duplicate.

**Fix:** Do not include the Bot or GenAiPlannerBundle in the package. Have users create the agent manually during setup. Attempts to fix this by cloning the agent with a new API name do NOT resolve it — the ghost follows every new agent.

### Problem: `BotVersion` requires `PlannerId` on install

**Symptom:**
```
BotVersion(Research_Specialist.v1) Required fields are missing: [PlannerId]
```

**Cause:** Including the Bot without its Planner. But including the Planner triggers the `AnswerQuestionsWithKnowledge` duplicate above.

**Fix:** Don't package the Bot at all. Same resolution as above.

### Problem: SDO orgs have pre-installed "AI Agents" unmanaged package

**Symptom:** Flow with `generateAiAgentResponse` fails even after stripping `dataTypeMappings`.

**Cause:** SDO (Sales Demo Org) environments come with a pre-installed unmanaged "AI Agents" package (no namespace) that conflicts with flow action types.

**Fix:** This is an SDO-specific issue. The package installs cleanly on non-SDO orgs. For SDOs, the flow must ship without agent action calls — users add them during Step 3 of the setup guide.

## CI Validation

The GitHub Action (`.github/workflows/validate.yml`) validates Apex and Custom Object metadata on every push to `force-app/`. It does NOT validate GenAI metadata types (prompt templates, plugins, functions) since scratch orgs don't support Agentforce features.

## Component Checklist

When uploading a new package version, ensure these are all present:

- [ ] 2 Apex Classes
- [ ] 3 Flows (no `generateAiAgentResponse` actions, no `dataTypeMappings`)
- [ ] 2 Generative AI Plugin Definitions (subagents)
- [ ] 2 Generative AI Function Definitions (actions)
- [ ] 5 Generative AI Prompt Templates
- [ ] 1 Custom Object (Account_Research_Report__c) with 12 fields
- [ ] 1 Custom Notification Type
- [ ] 1 Lightning Page
- [ ] NO Bot / Planner (users create the agent manually)
