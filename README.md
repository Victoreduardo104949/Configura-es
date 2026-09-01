# dev-config

Configurações de ambiente de desenvolvimento versionadas — assistentes de código
e IDEs. Backup para restaurar em qualquer máquina.

Ferramentas cobertas: **Claude Code**, **Cursor**, **Antigravity**, **opencode**.

## Estrutura

```
claude/       Claude Code  (~/.claude)
  settings.json            tema, modelo, effort level, canal de update
  skills/                  46 skills instaladas (conteúdo completo)
  mcp.example.json         servidores MCP (segredos como placeholders)
  known_marketplaces.json  marketplaces de plugins

cursor/       Cursor  (~/.cursor + %APPDATA%/Cursor/User)
  settings.json            settings do usuário
  mcp.json                 servidores MCP (sem segredos)
  skills/                  24 skills do Cursor
  extensions.txt           IDs das extensões instaladas

antigravity/  Antigravity  (~/.gemini/config + %APPDATA%/Antigravity IDE/User)
  config.json              plugins + userSettings
  mcp_config.example.json  servidores MCP (segredos como placeholders)
  skills/                  42 skills
  ide-settings.json        settings do editor
  extensions.txt           IDs das extensões instaladas

opencode/     opencode  (~/.config/opencode)
  opencode.example.json    provider, model, agents, MCP (segredos como placeholders)
  opencode.example.jsonc   MCP remoto (segredos como placeholders)
  AGENTS.md                regras globais

scripts/
  restore.sh / restore.ps1  reinstala tudo numa máquina nova
```

## Segredos

Nenhum token está neste repo. Os arquivos `*.example.json` usam placeholders
`${VAR}` resolvidos a partir de um `.env` local (git-ignorado):

| Variável | Onde é usada |
|---|---|
| `CONTEXT7_API_KEY` | Claude, Antigravity, opencode |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | Claude, Antigravity, opencode |
| `SUPABASE_PROJECT_REF` | Claude, Antigravity, opencode |
| `NINEROUTER_API_KEY` | opencode (provider local) |

Copie `.env.example` para `.env` e preencha.

## Restaurar numa máquina nova

```bash
cp .env.example .env      # e preencha os valores
bash scripts/restore.sh   # Linux/macOS/Git Bash
# ou
pwsh scripts/restore.ps1  # Windows PowerShell
```

O script copia settings e skills para os diretórios de cada ferramenta e gera os
`mcp.local.json` com os segredos do `.env` (que você mescla na config real, já
que os tokens vivem no `~/.claude.json` / `mcp_config.json` de cada app).

Extensões de IDE reinstale a partir de `*/extensions.txt`, ex.:

```bash
cursor --install-extension <id>
```
