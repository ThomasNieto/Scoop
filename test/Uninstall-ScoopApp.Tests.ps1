#Requires -Modules Scoop

Describe Uninstall-ScoopApp {
    BeforeEach {
        & scoop install 7zip 6>$null
        & scoop install ack 6>$null
    }

    AfterAll {
        & scoop uninstall 7zip 6>$null
        & scoop uninstall ack 6>$null
    }

    Context 'with -Name parameter' {
        It 'single name' {
            { Uninstall-ScoopApp -Name 7zip } | Should -Not -Throw
        }

        It 'multiple names' {
            { Uninstall-ScoopApp -Name 7zip, ack } | Should -Not -Throw
        }
    }

    Context 'with additional parameters' {
        It 'with -Purge parameter' {
            { Uninstall-ScoopApp -Name 7zip -Purge } | Should -Not -Throw
        }
    }
}
