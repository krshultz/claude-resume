# Tab-complete session IDs for `claude --resume` / `claude -r`,
# labelled with each session's AI-generated title, newest first.
# Sessions are per-directory: only those started in $PWD are offered.

_claude_sessions() {
  local dir=~/.claude/projects/${PWD//[^A-Za-z0-9]/-}
  local -a sessions
  local f title
  for f in $dir/*.jsonl(N.om); do
    title=$(grep -o '"aiTitle":"[^"]*"' $f | tail -1 | cut -d'"' -f4)
    sessions+=("${f:t:r}:${title:-(untitled)}")
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
