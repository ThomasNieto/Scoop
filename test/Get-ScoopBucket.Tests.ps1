#Requires -Modules Scoop

Describe Get-ScoopBucket {
    BeforeAll {
        & scoop bucket add nirsoft 6>$null
    }

    AfterAll {
        & scoop bucket rm nirsoft 6>$null
    }

    Context 'with no parameters' {
        It 'returns results' {
            Get-ScoopBucket | Should -Not -BeNullOrEmpty
        }
    }

    Context 'with -Name parameter' {
        It 'single name' {
            Get-ScoopBucket -Name main | Should -Not -BeNullOrEmpty
        }

        It 'mutiple names' {
            Get-ScoopBucket -Name main, nirsoft | Should -HaveCount 2
        }
    }
}
