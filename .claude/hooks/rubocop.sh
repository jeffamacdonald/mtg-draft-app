#!/usr/bin/env bash
# PostToolUse hook: run RuboCop (report-only) on the Ruby file just edited, inside Docker (running container if up, else a one-off).
# Exit 2 sends offenses back to Claude; any other exit is silent.
file=$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))')
case "$file" in
  *.rb|*.rake) ;;
  *) exit 0 ;;
esac
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
rel=${file#"$PWD"/}
# Use the running web container if there is one, otherwise a throwaway one.
if docker compose ps --status running --services 2>/dev/null | grep -qx web; then
  run=(exec -T web)
else
  run=(run --rm --no-deps -T web)
fi
out=$(docker compose "${run[@]}" bundle exec rubocop --format simple "$rel" 2>&1) && exit 0
echo "$out" | head -30 >&2
exit 2
