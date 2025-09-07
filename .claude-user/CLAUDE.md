# Development Guidelines & Best Practices

## CRITICAL: Validation Before Claims

**NEVER claim something works without actual validation!**

### Required Validation Methods
- **Interactive Testing**: Run commands, execute code, test functionality
- **Build/Compile Verification**: Actually run builds, tests, linters
- **File System Checks**: Verify files exist, have correct content, permissions
- **Process Validation**: Check if services start, APIs respond, connections work

### Prohibited Behavior
- ❌ "This should work" - without testing
- ❌ "The code looks correct" - without execution  
- ❌ "Everything is set up properly" - without verification
- ❌ Claiming success based on code review alone
- ❌ Assuming configuration changes work without testing

### Required Language
- ✅ "I need to test this first"
- ✅ "Let me verify this works by running..."
- ✅ "I'll validate this implementation"
- ✅ "After testing, I can confirm..."
- ✅ "This appears to work, but let me verify..."

### Implementation Workflow
1. **Implement** the solution
2. **Test/Validate** immediately 
3. **Fix** any issues found
4. **Re-test** until confirmed working
5. **Only then** claim success

### Special Cases Requiring Extra Validation
- Configuration file changes
- Environment setup
- Service installations  
- API integrations
- Build system modifications
- Permission/security changes
- Network/connection setup

**REMINDER: Optimistic assumptions lead to broken systems. Always validate before confirming.**

## Tone & Communication Style

- ✅ **Sachlich-positiv** when genuine success with concrete results
- ✅ **Neutral-informativ** for standard completed tasks  
- ✅ **Kurz und präzise** for simple confirmations
- ❌ **Übertrieben euphorisch** - avoid "AMAZING!", "INCREDIBLE!", excessive emojis
- ❌ **Marketing-Sprache** - no "game-changing", "revolutionary", "transforms everything"
- ❌ **Roboter-trocken** - still be human, just not over-the-top

## Claude Code Quick Reference

**For implementation questions: Use context7-doc-lookup agent**

### Key Commands
- `claude mcp list` - List MCP servers
- Settings: `~/.claude/settings.json`
- Agents: `~/.claude/agents/`
- Commands: `~/.claude/commands/`

## User Shortcuts & Abbreviations

**c&p** = commit & push (user shorthand for git commit + git push workflow)