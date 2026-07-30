# WMT Tuning Module
Import-Module (Join-Path $PSScriptRoot "WMT-Core.psm1") -Force

function Start-Tuning {
    Write-Host "Starting System Tuning..." -ForegroundColor Cyan
    if (-not (Confirm-SafeOperation "Apply Performance Tweaks")) { return }
    Log-Message "INFO" "Applying safe tweaks only..."
}

Export-ModuleMember -Function Start-Tuning
