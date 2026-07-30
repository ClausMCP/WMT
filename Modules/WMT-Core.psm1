# WMT Core Module - Infrastructure
function Test-Admin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function Log-Message {
    param([string]$Level, [string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Confirm-SafeOperation {
    param([string]$Description)
    if ($WhatIfPreference) {
        Write-Host "[WhatIf] Would perform: $Description"
        return $false
    }
    return $true
}

Export-ModuleMember -Function Test-Admin, Log-Message, Confirm-SafeOperation
