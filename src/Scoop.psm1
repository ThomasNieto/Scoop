# Copyright (c) Thomas Nieto - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the MIT license.

class ScoopAppDetailed {
    [string] $Name
    [string] $Version
    [string] $Source
    [string] $Description
    [string] $Homepage
    [string[]] $Binaries
}

<#
    .SYNOPSIS
    Finds Scoop apps.

    .DESCRIPTION
    Finds Scoop apps in buckets.

    .PARAMETER Name
    Specifies the app name to find.

    .PARAMETER Bucket
    Specifies the bucket to find apps.
#>
function Find-ScoopApp {
    [CmdletBinding()]
    [OutputType([ScoopAppDetailed])]
    param (
        [Parameter(Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        $Name = '*',

        [Parameter(Position = 1,
            ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string]
        $Bucket = '*'
    )

    begin {
        try {
            $bucketPath = Get-Command -Name Scoop -CommandType ExternalScript -ErrorAction Stop |
            Select-Object -ExpandProperty Path |
            Split-Path |
            Split-Path |
            Join-Path -ChildPath buckets
        }
        catch {
            throw $_
        }
    }

    process {
        foreach ($_name in $Name) {
            Get-ChildItem -Path (Join-Path -Path $bucketPath -ChildPath "$Bucket/bucket/$_name.json") |
            ForEach-Object {
                $value = $_ | Get-Content | ConvertFrom-Json

                $binaries = if ($value.Bin) {
                    $value.Bin |
                    Where-Object { $_ -isnot [object[]] } |
                    Split-Path -Leaf
                } else {
                    $null
                }

                [ScoopAppDetailed]@{
                    Name        = $_.BaseName
                    Version     = $value.Version
                    Source      = ($_.Directory | Split-Path -Parent | Split-Path -Leaf)
                    Description = $value.Description
                    Binaries    = $binaries
                    Homepage    = $value.Homepage
                }
            }
        }
    }
}

<#
    .SYNOPSIS
    Get installed Scoop apps.

    .DESCRIPTION
    Get installed Scoop apps.

    .PARAMETER Name
    Specifies the app name.
#>
function Get-ScoopApp {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name = '*'
    )

    begin {
        $apps = scoop list 6>$null
    }

    process {
        foreach ($_name in $Name) {
            $apps |
            Where-Object Name -like $_name
        }
    }
}

<#
    .SYNOPSIS
    Install Scoop apps.

    .DESCRIPTION
    Install Scoop apps.

    .PARAMETER Name
    Specifies the app name.

    .PARAMETER Version
    Specifies the app version.

    .PARAMETER Architecture
    Specifies the app architecture.

    .PARAMETER Global
    Installs as a global app for all users.

    .PARAMETER SkipDependencies
    Skip installing app dependencies.

    .PARAMETER NoCache
    Does not use the download cache.

    .PARAMETER NoScoopUpdate
    Does not update Scoop.

    .PARAMETER SkipHashCheck
    Skips hash validation.
#>
function Install-ScoopApp {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [Parameter(Position = 1,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Version,

        [ValidateSet('32bit', '64bit', 'arm64')]
        [string]
        $Architecture,

        [switch]
        $Global,

        [switch]
        $SkipDependencies,

        [switch]
        $NoCache,

        [switch]
        $NoScoopUpdate,

        [switch]
        $SkipHashCheck
    )

    process {
        foreach ($_name in $Name) {
            if ($PSCmdlet.ShouldProcess($_name)) {
                if ($Version) {
                    $_name += "@$version"
                }

                $command = @('install', $_name)

                if ($PSBoundParameters.ContainsKey('Architecture')) {
                    $command += "--arch $Architecture"
                }

                if ($Global) { $command += "--global" }
                if ($SkipDependencies) { $command += "--independent" }
                if ($NoCache) { $command += "--no-cache" }
                if ($NoScoopUpdate) { $command += "--no-update-scoop" }
                if ($SkipHash) { $command += "--skip" }

                Write-Verbose -Message "scoop $($command -join ' ')"

                scoop @command 6>&1 |
                ForEach-Object {
                    if ($_ -match '^ERROR') {
                        throw ($_ -replace '^ERROR ')
                    }

                    Write-Verbose -Message $_
                }
            }
        }
    }
}

<#
    .SYNOPSIS
    Updates Scoop apps.

    .DESCRIPTION
    Updates Scoop apps.

    .PARAMETER Name
    Specifies the app to update.

    .PARAMETER Global
    Updates a globally installed app.

    .PARAMETER SkipDependencies
    Skip installing app dependencies.

    .PARAMETER NoCache
    Does not use download cache.

    .PARAMETER SkipHashCheck
    Skips hash validation.

    .PARAMETER Force
    Reinstalls the app even if there is not a newer version.
#>
function Update-ScoopApp {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string[]]
        $Name = '*',

        [switch]
        $Global,

        [switch]
        $SkipDependencies,

        [switch]
        $NoCache,

        [switch]
        $SkipHashCheck,

        [Alias('Reinstall')]
        [switch]
        $Force
    )

    process {
        foreach ($_name in $Name) {
            if ($PSCmdlet.ShouldProcess($_name)) {
                $command = @('update', $_name)

                if ($Global) { $command += "--global" }
                if ($SkipDependencies) { $command += "--independent" }
                if ($NoCache) { $command += "--no-cache" }
                if ($SkipHashCheck) { $command += "--skip" }
                if ($Force) { $command += "--force" }

                Write-Verbose -Message "scoop $($command -join ' ')"

                scoop @command 6>&1 |
                ForEach-Object {
                    if ($_ -match '^ERROR') {
                        throw ($_ -replace '^ERROR ')
                    }

                    Write-Verbose -Message $_
                }
            }
        }
    }
}

<#
.SYNOPSIS
Uninstalls Scoop apps.

.DESCRIPTION
Uninstalls Scoop apps.

.PARAMETER Name
Specifies the app name to uninstall.

.PARAMETER Global
Uninstalls a globally installed app.

.PARAMETER Purge
Remove all persistent data.

.EXAMPLE
An example

.NOTES
General notes
#>
function Uninstall-ScoopApp {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [switch]
        $Global,

        [switch]
        $Purge
    )

    process {
        foreach ($_name in $Name) {
            if ($PSCmdlet.ShouldProcess($_name)) {
                $command = @('uninstall', $_name)

                if ($Global) { $command += "--global" }
                if ($Purge) { $command += "--purge" }

                Write-Verbose -Message "scoop $($command -join ' ')"

                scoop @command 6>&1 |
                ForEach-Object {
                    if ($_ -match '^ERROR') {
                        throw ($_ -replace '^ERROR ')
                    }

                    Write-Verbose -Message $_
                }
            }
        }
    }
}

