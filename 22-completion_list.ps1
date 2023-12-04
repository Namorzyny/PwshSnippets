$CompletionModuleList = @{
	'wsl'   = { Import-Module -Name WSLTabCompletion };
	'git'   = { Import-Module -Name posh-git };
	'scoop' = { Import-Module -Name scoop-completion };
	'npm'   = { Import-Module -Name npm-completion };
	'yarn'  = { Import-Module -Name yarn-completion };
	'conda' = { Import-Module -Name CondaTabExpansion };
}

$CompletionModuleList.Keys | ForEach-Object {
	Register-CompletionLoader $_ $CompletionModuleList[$_]
}
