$InvokedCommandStatus = @{}
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
	$CommandList = @{
		'conda' = {
			$hasConda = $null -ne $(Get-Command conda -ErrorAction Ignore)
			if ($hasConda) {
				$oldPrompt = ${function:global:prompt}
				$initScript = $(conda shell.powershell hook | Out-String)
				Invoke-Expression $initScript
				Remove-Item Function:\prompt -Force
				New-Item -Path function:global:prompt -Value $oldPrompt
			}
		};
	}

	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	$command = $line.ToLower().Split(' ')[0]

	$CommandList.Keys | ForEach-Object {
		if ($command -eq $_ -and $null -eq $InvokedCommandStatus[$_]) {
			Invoke-Command $CommandList[$_]
			$InvokedCommandStatus[$_] = $true
		}
	}

	[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
