$CompletionLoaderList = @{}
$CompletionLoaderStatus = @{}
Set-PSReadLineKeyHandler -Chord Tab -ScriptBlock {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	$command = $line.ToLower()

	$CompletionLoaderList.Keys | ForEach-Object {
		if ($command.StartsWith("$_") -and $false -eq $CompletionLoaderStatus[$_]) {
			Invoke-Command -ScriptBlock $CompletionLoaderList[$_]
			$CompletionLoaderStatus[$_] = $true
		}
	}

	[Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete()
}

function Register-CompletionLoader {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name,

		[Parameter(Mandatory = $true)]
		[ScriptBlock]$ScriptBlock
	)

	$CompletionLoaderList[$Name] = $ScriptBlock
	$CompletionLoaderStatus[$Name] = $false
}

function Unregister-CompletionLoader {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name
	)

	$CompletionLoaderList.Remove($Name)
	$CompletionLoaderStatus.Remove($Name)
}
