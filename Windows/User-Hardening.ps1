# Team 21 Windows local account review. No changes without explicit request.
[CmdletBinding()]
param([string]$DisableUser)
$ErrorActionPreference = 'Stop'
Write-Host 'Local users:'
Get-LocalUser | Select-Object Name,Enabled,SID,LastLogon | Format-Table -AutoSize
Write-Host 'Administrators:'
Get-LocalGroupMember -Group 'Administrators' | Format-Table -AutoSize
if (-not $DisableUser) { Write-Host 'Review complete. Use -DisableUser NAME to disable a reviewed account.'; return }
$u = Get-LocalUser -Name $DisableUser -ErrorAction Stop
if ($u.Name -in @('plinktern','jmoney','Administrator') -or $u.SID.Value -match '-(500|501)$') { throw 'Protected/built-in user. Review built-in Guest separately.' }
if ($u.Name -eq $env:USERNAME) { throw 'Refusing to disable current account.' }
$confirmText = Read-Host "Type DISABLE $($u.Name) to proceed"
if ($confirmText -cne "DISABLE $($u.Name)") { Write-Host 'Canceled'; return }
$logDir = Join-Path $env:ProgramData 'HPCC21'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
"$(Get-Date -Format o) disable $($u.Name)" | Out-File -Append -Encoding utf8 (Join-Path $logDir 'account-actions.log')
Disable-LocalUser -Name $u.Name
Write-Host "Disabled $($u.Name). To reverse: Enable-LocalUser -Name '$($u.Name)'"