<#
    .SYNOPSIS
    Optimizes Scoop apps.

    .DESCRIPTION
    Removes old versions of installed Scoop apps.

    .PARAMETER Global
    Cleanup a globally installed app.

    .PARAMETER DownloadCache
    Remove outdated download cache
#>
function Optimize-ScoopApp {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name = '*',

        [switch]
        $Global,

        [switch]
        $DownloadCache
    )

    process {
        foreach ($_name in $Name) {
            foreach ($app in (Get-ScoopApp -Name $_name))
            {
                if ($PSCmdlet.ShouldProcess($app.Name)) {
                    $command = @('cleanup', $app.Name)

                    if ($Global) { $command += "--global" }
                    if ($DownloadCache) { $command += "--cache" }

                    Write-Verbose -Message "scoop $($command -join ' ')"

                    scoop @command 6>&1 |
                    ForEach-Object {
                        if ($_ -match '^ERROR') {
                            throw ($_ -replace '^ERROR ')
                        }

                        Write-Verbose -Message $_

                        if ($_ -match 'Removing (?<name>.+): (?<versions>.+)')
                        {
                            $matches['versions'] -split ' ' |
                            ForEach-Object {
                                [ScoopAppDetailed]@{
                                    Name = $Matches['name']
                                    Version = $_
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

<#
    .SYNOPSIS
    Get Scoop buckets.

    .DESCRIPTION
    Get Scoop buckets.

    .PARAMETER Name
    Specifies the bucket.
#>
function Get-ScoopBucket {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name = '*'
    )

    begin {
        $sources = scoop bucket list 6>$null
    }

    process {
        foreach ($_name in $Name) {
            $sources |
            Where-Object Name -like $_name
        }
    }
}

<#
    .SYNOPSIS
    Registers a Scoop bucket.

    .DESCRIPTION
    Registers a Scoop bucket.

    .PARAMETER Name
    Specifies the bucket name.

    .PARAMETER Uri
    Specifies the bucket Uri.

    .PARAMETER Official
    Specifies an official bucket.

    .PARAMETER Force
    Reregister the bucket if it already exists.
#>
function Register-ScoopBucket {
    [CmdletBinding(DefaultParameterSetName = 'Name',
        SupportsShouldProcess,
        ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory,
            ParameterSetName = 'Name',
            Position = 0)]
        [string]
        $Name,

        [Parameter(Mandatory,
            ParameterSetName = 'Name',
            Position = 1)]
        [string]
        $Uri,

        [Parameter(Mandatory,
            ParameterSetName = 'Official')]
        [ValidateScript({
                if ($_ -in (scoop bucket known)) {
                    $true
                }
                else {
                    throw "Bucket '$_' is not an official bucket."
                }
            })]
        [string]
        $Official,

        [Parameter()]
        [switch]
        $Force
    )

    if ($PSCmdlet.ParameterSetName -eq 'Official') {
        $Name = $Official
    }

    $existing = Get-ScoopBucket -Name $Name

    if ($existing -and -not $Force) {
        throw "Bucket '$Name' already exists."
    }

    if ($PSCmdlet.ShouldProcess($Name)) {
        if ($existing) {
            scoop bucket rm $Name
        }

        scoop bucket add $Name $Uri 6>&1 |
        ForEach-Object {
            if ($_ -match '^ERROR') {
                throw ($_ -replace '^ERROR ')
            }

            Write-Verbose -Message $_
        }
    }
}

<#
    .SYNOPSIS
    Unregister Scoop bucket.

    .DESCRIPTION
    Unregister Scoop bucket.

    .PARAMETER Name
    Specifies the bucket name to unregister.
#>
function Unregister-ScoopBucket {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    if (-not (Get-ScoopBucket -Name $Name)) {
        throw "Bucket '$Name' does not exist."
    }

    if ($PSCmdlet.ShouldProcess($Name)) {
        scoop bucket rm $Name
    }

    if (Get-ScoopBucket -Name $Name) {
        throw "Failed to remove bucket '$Name'."
    }
}
