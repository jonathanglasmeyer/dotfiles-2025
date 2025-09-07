  ---
  allowed-tools: Bash(git add:*), Bash(git status), Bash(git diff), Bash(git diff --cached), Bash(git branch), Bash(git 
  log), Bash(git commit), Bash(git push)
  description: Analyze changes, decide on commit granularity, and create meaningful commits with proper documentation
  ---

  ## Context (for review & commit reasoning)

  - Git status (what's changed): !`git status`
  - Git diff (unstaged): !`git diff`
  - Git diff (staged): !`git diff --cached`
  - Current branch (for pushing): !`git branch --show-current`
  - Last 5 commits (avoid repetition, find scope): !`git log --oneline -5`

  ## Your task

  Analyze the changes and decide on the appropriate commit strategy:

  ### Single Commit (when changes are cohesive)
  - All changes relate to the same feature/fix/refactor
  - Changes are interdependent
  - Small scope that makes sense as one unit

  ### Multiple Commits (when changes are separable)
  - Documentation updates separate from code changes
  - Multiple distinct features/fixes
  - Refactoring separate from new functionality
  - Test files separate from implementation
  - Configuration changes separate from code

  ## Process

  1. **Analyze Changes**: Review git status and diff to understand the scope
  2. **MANDATORY Documentation Check**: Assess documentation impact before proceeding
  3. **Decide Strategy**: Choose single or multiple commits based on logical separation
  4. **Stage Appropriately**: Use `git add <specific-files>` for granular staging
  5. **Create Commits**: Stage and commit code, then documentation
  6. **Push**: Push all commits at once

  Q## MANDATORY: Documentation Impact Assessment

  Before proceeding with ANY commits, you MUST assess if changes require documentation updates:

  ### Step 1: Check Project Documentation Structure
  - **Read CLAUDE.md** to understand the project's documentation structure and requirements
  - **Identify key documentation files** mentioned in CLAUDE.md (README, API docs, UI guides, etc.)
  - **Look for docs/ folder** or similar documentation directories

  ### Step 2: Evaluate Documentation Impact
  Ask yourself for EVERY code change:
  - Does this add/change user-facing features? → Update user documentation
  - Does this add/change APIs, data models, or interfaces? → Update API documentation
  - Does this add/change UI patterns, components, or styles? → Update UI documentation
  - Does this change setup, configuration, or development workflow? → Update developer documentation

  ### Step 3: Documentation Rules
  - **New features**: MUST update user-facing documentation
  - **API/data model changes**: MUST update technical documentation
  - **UI changes**: MUST update relevant UI/design documentation
  - **Breaking changes**: MUST update ALL affected documentation
  - **Configuration changes**: MUST update setup/development documentation

  ### Step 4: Documentation Strategy
  - **Substantial documentation changes**: Create separate `docs:` commits
  - **Minor documentation updates**: Include in the same commit as code
  - **Multiple doc types**: Consider separate commits for different audiences (user vs developer docs)

  ## Documentation Enforcement

  **CRITICAL**: Code without proper documentation is incomplete. Every feature commit should be accompanied by appropriate 
  documentation updates.

  **If you cannot determine documentation impact**, you MUST:
  1. Check if CLAUDE.md exists and read it for guidance
  2. Look for existing documentation patterns in the project
  3. Ask yourself: "What would a new developer or user need to know about this change?"

  **Red Flags** that ALWAYS require documentation:
  - New API endpoints, routes, or data fields
  - New user-facing features or UI components
  - Changed business logic, algorithms, or formulas
  - New configuration options or environment variables
  - Modified setup, installation, or deployment processes

  ## Commit Message Format

  **Types:**
  - feat: New feature
  - fix: Bug fix
  - docs: Documentation changes
  - refactor: Code refactoring
  - style: Formatting changes
  - test: Adding/updating tests
  - chore: Maintenance tasks

  **Guidelines:**
  - Keep the first line under 50 characters
  - Use imperative mood ("Add feature" not "Added feature")
  - Focus on the business value or reason for the change
  - Each commit should be atomic and self-contained
  - Don't commit sensitive information
  - Always use HEREDOC format for multi-line messages

  **Examples of Good Granular Commits:**
  feat: improve competitor strength scoring algorithm
  docs: update API reference with new scoring method
  chore: clean up temporary test files

  **vs single commit when appropriate:**
  fix: calibrate strength scores to align with competitive reality

  - Rebalance weights: relevancy 35%→20%, downloads 25%→35%
  - Improve download scoring curve aligned with UI thresholds
  - Add vulnerability penalties for weak competitors
  - Update documentation with new scoring methodology

  ## Final Checklist

  Before committing, verify:
  - [ ] All code changes are functionally complete
  - [ ] Documentation impact has been assessed
  - [ ] Required documentation updates are identified
  - [ ] Documentation updates are staged/committed appropriately
  - [ ] Commit messages follow the established format
  - [ ] No sensitive information is being committed

  **Remember**: If you're unsure about documentation requirements, err on the side of over-documenting rather than
  under-documenting. Future developers and users will thank you.