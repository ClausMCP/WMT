<#
.SYNOPSIS
    Windows Management Tool (Modular Edition)
.DESCRIPTION
    Unified interface for system diagnostics, repair, and tuning.
.NOTES
    Version: 2.0 (Modular)
    Requires: Administrator privileges recommended
#>

param(
    [switch]$Help,
    [switch]$WhatIf
)

# --- Configuration ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Modules = @('Core', 'Diagnostic', 'Repair', 'Tuning', 'UI')

# --- Load Modules ---
Write-Host "[*] Loading modules..." -ForegroundColor Cyan
foreach ($module in $Modules) {
    $path = Join-Path $ScriptDir "WMT-$module.ps1"
    if (Test-Path $path) {
        try {
            . $path
            Write-Host "  [+] Loaded: WMT-$module.ps1" -ForegroundColor Green
        } catch {
            Write-Host "  [-] Failed to load: WMT-$module.ps1 - $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  [-] Not found: WMT-$module.ps1" -ForegroundColor Yellow
    }
}

# --- Verify Critical Functions ---
$required = @('Start-Diagnostic', 'Start-Repair', 'Start-Tuning', 'Show-MainMenu', 'Log-Message')
$missing = @()
foreach ($func in $required) {
    if (-not (Get-Command $func -ErrorAction SilentlyContinue)) {
        $missing += $func
    }
}

if ($missing.Count -gt 0) {
    Write-Host "`n[!] CRITICAL ERROR: Missing functions: $($missing -join ', ')" -ForegroundColor Red
    Write-Host "    Check if module files exist in: $ScriptDir" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Main Execution ---
try {
    if ($Help) {
        Get-Help $MyInvocation.MyCommand
        exit 0
    }

    # Initialize Logging
    Log-Message "INFO" "WMT Modular Started (PID: $PID)"

    # Show Menu
    Show-MainMenu

} catch {
    Write-Host "Critical error during execution: $($_.Exception.Message)" -ForegroundColor Red
    if (Get-Command Log-Message -ErrorAction SilentlyContinue) {
        Log-Message "CRITICAL" $_.Exception.Message
    }
    Read-Host "Press Enter to exit"
}
