# WMT UI Module
Import-Module (Join-Path $PSScriptRoot "WMT-Core.psm1") -Force

function Show-MainMenu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "   Windows Management Tool (Modular)  " -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "1. Run Diagnostics"
    Write-Host "2. System Repair"
    Write-Host "3. System Tuning"
    Write-Host "4. Exit"
    
    $choice = Read-Host "Select an option"
    switch ($choice) {
        '1' { Start-Diagnostic }
        '2' { Start-Repair }
        '3' { Start-Tuning }
        '4' { Write-Host "Exiting..."; exit }
        default { Write-Host "Invalid option" }
    }
}

Export-ModuleMember -Function Show-MainMenu
