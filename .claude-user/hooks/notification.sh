# .claude/hooks/notification.sh
#!/usr/bin/env zsh

# Log when the hook is called
echo "$(date): Notification hook called" >> ~/.claude/hooks/notification.log

# Play the sound
afplay /System/Library/Sounds/Blow.aiff