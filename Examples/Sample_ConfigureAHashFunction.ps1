<#
    .SYNOPSIS
        Configures the 'MD5' hash function to be disabled.
#>
Configuration Sample_ConfigureAHashFunction {
    Import-DscResource -ModuleName 'SchannelPolicyDsc'

    Node localhost {
        Hash "Disable MD5" {
            Hash = "MD5"
            Ensure = "Absent"
        }
    }
}
