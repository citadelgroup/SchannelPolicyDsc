<#
    .SYNOPSIS
        Configures the 'TLS 1.0' protocol to be disabled on both client and server.
#>
Configuration Sample_ConfigureAProtocol {
    Import-DscResource -ModuleName 'SchannelPolicyDsc'

    Node localhost {
        Protocol "Disable TLS 1.0 Client" {
            Protocol = "TLS 1.0"
            Type = "Client"
            Ensure = "Absent"
        }
        
        Protocol "Disable TLS 1.0 Server" {
            Protocol = "TLS 1.0"
            Type = "Server"
            Ensure = "Absent"
        }
    }
}
