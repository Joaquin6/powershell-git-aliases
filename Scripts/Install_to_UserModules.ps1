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

$Global:ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -lt 3) {
	Write-Warning "PSGitAliases requires Powershell 3.0 or above"
	return
}

$importModule = "Import-Module PSGitAliases"
$installModule = "Find-Module -Name PSGitAliases | Install-Module -Scope CurrentUser -AllowClobber"

$docDir = [Environment]::getfolderpath("mydocuments")
$currentDir = Split-Path -parent $MyInvocation.MyCommand.Path
$moduleDir = "$docDir\PowerShell\Modules\PSGitAliases"
$profileFile = "$docDir\PowerShell\Microsoft.PowerShell_profile.ps1"
$excludeCopy = @(".git", ".gitignore", ".editorconfig", ".vscode", "*.psproj", "*.psprojs", "*.psproj.*", "*.TempPoint.*", "README.md", "LICENSE", "Scripts/*")

if (Test-Path $moduleDir) {
	Write-Host "Removing directory '$moduleDir'..."
	Remove-Item $moduleDir
	Write-Host "OK"
}

if (!(Test-Path $moduleDir)) {
	Write-Host "Creating directory '$moduleDir'..."
	New-Item -Path $moduleDir -ItemType Directory | Out-Null
	Write-Host "OK"
}

Write-Host "Unblocking PSGitAliases files..."
Get-ChildItem (Join-Path $currentDir "..") | Unblock-File
Write-Host "OK"

Write-Host "Copying PSGitAliases files to '$moduleDir'..."
Copy-Item -Path (Join-Path $currentDir "..\PSGitAliases\*") -Destination $moduleDir -Exclude $excludeCopy -Recurse -Force
Write-Host "OK"

Write-Host ""

if (!(Test-Path $profileFile)) {
	Write-Host "Creating file '$profileFile'..."
	New-Item -Path $profileFile -ItemType file | Out-Null
	Write-Host "OK"
	$contents = ""
}
else {
	Write-Host "Reading file '$profileFile'..."
	$contents = Get-Content -Path $profileFile | Out-String
	Write-Host "OK"
}

if ($contents -inotmatch $installModule)
{
	Write-Host "Adding '$installModule'..."
	Add-Content -Path $profileFile -Value $installModule | Out-Null
	Write-Host "OK"
}
else
{
	Write-Host "Install command for PSGitAliases already exists in profile file."
}

if ($contents -inotmatch $importModule) {
	Write-Host "Adding '$importModule'..."
	Add-Content -Path $profileFile -Value $importModule | Out-Null
	Write-Host "OK"
}
else {
	Write-Host "Import command for PSGitAliases already exists in profile file."
}
