---
  description: Process task list by completing full tasks
  ---

  # Task List Management

  Guidelines for managing task lists in markdown files to track progress on completing a PRD

  ## Task Implementation
  - **One full task at a time:** Complete an entire parent task (e.g., "1.0 Analyze current metric implementation") before moving to the next
  - **Wait for permission:** Do **NOT** start the next parent task until you ask the user for permission and they say "yes" or "y"
  - **Completion protocol:**
      1. When you finish a **parent task**, immediately mark it as completed by changing `[ ]` to `[x]`
      2. Mark **all subtasks** underneath as completed `[x]`
      3. Follow this sequence after completing a parent task:
        - **First**: Mark the **parent task** and all its **subtasks** as completed `[x]`
        - **Then**: Run the full test suite (`npm run lint`, `npm run build`, etc.)
        - **Only if all tests pass**: Stage changes (`git add .`) - this includes both code changes AND the updated task list
        - **Clean up**: Remove any temporary files and temporary code before committing
        - **Commit**: Use a descriptive commit message that:
          - Uses conventional commit format (`feat:`, `fix:`, `refactor:`, etc.)
          - Summarizes what was accomplished in the parent task
          - Lists key changes and additions
          - References the task number and PRD context
          - **Formats the message as a single-line command using `-m` flags**, e.g.:

            ```
            git commit -m "feat: remove old difficulty and opportunity metrics" -m "- Completely removed old metrics from codebase" -m "- Updated type
  definitions and calculations" -m "Related to Task 2.0 in metric-renaming-cleanup PRD"
            ```
  - Stop after each **parent task** and wait for the user's go-ahead.

  ## Task List Maintenance

  1. **Update the task list as you work:**
     - Mark parent tasks and all subtasks as completed (`[x]`) per the protocol above.
     - Add new tasks as they emerge.

  2. **Maintain the "Relevant Files" section:**
     - List every file created or modified.
     - Give each file a one-line description of its purpose.

  ## AI Instructions

  When working with task lists, the AI must:

  1. Complete entire parent tasks in one go (including all subtasks within that parent task).
  2. Regularly update the task list file after finishing any parent task.
  3. Follow the completion protocol:
     - Mark the finished **parent task** and **all its subtasks** `[x]`.
  4. Add newly discovered tasks.
  5. Keep "Relevant Files" accurate and up to date.
  6. Before starting work, check which parent task is next.
  7. After implementing a complete parent task, update the file and then pause for user approval.

  The key changes:
  - Full task completion: Work on entire parent tasks (1.0, 2.0, etc.) instead of individual subtasks
  - Batch marking: Mark both parent task and all subtasks as complete when done
  - Single permission cycle: Only ask for permission between parent tasks, not subtasks
  - Comprehensive commits: Commit messages reflect the full scope of the parent task completed