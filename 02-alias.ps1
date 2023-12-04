function ver {
	cmd.exe /c ver $args
}

function mklink {
	cmd.exe /c mklink $args
}

Invoke-Command {
	function Set-LsAliases {
		$aliases = @{
			'ls'   = @('ls.exe --color -F', '', '| ForEach-Object {`$_.Name}');
			'l'    = @('ls -lFh', '', '');
			'la'   = @('ls -lAFh', '-Force', '');
			'lr'   = @('ls -tRFh', '-Recurse', '| Sort-Object LastWriteTime');
			'lt'   = @('ls -ltFh', '', '| Sort-Object LastWriteTime');
			'll'   = @('ls -l', '', '');
			'ldot' = @('ls -ld .*', '', '');
			# 'lS' = @('ls -1FSsh', '');
			'lart' = @('ls -1Fcart', '-Force', '| Sort-Object LastWriteTime | ForEach-Object {`$_.Name}');
			'lrt'  = @('ls -1Fcrt', '', '| Sort-Object LastWriteTime | ForEach-Object {`$_.Name}');
			'lsr'  = @('ls -lARFh', '-Force -Recurse', '');
			'lsn'  = @('ls -1', '', '| ForEach-Object {`$_.Name}');
		}
		$aliases.Keys | ForEach-Object {
			$scriptBlock = @"
`$lsAvailable = ((Get-Location).Provider.Name -eq 'FileSystem') -and (Get-Command ls.exe -ErrorAction Ignore)
if (`$lsAvailable) {
    Invoke-Expression "$($aliases[$_][0]) `$args"
}
else {
    Invoke-Expression "Get-ChildItem `$args $($aliases[$_][1]) $($aliases[$_][2])"
}
"@
			Set-Item -Path "function:global:$_" -Value ([ScriptBlock]::Create($scriptBlock))
		}
	}
	Set-LsAliases
}

Remove-Item -Force -Path Alias:\cd
function cd {
	if ([string]::IsNullOrWhiteSpace($args)) {
		Set-Location $HOME
	}
	else {
		Set-Location ($args -join ' ')
	}
}

function ffmerge ($from, $to) {
	git fetch . ${from}:$to
}

function clrhist {
	New-Item -Path "$Env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -ItemType File -Force | Out-Null
}

function cleanrepo {
	git reset
	git checkout $(git rev-parse --show-toplevel)
	git clean -df
	git clean -Xdf
}

function yadm {
	$ScoopGitPrefix = $((scoop prefix git) 6> $null)
	if ($ScoopGitPrefix) {
		& "$ScoopGitPrefix\\usr\\bin\\bash" "$HOME/.local/bin/yadm" $args
	}
	else {
		Write-Warning 'Git for Windows is NOT installed.'
	}
}

function update-yadm {
	wget.exe -O "$HOME/.local/bin/yadm" 'https://github.com/TheLocehiliosan/yadm/raw/master/yadm'
}

function nvm {
	if ($args[0] -eq 'install') {
		if ($null -eq $args[1]) {
			$nvmrc = Get-Content -Path '.nvmrc' -ErrorAction Ignore | Select-Object -First 1
			if ($null -eq $nvmrc) {
				Write-Warning 'No .nvmrc file found.'
				return
			}
			$version = [RegEx]::Match($nvmrc, '(\d+\.)+\d+').Value
			if ($version -eq '') {
				Write-Warning 'No version found in .nvmrc file.'
				return
			}
			else {
				nvm.exe install $nvmrc
				sudo nvm.exe use $nvmrc
			}
		}
		elseif ($args[1] -eq 'node' -or $args[1] -eq 'latest') {
			$latest = nvm.exe install latest | Select-Object -Last 1
			$version = [RegEx]::Match($latest, '(\d+\.)+\d+').Value
			sudo nvm.exe use $version
		}
		elseif ($args[1] -eq 'lts' -or $args[1] -eq '--lts') {
			$lts = nvm.exe install lts | Select-Object -Last 1
			$version = [RegEx]::Match($lts, '(\d+\.)+\d+').Value
			sudo nvm.exe use $version
		}
		else {
			sudo nvm.exe $args
		}
	}
	else {
		nvm.exe $args
	}
}
