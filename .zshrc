# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export PATH=$PATH:/Users/jonathan.glasmeyer/.spicetify


# Added by Windsurf
export PATH="/Users/jonathan.glasmeyer/.codeium/windsurf/bin:$PATH"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$PATH:$ANDROID_HOME/emulator"


# export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"


# bun completions
[ -s "/Users/jonathan.glasmeyer/.bun/_bun" ] && source "/Users/jonathan.glasmeyer/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. "$HOME/.local/bin/env"


# source antidote
source $HOME/.antidote/antidote.zsh
# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh




# Sofortiges Schreiben in die History-Datei
setopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# 2) Titel in der Shell auf den aktuellen Ordner (Basename) setzen
DISABLE_AUTO_TITLE="true"               # falls oh-my-zsh aktiv ist
function set-title-cmd {
  local title
  local cmd="${1%% *}"  # nur das erste Wort (base command)
  if [[ "$PWD" == "$HOME" ]]; then
    title="~ · $cmd"
  else
    title="${PWD:t} · $cmd"
  fi
  print -Pn "\e]0;$title\a"
}
function preexec { set-title-cmd "$1" }   # vor Ausführung des Kommandos
function precmd { 
  local title
  if [[ "$PWD" == "$HOME" ]]; then
    title="~"
  else
    title="${PWD:t}"
  fi
  print -Pn "\e]0;$title\a"
}  # nach Rückkehr zum Prompt


alias awsmoia="aws-sso exec --profile 224874703410:mobile-platform-backend-engineer"
alias g="git"
alias gs="git status"
alias pi='pnpm install'
alias pd='pnpm dev'
alias pb='pnpm build'
alias e="subl"
alias ..="cd .."

gex () { gemini explain "$1" | pbcopy && claude }


# Disable Claude Code terminal title changes
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

function claude-moia() {
  env -u AWS_ACCESS_KEY_ID \
      -u AWS_SECRET_ACCESS_KEY \
      -u AWS_SESSION_TOKEN \
  aws-sso exec --profile 224874703410:mobile-platform-backend-engineer -- \
  env CLAUDE_CODE_USE_BEDROCK=1 \
      AWS_REGION=eu-central-1 \
      ANTHROPIC_MODEL=eu.anthropic.claude-sonnet-4-20250514-v1:0 \
      ANTHROPIC_SMALL_FAST_MODEL=eu.anthropic.claude-3-5-haiku-20241022-v1:0 \
      /Users/jonathan.glasmeyer/.claude/local/claude --dangerously-skip-permissions
}
function claude-moia-list-models() {
  local region="${1:-eu-central-1}"
  echo "📡 Abrufen verfügbarer Anthropic-Modelle in Region: $region"
  aws bedrock list-foundation-models --region "$region" \
    --query "modelSummaries[?providerName=='Anthropic'].{Model:modelId, Name:modelName}" \
    --output table
}
alias claude="/Users/jonathan.glasmeyer/.claude/local/claude --dangerously-skip-permissions"
alias claude-kimi='ANTHROPIC_API_KEY="$KIMI_API_KEY" ANTHROPIC_BASE_URL=https://api.moonshot.ai/anthropic /Users/jonathan.glasmeyer/.claude/local/claude'
alias claude-glm='ANTHROPIC_API_KEY="$GLM_API_KEY" ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic /Users/jonathan.glasmeyer/.claude/local/claude'
alias claude-groq='ANTHROPIC_BASE_URL=http://localhost:7187 ANTHROPIC_API_KEY=NOT_NEEDED /Users/jonathan.glasmeyer/.claude/local/claude'
alias gemini="npm install -g @google/gemini-cli && gemini"

alias codex='npm update -g @openai/codex >/dev/null 2>&1 && codex -c model_reasoning_effort=high --dangerously-bypass-approvals-and-sandbox --'

alias R="source ~/.zshrc"

# opencode
export PATH=/Users/jonathan.glasmeyer/.opencode/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
