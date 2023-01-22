#Requires -Modules Scoop

Describe Unregister-ScoopBucket {
    BeforeEach {
        & scoop bucket add nirsoft 6>$null
    }

    AfterAll {
        & scoop bucket rm nirsoft 6>$null
    }

    Context 'with -Name parameter' {
        It 'with invalid name' {
            { Unregister-ScoopBucket -Name doesnotexist } | Should -Throw
        }

        It 'with valid uri' {
            { Unregister-ScoopBucket -Name nirsoft } | Should -Not -Throw
        }
    }
}
