Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

try {
	Set-PSReadLineOption -PredictionSource History
	Set-PSReadLineOption -Colors @{InlinePrediction = '#777777' }

	Set-PSReadLineKeyHandler -Key RightArrow -ScriptBlock {
		param($key, $arg)
		$line = $null
		$cursor = $null
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
		if ($cursor -lt $line.Length) {
			[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
		}
		else {
			[Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
		}
	}

	Invoke-Command {
		$toEndHandler = {
			param($key, $arg)
			$line = $null
			$cursor = $null
			[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
			if ($cursor -lt $line.Length) {
				[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine($key, $arg)
			}
			else {
				[Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
			}
		}

		Set-PSReadLineKeyHandler -Key 'End' -ScriptBlock $toEndHandler
		Set-PSReadLineKeyHandler -Key 'Ctrl+e' -ScriptBlock $toEndHandler
	}
}
catch {
	Write-Warning 'A new version of PSReadLine is need. Run: Install-Module PSReadLine -Scope CurrentUser -Force'
}
