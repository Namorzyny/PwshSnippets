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
			$initScript = $(starship init powershell --print-full-init | Out-String)
			$patchedScript = $initScript | ForEach-Object {
				$_.Replace('$cwd.ProviderPath', '$(if ($cwd.ProviderPath -eq "") {$cwd.Path} else {$cwd.ProviderPath})')
			}
			Invoke-Expression $patchedScript
			# Set-Item Function:\prompt -Force -Options ReadOnly
		}
		else {
			Write-Warning 'Starship is NOT installed. Run: scoop install starship'
		}
	}
}
