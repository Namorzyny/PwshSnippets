New-Item -Path "$HOME\.local\bin" -ItemType Directory -Force | Out-Null
$Env:PATH = "$HOME\.local\bin;$Env:PATH"
