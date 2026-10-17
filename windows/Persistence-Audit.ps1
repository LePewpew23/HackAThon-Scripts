# Team 21 Windows persistence audit (read-only)
$root='C:\HPCC21\Reports'; New-Item -ItemType Directory -Force -Path $root | Out-Null
$out=Join-Path $root ("Persistence-{0}-{1}.txt" -f $env:COMPUTERNAME,(Get-Date -Format yyyyMMdd-HHmmss))
& {
"=== USERS ==="; Get-LocalUser | Format-Table | Out-String
"=== LOCAL ADMINS ==="; Get-LocalGroupMember Administrators | Format-Table | Out-String
"=== TASKS ==="; Get-ScheduledTask | Select-Object TaskName,TaskPath,State | Format-Table | Out-String
"=== AUTO SERVICES ==="; Get-CimInstance Win32_Service | Where-Object StartMode -eq 'Auto' | Select-Object Name,State,PathName,StartName | Format-Table -Wrap | Out-String
"=== RUN KEYS ===";
foreach($p in @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Run','HKCU:\Software\Microsoft\Windows\CurrentVersion\Run')) { Get-ItemProperty $p -ErrorAction SilentlyContinue | Out-String }
"=== LISTENERS ==="; Get-NetTCPConnection -State Listen | Format-Table | Out-String
"=== SECURITY LOG SAMPLE ==="; Get-WinEvent -FilterHashtable @{LogName='Security';Id=4624,4625;StartTime=(Get-Date).AddHours(-6)} -MaxEvents 100 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,Message | Format-List | Out-String
} | Out-File $out -Encoding utf8
Write-Host "Audit saved: $out"
