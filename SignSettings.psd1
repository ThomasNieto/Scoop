@{
    Files = @(
        'Scoop.psd1',
        'Scoop.psm1'
    )
    SetAuthenicodeSignatureParameters = @{
        TimeStampServer = 'http://timestamp.sectigo.com'
    }
}