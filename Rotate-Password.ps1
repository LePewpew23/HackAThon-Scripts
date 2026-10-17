# Team 21: rotate only a named local account interactively. Administrator required.
param([Parameter(Mandatory=$true)][ValidateSet('plinktern','jmoney','Administrator')][string]$User)
$account=Get-LocalUser -Name $User -ErrorAction Stop
Write-Warning 'Ensure console recovery and a second login session are available before rotation.'
$confirm=Read-Host "Type YES to change local password for $User"
if($confirm -cne 'YES'){ Write-Host 'Cancelled'; exit 1 }
$pass=Read-Host "New strong password for $User" -AsSecureString
Set-LocalUser -Name $User -Password $pass -ErrorAction Stop
Write-Host "Password changed for $User. Verify a fresh login."
if($User -eq 'jmoney'){ Write-Warning 'UPDATE NEIGH jmoney password IMMEDIATELY to preserve scoring.' }
