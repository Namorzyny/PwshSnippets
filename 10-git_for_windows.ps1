Invoke-Command {
	$Env:LANG = "$($(Get-WinSystemLocale).Name.replace('-','_')).UTF-8"
	$Env:LC_CTYPE = $Env:LANG
	$Env:TERM = 'xterm-256color'
	$ScoopGitPrefix = $((scoop prefix git) 6> $null)
	if ($ScoopGitPrefix) {
		$Env:PATH = $Env:PATH.Replace("$HOME\scoop\shims;", '')
		$Env:PATH = "$HOME\scoop\shims;$ScoopGitPrefix\usr\bin;$ScoopGitPrefix\mingw64\bin;$Env:PATH"
	}
	else {
		Write-Warning 'Git for Windows is NOT installed.'
	}
}

if (Get-Command git) {
	Remove-Item -Force -Path Alias:\cat
	Remove-Item -Force -Path Alias:\cp
	Remove-Item -Force -Path Alias:\diff
	Remove-Item -Force -Path Alias:\man
	Remove-Item -Force -Path Alias:\ls
	Remove-Item -Force -Path Alias:\mv
	Remove-Item -Force -Path Alias:\pwd
	Remove-Item -Force -Path Alias:\rm
	Remove-Item -Force -Path Alias:\rmdir
	Remove-Item -Force -Path Alias:\sleep
	Remove-Item -Force -Path Alias:\sort
	Remove-Item -Force -Path Function:\mkdir
	if ($PSVersionTable.PSVersion.Major -lt 6) {
		Remove-Item -Force -Path Alias:\curl
		Remove-Item -Force -Path Alias:\wget
		Remove-Item -Force -Path Function:\more
	}
}
