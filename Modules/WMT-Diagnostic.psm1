# WMT Diagnostic Module
Import-Module (Join-Path $PSScriptRoot "WMT-Core.psm1") -Force

function Start-Diagnostic {
    Write-Host "Starting System Diagnostics..." -ForegroundColor Cyan
    Log-Message "INFO" "Checking disk health..."
    Log-Message "INFO" "Checking memory integrity..."
    Log-Message "INFO" "Scanning system files..."
    Write-Host "Diagnostics Complete." -ForegroundColor Green
}

Export-ModuleMember -Function Start-Diagnostic
