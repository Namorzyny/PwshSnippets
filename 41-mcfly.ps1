$InitScript = "$Env:TEMP\mcfly.ps1"
mcfly init powershell | Out-File -FilePath $InitScript -Force
. $InitScript
Remove-Item -Path $InitScript -Force
Get-Content -Path $Env:HISTFILE -Tail 100 | Out-File -FilePath (Get-PSReadLineOption).HistorySavePath -Force
