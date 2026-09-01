# Restaura as configs de desenvolvimento a partir deste repo.
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$envVars = @{}
if (Test-Path '.env') {
    Get-Content '.env' | Where-Object { $_ -match '^\s*[^#].*=' } | ForEach-Object {
        $k, $v = $_ -split '=', 2
        $envVars[$k.Trim()] = $v.Trim()
    }
} else {
    Write-Host '!! .env ausente - MCP nao sera gerado.'
}

$appData = $env:APPDATA
$claude  = Join-Path $HOME '.claude'
$cursor  = Join-Path $HOME '.cursor'
$gemini  = Join-Path $HOME '.gemini\config'
$oc      = Join-Path $HOME '.config\opencode'

function Resolve-Config($src, $dst) {
    $c = Get-Content $src -Raw
    foreach ($k in $envVars.Keys) { $c = $c.Replace('${' + $k + '}', $envVars[$k]) }
    Set-Content $dst $c -Encoding utf8
    Write-Host "   gerado $dst"
}

Write-Host '== Claude Code =='
New-Item -ItemType Directory -Force -Path "$claude\skills", "$claude\plugins" | Out-Null
Copy-Item -Recurse -Force 'claude\skills\*' "$claude\skills"
Copy-Item -Force 'claude\settings.json' "$claude\settings.json"
Copy-Item -Force 'claude\known_marketplaces.json' "$claude\plugins\known_marketplaces.json"
if (Test-Path '.env') { Resolve-Config 'claude\mcp.example.json' 'claude\mcp.local.json' }

Write-Host '== Cursor =='
New-Item -ItemType Directory -Force -Path "$cursor\skills-cursor", "$appData\Cursor\User" | Out-Null
Copy-Item -Recurse -Force 'cursor\skills\*' "$cursor\skills-cursor"
Copy-Item -Force 'cursor\settings.json' "$appData\Cursor\User\settings.json"
Copy-Item -Force 'cursor\mcp.json' "$cursor\mcp.json"

Write-Host '== Antigravity =='
New-Item -ItemType Directory -Force -Path "$gemini\skills", "$appData\Antigravity IDE\User" | Out-Null
Copy-Item -Recurse -Force 'antigravity\skills\*' "$gemini\skills"
Copy-Item -Force 'antigravity\config.json' "$gemini\config.json"
Copy-Item -Force 'antigravity\ide-settings.json' "$appData\Antigravity IDE\User\settings.json"
if (Test-Path '.env') { Resolve-Config 'antigravity\mcp_config.example.json' "$gemini\mcp_config.json" }

Write-Host '== opencode =='
New-Item -ItemType Directory -Force -Path $oc | Out-Null
Copy-Item -Force 'opencode\AGENTS.md' "$oc\AGENTS.md"
if (Test-Path '.env') {
    Resolve-Config 'opencode\opencode.example.json'  "$oc\opencode.json"
    Resolve-Config 'opencode\opencode.example.jsonc' "$oc\opencode.jsonc"
}

Write-Host ''
Write-Host 'Pronto. Reveja claude\mcp.local.json e mescle o bloco mcpServers no seu ~/.claude.json.'
Write-Host 'Extensoes de IDE: reinstale a partir de cursor\extensions.txt e antigravity\extensions.txt.'
