# PowerShell git aliases
[![license](https://img.shields.io/github/license/Joaquin6/powershell-git-aliases)](./LICENSE)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSGitAliases.svg?style=flat-square)](https://www.powershellgallery.com/packages/PSGitAliases/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSGitAliases.svg?style=flat-square)](https://www.powershellgallery.com/packages/PSGitAliases/)

A PowerShell module that provides commonly used git aliases.

## ⚙️ Installation

Install from [PowerShell Gallery](https://www.powershellgallery.com/)

```powershell
Install-Module PSGitAliases -Scope CurrentUser -AllowClobber
```

---

⚠️ If you haven't allowed script execution policy, set your script execution policy to `RemoteSigned` or `Unrestricted`.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🛂 Usage

You have to import the module to use `PSGitAliases`.

Add below command into your PowerShell profile.

```powershell
Import-Module PSGitAliases -DisableNameChecking
```

Then restart your PowerShell.
Now you can use Git aliases.

---

⚠️ If you don't have PowerShell profile yet, create it with below command!

```powershell
New-Item -ItemType File $profile
```
