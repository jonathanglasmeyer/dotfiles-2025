# PR Review Command

Walk through all PR comments interactively, one by one.

## GitHub CLI Commands to Use:

1. **Get current PR number**: `gh pr view --json number -q .number`
2. **Get unresolved comments only**: Use GraphQL API to filter by `isResolved: false`
   ```bash
   gh api graphql -f query='
   query {
     repository(owner: "OWNER", name: "REPO") {
       pullRequest(number: PR_NUMBER) {
         reviewThreads(first: 100) {
           nodes {
             isResolved
             isOutdated
             comments(first: 100) {
               nodes {
                 databaseId
                 path
                 originalLine
                 body
                 user { login }
               }
             }
           }
         }
       }
     }
   }'
   ```
3. **Show PR diff for context**: `gh pr diff {PR_NUMBER}`

## Process for Each Comment:

1. **Filter unresolved only**: Use GraphQL API to get only `isResolved: false` comments
2. **Parse suggestion blocks**: Look for comments containing `\`\`\`suggestion` blocks and extract the actual change
3. **Show meaningful diff**: Display current code vs suggested change with context
4. **Present options**: Ask user to [a]pply, [s]kip, [v]iew file context, [r]esolve without change, or [q]uit
5. **Apply if requested**: Use Edit tool to make the suggested change, then mark as resolved
6. **Track progress**: Keep count of applied vs skipped vs resolved-without-change

## Expected Output Format:

For each unresolved comment show:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Comment 1/15 ❌ UNRESOLVED
📁 requirements/README.md:31
👤 saeltz: "The linked files are not committed."

Current code (lines 28-31):
- [Complete API Reference](amd-api-wanda/docs/amd_api_spec.md) - Full endpoint documentation
- [Autonomous Trip Flow](amd-api-wanda/docs/autonomous_trip_flow.md) - Workflow
- [Getting Started Guide](amd-api-wanda/docs/getting_started.md) - Authentication
- [Protobuf Definitions](amd-api-wanda/uber/proto/) - Message schemas

Issue: These local file links are broken (files don't exist in repo)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Options: [a]pply fix / [s]kip / [v]iew file / [r]esolve without change / [q]uit?
```

## Summary at End:
- Total unresolved comments: X
- ✅ Applied fixes: X  
- ⏭️ Skipped: X
- ✅ Resolved without change: X
- List of files modified during session