# Dotfiles & Configurations Workspace

This workspace is set up for managing dotfiles and system configurations.

## Tracked Files Overview

### Shell Configuration
- **`.zshrc`** - Main Zsh configuration with environment variables, aliases, plugin loading, and custom functions
- **`.bashrc`** - Bash shell configuration for compatibility
- **`.zshenv`** - Zsh environment variables loaded for all shell sessions
- **`.zprofile`** - Zsh login shell configuration
- **`.profile`** - Generic shell profile for cross-shell compatibility
- **`.p10k.zsh`** - Powerlevel10k prompt theme configuration (lean 8-color style)
- **`.zsh_plugins.txt`** - Antidote plugin manager configuration listing zsh plugins

### Version Control
- **`.gitconfig`** - Git global configuration with user info and custom aliases
- **`.gitignore`** - Repository-level gitignore excluding sensitive files and session data

### Terminal Applications
- **Ghostty config** - `~/Library/Application Support/com.mitchellh.ghostty/config` (macOS specific location)

### Claude Code Workspace
- **`.claude/CLAUDE.md`** - This documentation file
- **`.claude/settings.json`** - Claude Code workspace settings and preferences
- **`.claude/plugins/config.json`** - Plugin configuration for Claude Code
- **`.claude/hooks/notification.sh`** - Shell script for system notifications
- **`.claude/commands/`** - Custom Claude Code commands:
  - `commit.md` - Git commit workflow helper
  - `create-prd.md` - Product requirements document generator
  - `generate-tasks.md` - Task generation utilities
  - `pr-review.md` - Pull request review automation
  - `process-task-list.md` - Task list processing workflows

## Development Environment Features
- **Zsh with Powerlevel10k** - Modern shell with beautiful, fast prompt
- **Antidote Plugin Manager** - Manages zsh plugins including syntax highlighting and autosuggestions
- **Multi-model Claude integration** - AWS Bedrock, Moonshot, GLM, and Groq model access
- **Development aliases** - Shortcuts for common git, npm/pnpm, and navigation commands
- **AWS SSO integration** - Configured for MOIA work environment

## Git Security Setup

### Pre-push Security Hook
This repository includes a pre-push hook that scans for potential secrets before allowing pushes:

**Location**: `git-hooks/pre-push` (tracked in repo)  
**Active Hook**: `.git/hooks/pre-push` → symlink to `../../git-hooks/pre-push`

**Setup after `git init`**:
```bash
ln -s ../../git-hooks/pre-push .git/hooks/pre-push
```

**Features**:
- Detects API keys, tokens, passwords, SSH keys
- Scans for database connection strings  
- Checks for suspicious file extensions (.pem, .key, etc.)
- Blocks pushes with potential secrets
- Provides helpful remediation guidance

**Bypass** (not recommended): `git push --no-verify`

## Local/CLI Tools I Tend to Forget
- **[markitdown](https://github.com/microsoft/markitdown)** - Microsoft's utility to convert various file formats to Markdown
  - `pip install markitdown` or `uvx markitdown`
  - Usage: `markitdown file.pdf` or `markitdown file.docx`
  - Supports: PDF, Word docs, Excel, PowerPoint, images, audio, video, HTML, text files

## macOS File Associations (duti)

**Problem**: Finder's "Always open with" is unreliable and often fails  
**Solution**: Use `duti` command-line tool for reliable file type associations

### Common Usage
```bash
# Set VLC as default for MP4 files
duti -s org.videolan.vlc mp4 all

# Set VSCode for all text files
duti -s com.microsoft.VSCode txt all
duti -s com.microsoft.VSCode md all

# Set specific app for any file type
duti -s <bundle-id> <file-extension> all
```

### Find App Bundle IDs
```bash
# List all apps and their bundle IDs
osascript -e 'id of app "AppName"'
# Example: osascript -e 'id of app "VLC"' → org.videolan.vlc
```

### Reset LaunchServices (if associations still fail)
```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```

**Install duti**: `brew install duti`

## Useful Commands
- `ls -la` - List all files including hidden dotfiles
- `git status` - Check git status of dotfiles repo
- `R` - Reload zsh configuration
- `claude-moia` - Launch Claude with AWS Bedrock integration