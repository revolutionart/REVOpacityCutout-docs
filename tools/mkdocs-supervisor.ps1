param(
    [string]$Root = "j:\DEV_Blender_Addons\REVO_OpacityCutout_Docs",
    [int]$Port = 8000,
    [int]$PollSeconds = 1
)

$ErrorActionPreference = "Stop"

function Get-WatchSignature {
    param([string]$Base)

    $items = @()

    $mkdocs = Join-Path $Base "mkdocs.yml"
    if (Test-Path $mkdocs) {
        $f = Get-Item $mkdocs
        $items += "$($f.FullName)|$($f.Length)|$($f.LastWriteTimeUtc.Ticks)"
    }

    $docsDir = Join-Path $Base "docs"
    if (Test-Path $docsDir) {
        $items += Get-ChildItem $docsDir -Recurse -File |
        Sort-Object FullName |
        ForEach-Object { "$($_.FullName)|$($_.Length)|$($_.LastWriteTimeUtc.Ticks)" }
    }

    return [string]::Join("`n", $items)
}

function Start-MkDocs {
    param([string]$Base, [int]$ListenPort)

    Push-Location $Base
    try {
        $args = @("serve", "--dev-addr", "127.0.0.1:$ListenPort")
        return Start-Process -FilePath "mkdocs" -ArgumentList $args -PassThru -WindowStyle Hidden
    }
    finally {
        Pop-Location
    }
}

function Stop-MkDocs {
    param([System.Diagnostics.Process]$Proc)

    if ($null -ne $Proc -and -not $Proc.HasExited) {
        try {
            Stop-Process -Id $Proc.Id -Force
        }
        catch {
        }
    }
}

Write-Host "[mkdocs-supervisor] root=$Root port=$Port poll=${PollSeconds}s"

# Clean stale mkdocs serve processes to avoid collisions.
Get-CimInstance Win32_Process |
Where-Object { $_.CommandLine -match 'mkdocs\.exe" serve' } |
ForEach-Object {
    try { Stop-Process -Id $_.ProcessId -Force } catch {}
}

$proc = Start-MkDocs -Base $Root -ListenPort $Port
Write-Host "[mkdocs-supervisor] started mkdocs PID=$($proc.Id)"

$last = Get-WatchSignature -Base $Root

try {
    while ($true) {
        Start-Sleep -Seconds $PollSeconds

        if ($proc.HasExited) {
            Write-Host "[mkdocs-supervisor] mkdocs exited, restarting"
            $proc = Start-MkDocs -Base $Root -ListenPort $Port
            Write-Host "[mkdocs-supervisor] restarted mkdocs PID=$($proc.Id)"
            $last = Get-WatchSignature -Base $Root
            continue
        }

        $current = Get-WatchSignature -Base $Root
        if ($current -ne $last) {
            Write-Host "[mkdocs-supervisor] file change detected, restarting mkdocs"
            Stop-MkDocs -Proc $proc
            Start-Sleep -Milliseconds 350
            $proc = Start-MkDocs -Base $Root -ListenPort $Port
            Write-Host "[mkdocs-supervisor] restarted mkdocs PID=$($proc.Id)"
            $last = $current
        }
    }
}
finally {
    Stop-MkDocs -Proc $proc
}
