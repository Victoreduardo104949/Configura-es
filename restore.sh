#!/usr/bin/env bash
# Restaura as configs do Claude Code a partir deste repo.
set -euo pipefail
cd "$(dirname "$0")"

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/plugins"

echo "-> skills/"
cp -r skills/. "$CLAUDE_DIR/skills/"

echo "-> settings.json"
cp settings.json "$CLAUDE_DIR/settings.json"

echo "-> plugins/known_marketplaces.json"
cp plugins/known_marketplaces.json "$CLAUDE_DIR/plugins/known_marketplaces.json"

if [ -f .env ]; then
  echo "-> mcp/mcp.local.json (a partir do .env)"
  set -a; . ./.env; set +a
  sed -e "s|\${CONTEXT7_API_KEY}|${CONTEXT7_API_KEY:-}|g" \
      -e "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|${GITHUB_PERSONAL_ACCESS_TOKEN:-}|g" \
      -e "s|\${SUPABASE_PROJECT_REF}|${SUPABASE_PROJECT_REF:-}|g" \
      mcp/mcp.example.json > mcp/mcp.local.json
  echo "   merge o bloco mcpServers de mcp/mcp.local.json no seu ~/.claude.json"
else
  echo "!! .env ausente - pulei o MCP. Copie .env.example para .env e preencha."
fi

echo "Pronto."
