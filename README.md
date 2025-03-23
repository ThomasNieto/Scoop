# Scoop

[![gallery-image]][gallery-site]
[![build-image]][build-site]

[gallery-image]: https://img.shields.io/powershellgallery/dt/Scoop?logo=powershell
[build-image]: https://img.shields.io/github/actions/workflow/status/ThomasNieto/Scoop/ci.yml
[gallery-site]: https://www.powershellgallery.com/packages/Scoop
[build-site]: https://github.com/ThomasNieto/Scoop/actions/workflows/ci.yml

An unofficial PowerShell module wrapper for Scoop using PowerShell best
practices.

## Installing Scoop

> NOTE: Prerequisite [install scoop](https://scoop.sh/).

```powershell
Install-PSResource -Name Scoop
```

## Cmdlets

- `Find-ScoopApp`
- `Get-ScoopApp`
- `Install-ScoopApp`
- `Optimize-ScoopApp`
- `Uninstall-ScoopApp`
- `Update-ScoopApp`
- `Get-ScoopBucket`
- `Register-ScoopBucket`
- `Unregister-ScoopBucket`
