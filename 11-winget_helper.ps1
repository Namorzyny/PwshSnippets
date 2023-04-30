function upgrade {
	$lengthId = 0
	$lengthVersion = 0
	$lengthNewVersion = 0

	$upgradable = winget upgrade --disable-interactivity | grep winget | awk '{print $(NF-3), $(NF-2), $(NF-1)}' | ForEach-Object {
		$id = $_.Split(' ')[0]
		$version = $_.Split(' ')[1]
		$newVersion = $_.Split(' ')[2]

		if ($id.Length -gt $lengthId) {
			$lengthId = $id.Length
		}

		if ($version.Length -gt $lengthVersion) {
			$lengthVersion = $version.Length
		}

		if ($newVersion.Length -gt $lengthNewVersion) {
			$lengthNewVersion = $newVersion.Length
		}

		@{
			id         = $id;
			version    = $version;
			newVersion = $newVersion;
		}
	}

	function showList($list) {
		$list | ForEach-Object {
			$id = $_.id.padRight($lengthId)
			$version = $_.version.padRight($lengthVersion)
			$newVersion = $_.newVersion.padRight($lengthNewVersion)
			Write-Host "$id $version -> $newVersion"
		}
	}

	if ($args) {
		$pattern = "^.*($($args -join '|')).*$"
		$list = $upgradable | Where-Object { $_.id -match $pattern }
		if ($list.Count -eq 0) {
			Write-Host 'No upgradable packages!' -ForegroundColor Green
			return
		}
		Write-Host "`nThis packages will be upgraded" -ForegroundColor Magenta
		Write-Host "--------------------------------`n" -ForegroundColor Magenta
		showList $list
		Write-Host "`nUpgrade? [Y/n]: " -NoNewline -ForegroundColor Yellow
		$answer = Read-Host
		if ($answer -eq '' -or $answer[0].ToLower() -eq 'y' ) {
			$list | ForEach-Object {
				Write-Host "`nUpgrading $($_.id) ...`n" -ForegroundColor Blue
				winget upgrade $_.id --disable-interactivity
			}
		}
		return
	}

	if ($upgradable.Count -eq 0) {
		Write-Host 'No upgradable packages!' -ForegroundColor Green
		return
	}
	Write-Host "`nUpgradable packages" -ForegroundColor Magenta
	Write-Host "---------------------`n" -ForegroundColor Magenta
	showList $upgradable
}
