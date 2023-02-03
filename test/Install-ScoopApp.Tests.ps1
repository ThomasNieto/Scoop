#Requires -Modules Scoop

Describe Install-ScoopApp {
    AfterEach {
        & scoop uninstall 7zip *>$null
        & scoop uninstall ack *>$null
    }

    Context 'with no additional parameters' {
        It 'single name' {
            { Install-ScoopApp -Name 7zip } | Should -Not -Throw
        }

        It 'multiple names' {
            { Install-ScoopApp -Name 7zip, ack } | Should -Not -Throw
        }
    }

    Context 'with additional parameters' {
        It 'with -Architecture' {
            { Install-ScoopApp -Name 7zip -Architecture 32bit } | Should -Not -Throw
        }

        It 'with -SkipDependencies' {
            { Install-ScoopApp -Name ack -SkipDependencies } | Should -Not -Throw
        }

        It 'with -NoCache' {
            { Install-ScoopApp -Name 7zip -NoCache } | Should -Not -Throw
        }

        It 'with -NoScoopUpdate' {
            { Install-ScoopApp -Name 7zip -NoScoopUpdate } | Should -Not -Throw
        }

        It 'with -SkipHashCheck' {
            { Install-ScoopApp -Name 7zip -SkipHashCheck } | Should -Not -Throw
        }
    }
}
