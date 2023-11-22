Invoke-Command {
	$processInfo = Get-WmiObject Win32_Process -Filter "ProcessId = $PID"
	$terminal = (Get-Process -Id $processInfo.ParentProcessId).ProcessName

	$allowedTerminal = @(
		'WindowsTerminal',
		'Code',
		'winpty-agent'
	)

	if ($allowedTerminal.Contains($terminal)) {
		$hasStarship = $null -ne $(Get-Command starship -ErrorAction Ignore)

		if ($hasStarship) {
			Invoke-Expression $(starship init powershell --print-full-init | Out-String)
		}
		else {
			Write-Warning 'Starship is NOT installed. Run: scoop install starship'
		}
	}
}
