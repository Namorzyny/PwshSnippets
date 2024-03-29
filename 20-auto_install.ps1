Invoke-Command {
	$ProfileDirectory = $PROFILE.Substring(0, $PROFILE.LastIndexOf('\'))
	$ModuleCheckList = @(
		'PSBashCompletions',
		'PSFzf',
		'WSLTabCompletion',
		'posh-git',
		'scoop-completion',
		'npm-completion',
		'yarn-completion'
	)

	$ModuleCheckList | ForEach-Object {
		if ($null -eq (Get-Item -Path "$ProfileDirectory\Modules\$_" -ErrorAction Ignore)) {
			Write-Warning "Missing module: $_, Installing..."
			Install-Module -Name $_ -Scope CurrentUser
		}
	}
}
