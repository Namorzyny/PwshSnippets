$CommandInterruptorList = @{}
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	$command = $line.ToLower().Split(' ')[0]

	$interruptor = $CommandInterruptorList[$command]
	if ($null -ne $interruptor) {
		&$interruptor $line $cursor
	}

	[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function Register-CommandInterruptor {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name,

		[Parameter(Mandatory = $true)]
		[ScriptBlock]$ScriptBlock
	)

	$CommandInterruptorList[$Name] = $ScriptBlock
}

function Unregister-CommandInterruptor {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name
	)

	$CommandInterruptorList.Remove($Name)
}
