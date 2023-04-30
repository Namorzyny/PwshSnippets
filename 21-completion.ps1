$CompletionModuleStatus = @{}
Set-PSReadLineKeyHandler -Chord Tab -ScriptBlock {
	$CompletionModuleList = @{
		'wsl'   = 'WSLTabCompletion';
		'git'   = 'posh-git';
		'scoop' = 'scoop-completion';
		'npm'   = 'npm-completion';
		'yarn'  = 'yarn-completion';
		'conda' = 'CondaTabExpansion';
	}

	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	$command = $line.ToLower()

	$CompletionModuleList.Keys | ForEach-Object {
		if ($command.StartsWith("$_ ") -and $null -eq $CompletionModuleStatus[$CompletionModuleList[$_]]) {
			Import-Module -Name $CompletionModuleList[$_] -ErrorAction Ignore
			$CompletionModuleStatus[$CompletionModuleList[$_]] = $true
		}
	}

	[Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete()
}
