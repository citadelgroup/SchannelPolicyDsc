<#
    .SYNOPSIS
        Configures the preferred cipher suite order.
#>
Configuration Sample_ConfigureACipherSuiteOrder {
    Import-DscResource -ModuleName 'SchannelPolicyDsc'

    Node localhost {
        CipherSuites "Set Cipher Suite Order" {
            IsSingleInstance = "Yes"
            CipherSuitesOrder = @('TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521',
                                  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384',
                                  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256',
                                  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P521',
                                  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384',
                                  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256',
                                  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P521',
                                  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384',
                                  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256',
                                  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P521',
                                  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384',
                                  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P521',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P521',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P384',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P521',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P521',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P384',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P521',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384',
                                  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P521',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384',
                                  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256')
        }
    }
}
