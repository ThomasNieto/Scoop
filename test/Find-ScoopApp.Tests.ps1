#Requires -Modules Scoop

Describe Find-ScoopApp {
    Context 'with no parameters' {
        It 'returns results' {
            Find-ScoopApp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'with -Name parameter' {
        It 'single name' {
            Find-ScoopApp -Name 7zip | Should -Not -BeNullOrEmpty
        }

        It 'multiple names' {
            Find-ScoopApp -Name 7zip, ack | Should -HaveCount 2
        }
    }

    Context 'with -Bucket parameter' {
        BeforeAll {
            & scoop bucket add nirsoft 6>$null
        }

        It 'with -Bucket nirsoft' {
            $result = Find-ScoopApp -Bucket nirsoft
            $result | Should -Not -BeNullOrEmpty
            $result | Select-Object -ExpandProperty Source -Unique | Should -Be nirsoft
        }

        AfterAll {
            & scoop bucket rm nirsoft 6>$null
        }
    }
}
