#!/usr/bin/env bash
# Restaura as configs de desenvolvimento a partir deste repo.
set -euo pipefail
cd "$(dirname "$0")/.."
REPO="$PWD"

[ -f .env ] && { set -a; . ./.env; set +a; } || echo "!! .env ausente - MCP não será gerado."

APPDATA_DIR="${APPDATA:-$HOME/AppData/Roaming}"

resolve() { # substitui placeholders num *.example.* -> *.local.*
  local src="$1" dst="$2"
  sed -e "s|\${CONTEXT7_API_KEY}|${CONTEXT7_API_KEY:-}|g" \
      -e "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|${GITHUB_PERSONAL_ACCESS_TOKEN:-}|g" \
      -e "s|\${SUPABASE_PROJECT_REF}|${SUPABASE_PROJECT_REF:-}|g" \
      -e "s|\${NINEROUTER_API_KEY}|${NINEROUTER_API_KEY:-}|g" \
      "$src" > "$dst"
  echo "   gerado $dst"
}

echo "== Claude Code =="
mkdir -p "$HOME/.claude/skills" "$HOME/.claude/plugins"
cp -r claude/skills/. "$HOME/.claude/skills/"
cp claude/settings.json "$HOME/.claude/settings.json"
cp claude/known_marketplaces.json "$HOME/.claude/plugins/known_marketplaces.json"
[ -f .env ] && resolve claude/mcp.example.json claude/mcp.local.json

echo "== Cursor =="
mkdir -p "$HOME/.cursor/skills-cursor" "$APPDATA_DIR/Cursor/User"
cp -r cursor/skills/. "$HOME/.cursor/skills-cursor/"
cp cursor/settings.json "$APPDATA_DIR/Cursor/User/settings.json"
cp cursor/mcp.json "$HOME/.cursor/mcp.json"

echo "== Antigravity =="
mkdir -p "$HOME/.gemini/config/skills" "$APPDATA_DIR/Antigravity IDE/User"
cp -r antigravity/skills/. "$HOME/.gemini/config/skills/"
cp antigravity/config.json "$HOME/.gemini/config/config.json"
cp antigravity/ide-settings.json "$APPDATA_DIR/Antigravity IDE/User/settings.json"
[ -f .env ] && resolve antigravity/mcp_config.example.json "$HOME/.gemini/config/mcp_config.json"

echo "== opencode =="
mkdir -p "$HOME/.config/opencode"
cp opencode/AGENTS.md "$HOME/.config/opencode/AGENTS.md"
[ -f .env ] && {
  resolve opencode/opencode.example.json  "$HOME/.config/opencode/opencode.json"
  resolve opencode/opencode.example.jsonc "$HOME/.config/opencode/opencode.jsonc"
}

echo
echo "Pronto. Reveja claude/mcp.local.json e mescle o bloco mcpServers no seu ~/.claude.json."
echo "Extensões de IDE: reinstale a partir de cursor/extensions.txt e antigravity/extensions.txt."
