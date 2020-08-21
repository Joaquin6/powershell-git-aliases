<#
	.NOTES
	===========================================================================
	 Created on:	8/20/2020
	 Created by:	Joaquin6
	 Organization:
	 Filename:	SyncProfiles.ps1
	 URL:		https://gist.github.com/Joaquin6/a44e10ebf7ee3391a924acf721f340f6
	===========================================================================
	.DESCRIPTION
		Duplicates the powershell profile from Documents/PowerShell to Documents/WindowsPowerShell
		if it does not exist.
#>
[CmdletBinding()]
param ()

. $PSScriptRoot\Logger.ps1

$LASTEXITCODE = 0
$Global:ErrorActionPreference = 'Stop'
$Verbosity = $PSBoundParameters.ContainsKey('Verbose')

$PSDir = "PowerShell"
$WinPSDir = "WindowsPowerShell"
$PSProfileFile = "Microsoft.PowerShell_profile.ps1"
$PSISEProfileFile = "Microsoft.PowerShellISE_profile.ps1"

$Logger = [Logger]::new('SyncProfiles', $Verbosity)

function Sync-Profiles {
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[System.IO.FileInfo]$FromFile,
		[Parameter(Mandatory = $true, Position = 1)]
		[System.IO.FileInfo]$ToFile
	)

	$Logger.Verbose("`tSyncing '$ToFile'")

	if (!(Test-Path $ToFile)) {
		if (Test-Path $FromFile) {
			$Logger.Verbose("`tCopying profile '$FromFile' to '$ToFile'...")
			Copy-Item $FromFile $ToFile -Force
		} else {
			$Logger.Verbose("`tCreating profile '$ToFile'...")
			New-Item -Path $ToFile -ItemType file | Out-Null
		}
	}
}

Write-Output "`n Syncing Profiles...`n"

try {
	$docDir = [Environment]::getfolderpath("mydocuments")
	$PSProfile = Join-Path -Path $docDir\$PSDir -ChildPath $PSProfileFile
	$WinPSProfile = Join-Path -Path $docDir\$WinPSDir -ChildPath $PSProfileFile

	$Logger.Verbose("`tSyncing Profile '$PSProfileFile'...")

	Sync-Profiles -FromFile $WinPSProfile -ToFile $PSProfile
	Sync-Profiles -FromFile $PSProfile -ToFile $WinPSProfile

	$ISEPSProfile = Join-Path -Path $docDir\$PSDir -ChildPath $PSISEProfileFile
	$ISEWinPSProfile = Join-Path -Path $docDir\$WinPSDir -ChildPath $PSISEProfileFile

	$Logger.Verbose("`tSyncing Profile '$PSISEProfileFile'...")

	Sync-Profiles -FromFile $ISEWinPSProfile -ToFile $ISEPSProfile
	Sync-Profiles -FromFile $ISEPSProfile -ToFile $ISEWinPSProfile
}
catch {
	Write-Error "Profile Replication Failed!"

	# get error record
	$e = $_

	# retrieve information about runtime error
	$info = [PSCustomObject]@{
		Exception = $e.Exception.Message
		Reason    = $e.CategoryInfo.Reason
		Target    = $e.CategoryInfo.TargetName
		Script    = $e.InvocationInfo.ScriptName
		Line      = $e.InvocationInfo.ScriptLineNumber
		Column    = $e.InvocationInfo.OffsetInLine
		Params    = $PSBoundParameters
		Origin    = $e.InvocationInfo.CommandOrigin
	}

	# output information. Post-process collected info, and log info (optional)
	$info
	$Logger.Error($info, $false)
	$Logger.Destroy($true)
	exit 1
}

Write-Output "`n Synced Profiles Successfully!`n"
$Logger.Destroy($true)

exit $LASTEXITCODE
