## My PowerShell Snippets

1. Clone to somewhere
2. Import what you want in your `profile.ps1`

	- `Get-ChildItem $PSScriptRoot\PwshSnippets\*.ps1 | ForEach-Object {. $_.FullName}`
	- `. $PSScriptRoot\PwshSnippets\30-fzf_with_everything.ps1`
