Invoke-Command {
	$noFzf = $null -eq $(Get-Command fzf -ErrorAction Ignore)
	$noEverything = $null -eq $(Get-Command es -ErrorAction Ignore)

	if ($noFzf) {
		Write-Warning 'fzf is NOT installed. Run: scoop install fzf'
	}

	if ($noEverything) {
		Write-Warning 'Everything is NOT installed. Run: scoop install everything-cli'
	}

	if (-not ($noFzf -or $noEverything)) {
		es -get-everything-version | Out-Null

		Import-Module -Name PSFzf -ErrorAction Ignore
		Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
		$Env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border'

		$keyHandler = {
			param($key, $arg)
			if ((Get-Location).Provider.Name -eq 'FileSystem') {
				es -get-everything-version
				$isSupportedFileSystem = @('NTFS', 'ReFS') -contains (Get-Volume -DriveLetter (Get-Location).Drive.Name -ErrorAction SilentlyContinue).FileSystemType
				if (($LASTEXITCODE -eq 0) -and $isSupportedFileSystem) {
					$prefixLength = (Get-Location).Path.Length
					if ($prefixLength -gt 3) {
						$prefixLength++
					}
					if ($key.Key -eq 'T') {
						$result = try {
							es -s -path . | ForEach-Object { $_.Substring($prefixLength) } | Invoke-Fzf
						}
						catch {}
					}
					else {
						$result = try {
							es -s -path . /ad | ForEach-Object { $_.Substring($prefixLength) } | Invoke-Fzf
						}
						catch {}
					}
				}
				else {
					if ($key.Key -eq 'T') {
						$result = try { Get-ChildItem -Force -Recurse -Name | Invoke-Fzf } catch {}
					}
					else {
						$result = try { Get-ChildItem -Force -Directory -Recurse -Name | Invoke-Fzf } catch {}
					}
				}
			}
			else {
				$result = try { Get-ChildItem -Recurse -Name | Invoke-Fzf } catch {}
			}
			[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			if ($result) {
				[Microsoft.PowerShell.PSConsoleReadLine]::Insert($result)
			}
		}

		Set-PSReadLineKeyHandler -Key 'Ctrl+t' -ScriptBlock $keyHandler
		Set-PSReadLineKeyHandler -Key 'Alt+c' -ScriptBlock $keyHandler
	}
}
