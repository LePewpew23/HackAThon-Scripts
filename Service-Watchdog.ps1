# Team 21 read-only service checks; no automatic restart
$hostName=$env:COMPUTERNAME.ToLowerInvariant()
Write-Host "Checking $hostName"
$rdp=Get-Service TermService -ErrorAction SilentlyContinue
if($rdp){Write-Host "RDP service: $($rdp.Status)"}
$port=if($hostName -eq 'assembly'){8080}elseif($hostName -eq 'manifest'){3306}else{0}
if($port -gt 0){
 $listen=Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
 Write-Host "Port $port listener: $([bool]$listen) (listener alone does not prove scoring functionality)"
}
Write-Warning 'Check NEIGH scoring and application authentication; no services restarted.'
