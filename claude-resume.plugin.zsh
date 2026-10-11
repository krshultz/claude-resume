# Tab-complete session IDs for `claude --resume` / `claude -r`,
# labeled with when each session was last used and its AI-generated title,
# newest first. Sessions are per-directory: only those started in $PWD are offered.
# Only the newest CLAUDE_RESUME_MAX sessions are listed (default 10; 0 lists all).

zmodload -F zsh/stat b:zstat
zmodload zsh/datetime

_claude_sessions() {
  local dir=~/.claude/projects/${PWD//[^A-Za-z0-9]/-}
  local -a sessions
  local f title mtime when max=${CLAUDE_RESUME_MAX:-10}
  local -a files=($dir/*.jsonl(N.om))
  (( max > 0 )) && files=(${files[1,max]})
  for f in $files; do
    title=$(grep -o '"aiTitle":"[^"]*"' $f | tail -1 | cut -d'"' -f4)
    zstat -A mtime +mtime -- $f
    strftime -s when '%Y-%m-%d %H:%M' $mtime
    sessions+=("${f:t:r}:$when  ${title:-(untitled)}")
  done
  _describe -V -t sessions 'session' sessions
}

_claude() {
  _arguments -s \
    '(-r --resume -c --continue)'{-r,--resume}'[resume a session by ID]:session:_claude_sessions' \
    '(-r --resume -c --continue)'{-c,--continue}'[continue the most recent session]' \
    '*::arg:_default'
}

compdef _claude claude
