# Team 21 Windows Server read-only snapshot. Run as Administrator for complete results.
$ErrorActionPreference = 'Continue'
$root='C:\HPCC21\Reports'; New-Item -ItemType Directory -Force -Path $root | Out-Null
$out=Join-Path $root ("Baseline-{0}-{1}.txt" -f $env:COMPUTERNAME,(Get-Date -Format yyyyMMdd-HHmmss))
& {
"=== TIME / HOST ==="; Get-Date; hostname
"=== USERS ==="; Get-LocalUser | Format-Table -AutoSize | Out-String
"=== ADMINS ==="; Get-LocalGroupMember -Group Administrators | Format-Table | Out-String
"=== NETWORK ==="; Get-NetIPAddress | Format-Table | Out-String
"=== TCP ==="; Get-NetTCPConnection | Format-Table | Out-String
"=== SERVICES ==="; Get-Service | Sort-Object Name | Format-Table | Out-String
"=== TASKS ==="; Get-ScheduledTask | Select-Object TaskName,TaskPath,State | Format-Table | Out-String
"=== FIREWALL ==="; Get-NetFirewallProfile | Format-Table | Out-String
"=== DEFENDER ==="; Get-MpComputerStatus | Format-List | Out-String
} | Out-File -LiteralPath $out -Encoding utf8
Write-Host "Saved restricted system report to $out; secure the folder and avoid sharing sensitive details."
