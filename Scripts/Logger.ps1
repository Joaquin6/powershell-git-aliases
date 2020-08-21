<#
	.NOTES
	===========================================================================
	 Created on:	8/20/2020
	 Created by:	Joaquin6
	 Organization:
	 Filename:	Logger.ps1
	 URL:		https://gist.github.com/Joaquin6/a44e10ebf7ee3391a924acf721f340f6#file-logger-ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

class Logger
{
	#region Properties
	[string]$LogFile
	[string]$Timestamp
	[string]$LogFilePath
	[switch]$ToScreen = $false
	[string]$ScriptVersion = '1.0'
	[string]$LogPath = 'C:\Windows\Temp'
	[string]$LogName = 'PSGitAliases'
	#endregion Properties

	Logger ([string]$LogName, [switch]$ToScreen)
	{
		$this.LogName = $LogName
		$this.ToScreen = $ToScreen

		$this.Timestamp = (Get-Date -format 'yyyyMMddmmss')
		$this.LogName = $this.LogName + "." + $this.Timestamp + ".log"
		$this.LogFilePath = Join-Path -Path $this.LogPath -ChildPath $this.LogName

		$this.SetVerbosity()
		$this.StartLog()
	}

	#region Hidden Methods
	hidden [void]StartLog ()
	{
		$version = $this.ScriptVersion

		#Check if file exists and delete if it does
		If (Test-Path -Path $this.LogFilePath)
		{
			Remove-Item -Path $this.LogFilePath -Force
		}

		#Create file and start logging
		New-Item -Path $this.LogFilePath -ItemType File

		Add-Content -Path $this.LogFilePath -Value "***************************************************************************************************"
		Add-Content -Path $this.LogFilePath -Value "Started processing at [$([DateTime]::Now)]."
		Add-Content -Path $this.LogFilePath -Value "***************************************************************************************************"
		Add-Content -Path $this.LogFilePath -Value ""
		Add-Content -Path $this.LogFilePath -Value "Running script version [$version]."
		Add-Content -Path $this.LogFilePath -Value ""
		Add-Content -Path $this.LogFilePath -Value "***************************************************************************************************"
		Add-Content -Path $this.LogFilePath -Value ""

		If ($this.ToScreen -eq $true)
		{
			#Write to scren for ToScreen mode
			Write-Host "***************************************************************************************************"
			Write-Host "Started processing at [$([DateTime]::Now)]."
			Write-Host "***************************************************************************************************"
			Write-Host ""
			Write-Host "Running script version [$version]."
			Write-Host ""
			Write-Host "***************************************************************************************************"
			Write-Host ""
		}
	}
	#endregion Hidden Methods

	#region Methods
	[void]SetLogPath([string]$logpath)
	{
		if (-not ($this.LogPath -eq $logpath))
		{
			$this.LogPath = $logpath
			$this.LogFilePath = Join-Path -Path $this.LogPath -ChildPath $this.LogName
		}
	}

	[void]SetVerbosity()
	{
		if ($this.ToScreen -eq $True)
		{
			$DebugPreference = 'Continue'
			$VerbosePreference = 'Continue'
		}
	}

	[void]Info([string]$message)
	{
		#Write Content to Log
		Add-Content -Path $this.LogFilePath -Value $Message
	}

	[void]Verbose([string]$message)
	{
		$this.Info($message)

		If ($this.ToScreen -eq $true)
		{
			#Write to scren for ToScreen mode
			Write-Host $Message
		}
	}

	[void]Warning([string]$message)
	{
		#Write Content to Log
		Add-Content -Path $this.LogFilePath -Value "WARNING: $Message"

		If ($this.ToScreen -eq $true)
		{
			#Write to screen for debug mode
			Write-Debug "WARNING: $Message"
			#Write to scren for ToScreen mode
			Write-Host "WARNING: $Message"
		}
	}

	[void]Error([string]$Message, [switch]$ExitGracefully)
	{
		#Write Content to Log
		Add-Content -Path $this.LogFilePath -Value "ERROR: $Message"

		If ($this.ToScreen -eq $true)
		{
			#Write to screen for debug mode
			Write-Debug "ERROR: $Message"
			#Write to scren for ToScreen mode
			Write-Host "ERROR: $Message"
		}

		#If $ExitGracefully = True then run Log-Finish and exit script
		If ($ExitGracefully -eq $True)
		{
			Add-Content -Path $this.LogFilePath -Value " "
			$this.Destroy()
			Break
		}
	}

	[void]Destroy([switch]$NoExit)
	{
		Add-Content -Path $this.LogFilePath -Value ""
		Add-Content -Path $this.LogFilePath -Value "***************************************************************************************************"
		Add-Content -Path $this.LogFilePath -Value "Finished processing at [$([DateTime]::Now)]."
		Add-Content -Path $this.LogFilePath -Value "Log File Location: '$($this.LogFilePath)'"
		Add-Content -Path $this.LogFilePath -Value "***************************************************************************************************"

		If ($this.ToScreen -eq $true)
		{
			#Write to screen for debug mode
			Write-Debug ""
			Write-Debug "***************************************************************************************************"
			Write-Debug "Finished processing at [$([DateTime]::Now)]."
			Write-Debug "Log File Location: '$($this.LogFilePath)'"
			Write-Debug "***************************************************************************************************"

			#Write to scren for ToScreen mode
			Write-Host ""
			Write-Host "***************************************************************************************************"
			Write-Host "Finished processing at [$([DateTime]::Now)]."
			Write-Host "Log File Location: '$($this.LogFilePath)'"
			Write-Host "***************************************************************************************************"
		}

		#Exit calling script if NoExit has not been specified or is set to False
		If (!($NoExit) -or ($NoExit -eq $False))
		{
			Exit
		}
	}
	#endregion Methods
}
