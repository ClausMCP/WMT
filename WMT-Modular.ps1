<#
.SYNOPSIS
    Windows Management Tool (WMT) - Modular Version
.DESCRIPTION
    Main entry point for the modular WMT system.
    Loads core functions and dispatches commands to specific modules.
.PARAMETER Action
    The action to perform (Diagnostic, Repair, Tuning, UI).
.PARAMETER WhatIf
    Shows what would happen if the command runs.
.EXAMPLE
    .\WMT-Modular.ps1 -Action Diagnostic
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('Diagnostic', 'Repair', 'Tuning', 'UI', 'Full')]
    [string]$Action = 'UI',
    
    [switch]$SafeMode
)

# Set strict mode for safety
Set-StrictMode -Version Latest

# Define paths
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModulesPath = Join-Path $ScriptPath "Modules"

# Import Core first
$CorePath = Join-Path $ModulesPath "WMT-Core.psm1"
if (Test-Path $CorePath) {
    Write-Host "[*] Loading Core module..." -ForegroundColor Cyan
    Import-Module $CorePath -Force
} else {
    Write-Error "Core module not found at $CorePath"
    exit 1
}

# Check Admin Rights
if (-not (Test-Admin)) {
    Write-Warning "Administrator privileges required for most operations."
    if ($Action -ne 'Diagnostic') {
        $continue = Read-Host "Continue anyway? (y/n)"
        if ($continue -ne 'y') { exit }
    }
}

Write-Host "[*] WMT Modular System Started" -ForegroundColor Green
Write-Host "[*] Mode: $Action" -ForegroundColor Green

try {
    switch ($Action) {
        'Diagnostic' {
            $path = Join-Path $ModulesPath "WMT-Diagnostic.psm1"
            if (Test-Path $path) { Import-Module $path -Force; Start-Diagnostic }
            else { Write-Error "Diagnostic module missing" }
        }
        'Repair' {
            $path = Join-Path $ModulesPath "WMT-Repair.psm1"
            if (Test-Path $path) { Import-Module $path -Force; Start-Repair }
            else { Write-Error "Repair module missing" }
        }
        'Tuning' {
            $path = Join-Path $ModulesPath "WMT-Tuning.psm1"
            if (Test-Path $path) { Import-Module $path -Force; Start-Tuning }
            else { Write-Error "Tuning module missing" }
        }
        'UI' {
            $path = Join-Path $ModulesPath "WMT-UI.psm1"
            if (Test-Path $path) { Import-Module $path -Force; Show-MainMenu }
            else { Write-Error "UI module missing" }
        }
        'Full' {
            Write-Host "[*] Running Full System Check & Apply..." -ForegroundColor Yellow
            # Sequence: Diagnostic -> Report -> Ask for Repair/Tune
            $path = Join-Path $ModulesPath "WMT-Diagnostic.psm1"
            if (Test-Path $path) { Import-Module $path -Force; Start-Diagnostic }
        }
    }
}
catch {
    Write-Error "Critical error during execution: $_"
    Log-Message "CRITICAL" $_.Exception.Message
}

Write-Host "[*] Operation completed." -ForegroundColor Green
