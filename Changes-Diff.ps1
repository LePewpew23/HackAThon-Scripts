param([Parameter(Mandatory)][string]$Before,[Parameter(Mandatory)][string]$After)
Compare-Object (Get-Content -LiteralPath $Before) (Get-Content -LiteralPath $After) | Format-Table
