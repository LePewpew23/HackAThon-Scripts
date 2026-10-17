# Team 21 toolkit setup. Copies scripts only; does not change system settings.
[CmdletBinding()]
param([string]$Destination = (Join-Path $HOME 'HPCC21-Windows'))
$ErrorActionPreference = 'Stop'
$Source = Split-Path -Parent $MyInvocation.MyCommand.Path
New-Item -ItemType Directory -Force -Path $Destination | Out-Null
Get-ChildItem -LiteralPath $Source -Filter '*.ps1' -File | ForEach-Object {
    $target = Join-Path $Destination $_.Name
    if (-not (Test-Path -LiteralPath $target)) { Copy-Item -LiteralPath $_.FullName -Destination $target }
}
Write-Host "Windows toolkit available at $Destination"
Write-Host 'No services, accounts, or firewall settings were changed.'
Write-Host 'Next: open an elevated PowerShell and inspect Baseline.ps1 and User-Hardening.ps1 before running.'
