<#
	.NOTES
	===========================================================================
	 Created on:   	8/20/2020
	 Created by:   	Joaquin6
	 Organization:
	 Filename:     	Install_to_UserModules.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Import-Module -Force .\PSGitAliases

$version = Get-PSGit-Aliases-Version
Write-Host "PSGitAliases Version...."
Write-Host $version

if ($PSVersionTable.PSVersion.Major -lt 3) {
	Write-Warning "PSGitAliases requires Powershell 3.0 or above"
	return
}

$docDir = [Environment]::getfolderpath("mydocuments")
$importModule = "Import-Module PSGitAliases"
$importModuleLogic = @'

$PSGitAliasesModuleDir = "$([Environment]::getfolderpath('mydocuments'))\PowerShell\Modules\PSGitAliases"

if (Test-Path $PSGitAliasesModuleDir)
{
	Import-Module PSGitAliases
}

'@

$Global:ErrorActionPreference = 'Stop'

$currentDir = Split-Path -parent $MyInvocation.MyCommand.Path
$moduleDir = "$docDir\PowerShell\Modules\PSGitAliases"
$profileFile = "$docDir\PowerShell\Microsoft.PowerShell_profile.ps1"
$excludeCopy = @(".git", ".gitignore", ".editorconfig", ".vscode", "*.psproj", "*.psprojs", "*.psproj.*", "*.TempPoint.*", "README.md", "LICENSE", "*.bat", "Install_to_UserModules.ps1")

if (!(Test-Path $moduleDir)) {
	Write-Host "Creating directory '$moduleDir'..." -NoNewline
	New-Item -Path $moduleDir -ItemType Directory | Out-Null
	Write-Host "OK"
}
Write-Host "Unblocking PSGitAliases files..." -NoNewLine
Get-ChildItem (Join-Path $currentDir "..") | Unblock-File
Write-Host "OK"

Write-Host "Copying PSGitAliases files to '$moduleDir'..." -NoNewline
Copy-Item -Path (Join-Path $currentDir "..\*") -Destination $moduleDir -Exclude $excludeCopy -Recurse -Force
Write-Host "OK"

Write-Host ""

if (!(Test-Path $profileFile)) {
	Write-Host "Creating file '$profileFile'..." -NoNewline
	New-Item -Path $profileFile -ItemType file | Out-Null
	Write-Host "OK"
	$contents = ""
}
else {
	Write-Host "Reading file '$profileFile'..." -NoNewLine
	$contents = Get-Content -Path $profileFile | Out-String
	Write-Host "OK"
}

if ($contents -inotmatch $importModule) {
	Write-Host "Adding '$importModule'..." -NoNewLine
	Add-Content -Path $profileFile -Value $importModuleLogic | Out-Null
	Write-Host "OK"
}
else {
	Write-Host "Import command for PSGitAliases already exists in profile file."
}
