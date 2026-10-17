# Team 21: read-only firewall overview. DO NOT infer scorer IP ranges.
Write-Host 'Current firewall profile policies:'
Get-NetFirewallProfile | Format-Table Name,Enabled,DefaultInboundAction,DefaultOutboundAction
Write-Host 'Potentially relevant inbound allow rules:'
Get-NetFirewallRule -Enabled True -Direction Inbound -Action Allow | Select-Object -First 80 DisplayName,Profile | Format-Table
Write-Host 'assembly .30: RDP 3389 and Jenkins 8080 per packet; manifest .40: RDP and MariaDB actual port must be verified.'
Write-Warning 'No changes applied. Validate the scoring engine path before tightening rules.'
