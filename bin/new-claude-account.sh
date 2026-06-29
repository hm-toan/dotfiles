#!/usr/bin/env bash
# Set up an extra Claude Code account that shares the personal (~/.claude)
# tooling + plugins but has its own login/config dir.
#   usage: bash ~/.claude/new-claude-account.sh <suffix>
#   e.g.   bash ~/.claude/new-claude-account.sh pe2   ->  ~/.claude-pe2 , alias `claude-pe2`
# Idempotent — re-run to re-sync tooling/plugins after changing the personal account.
set -euo pipefail

SUF="${1:?usage: new-claude-account.sh <suffix>}"
SRC="$HOME/.claude"
DST="$HOME/.claude-$SUF"
ALIAS="claude-$SUF"

mkdir -p "$DST/plugins"

# Shared tooling — symlink (read-only knowledge, no account state).
for item in CLAUDE.md RTK.md rules agents commands; do
  [ -e "$SRC/$item" ] && ln -sfn "$SRC/$item" "$DST/$item"
done

# Plugins: big marketplace repos symlinked; small registry files copied.
ln -sfn "$SRC/plugins/marketplaces" "$DST/plugins/marketplaces"
for f in installed_plugins.json known_marketplaces.json blocklist.json; do
  [ -e "$SRC/plugins/$f" ] && cp -f "$SRC/plugins/$f" "$DST/plugins/$f"
done

# Merge plugin enablement + custom marketplaces, preserving dst-local keys.
python3 - "$SRC/settings.json" "$DST/settings.json" <<'PY'
import json, sys, os
src = json.load(open(sys.argv[1]))
dst = json.load(open(sys.argv[2])) if os.path.exists(sys.argv[2]) else {}
for k in ("enabledPlugins", "extraKnownMarketplaces"):
    if k in src: dst[k] = src[k]
json.dump(dst, open(sys.argv[2], "w"), indent=2)
PY

# Alias → machine-local zsh file (untracked; dotfiles repo is public/shared).
TL="$HOME/.zshrc-tlocal"
touch "$TL"
if ! grep -q "alias $ALIAS=" "$TL" 2>/dev/null; then
  printf '\n# Claude Code — %s account: isolated config dir + own keychain entry\nalias %s='\''CLAUDE_CONFIG_DIR="%s" claude'\''\n' "$SUF" "$ALIAS" "$DST" >> "$TL"
  echo "added alias $ALIAS to ~/.zshrc-tlocal"
else
  echo "alias $ALIAS already present"
fi

echo "done: $DST  ->  run \`$ALIAS\` then /login"
