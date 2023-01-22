#Requires -Modules Scoop

Describe Get-ScoopApp {
    BeforeAll {
        & scoop install 7zip 6>$null
        & scoop install abc 6>$null
    }

    AfterAll {
        & scoop uninstall 7zip 6>$null
        & scoop uninstall abc 6>$null
    }

    Context 'with no parameters' {
        It 'returns results' {
            Get-ScoopApp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'with -Name parameter' {
        It 'single name' {
            Get-ScoopApp -Name 7zip | Should -Not -BeNullOrEmpty
        }

        It 'multiple names' {
            Get-ScoopApp -Name 7zip, abc | Should -HaveCount 2
        }
    }
}
