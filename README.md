# claude-config

Backup versionado das minhas configurações do Claude Code (nível de usuário, `~/.claude`).

## Conteúdo

| Caminho | Origem | O que é |
|---|---|---|
| `settings.json` | `~/.claude/settings.json` | Tema, modelo padrão, effort level, canal de auto-update |
| `skills/` | `~/.claude/skills/` | 46 skills instaladas (próprias + de marketplaces) |
| `mcp/mcp.example.json` | `~/.claude.json` → `mcpServers` | Servidores MCP, **com segredos substituídos por placeholders** |
| `plugins/known_marketplaces.json` | `~/.claude/plugins/` | Marketplaces de plugins registrados |
| `.env.example` | — | Modelo das variáveis de ambiente com os segredos reais |

## Segredos

Os tokens **não** estão neste repo. `mcp/mcp.example.json` usa placeholders:

- `CONTEXT7_API_KEY`
- `GITHUB_PERSONAL_ACCESS_TOKEN`
- `SUPABASE_PROJECT_REF`

Copie `.env.example` para `.env` e preencha. `.env` está no `.gitignore`.

## Restaurar numa máquina nova

```bash
# 1. Skills
cp -r skills/* ~/.claude/skills/

# 2. Settings
cp settings.json ~/.claude/settings.json

# 3. Marketplaces de plugins
cp plugins/known_marketplaces.json ~/.claude/plugins/known_marketplaces.json

# 4. MCP servers: preencha .env e gere o mcp.json real
#    (ou configure via `claude mcp add ...`)
```

Existe `restore.sh` (bash) e `restore.ps1` (PowerShell) que fazem os passos 1-3 e
geram `mcp/mcp.local.json` a partir do `.env`.

## Skills incluídas

agy-customizations, antigravity-guide, brainstorming, caveman, dispatching-parallel-agents,
eas-app-stores, eas-hosting, eas-observe, eas-simulator, eas-update-insights, eas-workflows,
executing-plans, expo-app-clip, expo-brownfield, expo-data-fetching, expo-design-system,
expo-dev-client, expo-dom, expo-examples, expo-migrate-module, expo-module, expo-native-ui,
expo-project-structure, expo-router, expo-skill-feedback, expo-tailwind-setup, expo-ui,
expo-upgrade, expo-web-to-native, finishing-a-development-branch, frontend-design,
google-antigravity-sdk, karpathy-guidelines, permissioned-github, receiving-code-review,
requesting-code-review, subagent-driven-development, supabase, supabase-postgres-best-practices,
systematic-debugging, test-driven-development, using-git-worktrees, using-superpowers,
verification-before-completion, writing-plans, writing-skills
