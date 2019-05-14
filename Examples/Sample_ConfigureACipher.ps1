<#
    .SYNOPSIS
        Configures the 'RC2 128/128' cipher to be disabled.
#>
Configuration Sample_ConfigureACipher {
    Import-DscResource -ModuleName 'SchannelPolicyDsc'

    Node localhost {
        Cipher "Disable RC2" {
            Cipher = "RC2 128/128"
            Ensure = "Absent"
        }
    }
}
