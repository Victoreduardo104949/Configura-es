# Restaura as configs do Claude Code a partir deste repo.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$claudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
New-Item -ItemType Directory -Force -Path (Join-Path $claudeDir 'skills'), (Join-Path $claudeDir 'plugins') | Out-Null

Write-Host '-> skills/'
Copy-Item -Recurse -Force 'skills\*' (Join-Path $claudeDir 'skills')

Write-Host '-> settings.json'
Copy-Item -Force 'settings.json' (Join-Path $claudeDir 'settings.json')

Write-Host '-> plugins/known_marketplaces.json'
Copy-Item -Force 'plugins\known_marketplaces.json' (Join-Path $claudeDir 'plugins\known_marketplaces.json')

if (Test-Path '.env') {
    Write-Host '-> mcp/mcp.local.json (a partir do .env)'
    $env = @{}
    Get-Content '.env' | Where-Object { $_ -match '^\s*[^#].*=' } | ForEach-Object {
        $k, $v = $_ -split '=', 2
        $env[$k.Trim()] = $v.Trim()
    }
    $content = Get-Content 'mcp\mcp.example.json' -Raw
    foreach ($k in $env.Keys) { $content = $content.Replace('${' + $k + '}', $env[$k]) }
    Set-Content 'mcp\mcp.local.json' $content -Encoding utf8
    Write-Host '   merge o bloco mcpServers de mcp/mcp.local.json no seu ~/.claude.json'
} else {
    Write-Host '!! .env ausente - pulei o MCP. Copie .env.example para .env e preencha.'
}

Write-Host 'Pronto.'
