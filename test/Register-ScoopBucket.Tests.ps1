#Requires -Modules Scoop

Describe Register-ScoopBucket {
    AfterEach {
        & scoop bucket rm nirsoft 6>$null
    }

    Context 'with -Name parameter' {
        It 'with invalid uri' {
            { Register-ScoopBucket -Name nirsoft -Uri broke } | Should -Throw
        }

        It 'with valid uri' {
            { Register-ScoopBucket -Name nirsoft -Uri https://github.com/kodybrown/scoop-nirsoft } |
            Should -Not -Throw
        }
    }

    Context 'with -Official parameter' {
        It 'with invalid bucket' {
            { Register-ScoopBucket -Official broke } | Should -Throw
        }

        It 'with valid bucket' {
            { Register-ScoopBucket -Official nirsoft } | Should -Not -Throw
        }
    }

    Context 'with -Force parameter' {
        & scoop bucket add nirsoft 6>$null
        { Register-ScoopBucket -Official nirsoft -Force } | Should -Not -Throw
    }
}
