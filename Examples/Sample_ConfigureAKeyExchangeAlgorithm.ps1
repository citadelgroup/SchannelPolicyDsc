<#
    .SYNOPSIS
        Configures the 'PKCS' key exchange algorithm to be disabled.
#>
Configuration Sample_ConfigureAKeyExchangeAlgorithm {
    Import-DscResource -ModuleName 'SchannelPolicyDsc'

    Node localhost {
        Cipher "Disable PKCS" {
            KeyExchangeAlgorithm = "PKCS"
            Ensure = "Absent"
        }
    }
}
