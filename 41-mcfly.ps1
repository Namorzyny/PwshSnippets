$InitScript = "$Env:TEMP\mcfly.ps1"

# https://github.com/cantino/mcfly/issues/382
(mcfly init powershell).Replace('-CommandToComplete $line', '-CommandToComplete "$line"') | Out-File -FilePath $InitScript -Force

. $InitScript
Remove-Item -Path $InitScript -Force

# https://github.com/cantino/mcfly/pull/384
Get-Content -Path $Env:HISTFILE | Out-File -FilePath (Get-PSReadLineOption).HistorySavePath -Force
