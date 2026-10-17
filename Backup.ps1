# Team 21: Windows config snapshot, NOT a live DB/Jenkins-consistent backup.
$root='C:\HPCC21\Backups'; New-Item -ItemType Directory -Force -Path $root | Out-Null
$folder=Join-Path $root ("{0}-{1}" -f $env:COMPUTERNAME,(Get-Date -Format yyyyMMdd-HHmmss)); New-Item -ItemType Directory -Force $folder | Out-Null
Get-LocalUser | Export-Csv (Join-Path $folder 'local-users.csv') -NoTypeInformation
Get-LocalGroupMember Administrators | Export-Csv (Join-Path $folder 'administrators.csv') -NoTypeInformation
Get-NetFirewallRule | Select-Object DisplayName,Enabled,Direction,Action | Export-Csv (Join-Path $folder 'firewall-rules.csv') -NoTypeInformation
Get-Service | Export-Csv (Join-Path $folder 'services.csv') -NoTypeInformation
Get-ScheduledTask | Select-Object TaskName,TaskPath,State | Export-Csv (Join-Path $folder 'tasks.csv') -NoTypeInformation
Write-Host "Snapshot: $folder"
Write-Warning 'For manifest, do an authenticated DB-native logical backup. For assembly, back up Jenkins home consistently during an approved maintenance state. Transfer to blackbox via verified OpenSSH/SCP credentials.'
