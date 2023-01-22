#Requires -Modules Scoop

Describe Update-ScoopApp {
    BeforeEach {
        & scoop install 7zip *>$null
        & scoop install ack *>$null
    }

    AfterEach {
        & scoop uninstall 7zip *>$null
        & scoop uninstall ack *>$null
    }

    Context 'with no additional parameters' {
        It 'single name' {
            { Update-ScoopApp -Name 7zip } | Should -Not -Throw
        }

        It 'multiple names' {
            { Update-ScoopApp -Name 7zip, ack } | Should -Not -Throw
        }
    }

    Context 'with additional parameters' {
        It 'with -SkipDependencies' {
            { Update-ScoopApp -Name ack -SkipDependencies } | Should -Not -Throw
        }

        It 'with -NoCache' {
            { Update-ScoopApp -Name 7zip -NoCache } | Should -Not -Throw
        }

        It 'with -SkipHashCheck' {
            { Update-ScoopApp -Name 7zip -SkipHashCheck } | Should -Not -Throw
        }
    }
}
