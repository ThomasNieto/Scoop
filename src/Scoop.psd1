@{
    RootModule = 'Scoop.psm1'
    ModuleVersion = '0.1.2'
    CompatiblePSEditions = @('Desktop', 'Core')
    GUID = '7603664e-144c-4083-a51d-399df057a37d'
    Author = 'Thomas Nieto'
    Copyright = '(c) 2023 Thomas Nieto. All rights reserved.'
    Description = 'A PowerShell module for Scoop.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Find-ScoopApp', 'Get-ScoopApp', 'Install-ScoopApp',
    'Update-ScoopApp', 'Uninstall-ScoopApp', 'Get-ScoopBucket',
    'Register-ScoopBucket', 'Unregister-ScoopBucket')
    CmdletsToExport = @()
    AliasesToExport = @()
    FileList = @('Scoop.psd1', 'Scoop.psm1')
    PrivateData = @{
        PSData = @{
            Tags = @('Scoop', 'Windows')
            LicenseUri = 'https://github.com/ThomasNieto/Scoop/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ThomasNieto/Scoop'
        }
    }
}
