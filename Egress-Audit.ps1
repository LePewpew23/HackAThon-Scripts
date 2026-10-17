# Team 21 read-only firewall/egress audit; no tool removal or blocking.
Get-NetTCPConnection | Where-Object State -eq Established | Select-Object LocalAddress,LocalPort,RemoteAddress,RemotePort,OwningProcess | Format-Table
Get-NetFirewallProfile | Format-Table Name,DefaultInboundAction,DefaultOutboundAction
Write-Warning 'Investigate suspicious processes before termination. Do not default-deny outbound without verified DNS, updates, SIEM and application requirements.'
