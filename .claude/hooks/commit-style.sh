#!/usr/bin/env bash
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Only inspect git commit (also catches `git -C path commit`)
grep -qE '(^|[;&|[:space:]])git([[:space:]]+-[^[:space:]]+)*[[:space:]]+commit' <<<"$cmd" || exit 0

reason=""
grep -qi 'co-authored-by\|generated with' <<<"$cmd" && reason+="Message carries an attribution trailer. "
[[ $(grep -oc -- ' -m' <<<"$cmd") -gt 1 ]] && reason+="Use a single -m. "
{ grep -q '\\n' <<<"$cmd" || [[ "$cmd" == *$'\n'* ]]; } && reason+="Message must be one line. "

if [[ -n "$reason" ]]; then
  jq -n --arg r "${reason}Rewrite as: git commit -m \"<one-line gist>\"" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
fi
exit 0
