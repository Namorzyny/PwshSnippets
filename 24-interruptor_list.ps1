Register-CommandInterruptor 'conda' {
	$hasConda = $null -ne $(Get-Command conda -ErrorAction Ignore)
	if ($hasConda) {
		$oldPrompt = ${function:global:prompt}
		$initScript = $(conda shell.powershell hook | Out-String)
		Invoke-Expression $initScript
		Remove-Item Function:\prompt -Force
		New-Item -Path function:global:prompt -Value $oldPrompt
		function global:deactivate {
			conda deactivate
			Remove-Item -Force Function:\deactivate
		}
	}
	Unregister-CommandInterruptor 'conda'
}
