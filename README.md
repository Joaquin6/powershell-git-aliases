# Git aliases for PowerShell
[![license](https://img.shields.io/github/license/Joaquin6/powershell-git-aliases)](./LICENSE)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/git-aliases.svg?style=flat-square)](https://www.powershellgallery.com/packages/git-aliases/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/git-aliases.svg?style=flat-square)](https://www.powershellgallery.com/packages/git-aliases/)

A [PowerShell](https://microsoft.com/powershell) module that provide partial **[Git](https://git-scm.com/)** aliases from [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)'s [git plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/git/).

## ⚙️ Installation

Install from [PowerShell Gallery](https://www.powershellgallery.com/)

```powershell
Install-Module git-aliases -Scope CurrentUser -AllowClobber
```

---

⚠️ If you haven't allowed script execution policy, set your script execution policy to `RemoteSigned` or `Unrestricted`.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🛂 Usage

You have to import the module to use `git-aliases`.

Add below command into your PowerShell profile.

```powershell
Import-Module git-aliases -DisableNameChecking
```

Then restart your PowerShell.
Now you can use Git aliases.

---

⚠️ If you don't have PowerShell profile yet, create it with below command!

```powershell
New-Item -ItemType File $profile
```
