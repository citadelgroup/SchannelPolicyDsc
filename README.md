# SchannelPolicyDsc

SchannelPolicyDsc is a module written to provide PowerShell DSC configuration resources to manipulate Schannel.

## Resources

* [Cipher](#cipher): Provides a mechanism to set individual ciphers.
* [CipherSuites](#ciphersuites): Provides a mechanism to set cipher suite order.
* [Hash](#hash): Provides a mechanism to set individual hash functions.
* [KeyExchangeAlgorithm](#keyexchangealgorithm): Provides a mechanism to set individual key exchange algorithms.
* [Protocol](#Protocol): Provides a mechanism to set individual protocols.

### Cipher

Provides a mechanism to set individual ciphers.

#### Requirements

None

#### Parameters

* **[String] Cipher** _(Key)_: The name of the cipher you want to configure. { AES 128/128 | AES 256/256 | DES 56/56 | NULL | RC2 128/128 | RC2 40/128 | RC2 56/128 | RC4 128/128 | RC4 40/128 | RC4 56/128 | RC4 64/128 | Triple DES 168 }
* **[String] Ensure** _(Write)_: The desired state of the cipher. { *Present* | Absent }

#### Read-Only Properties from Get-TargetResource

* **[String] Enabled** _(Write)_: The current state of the cipher. { Yes | No }

#### Examples

* [Configure a cipher](https://github.com/citadelgroup/SchannelPolicyDsc/blob/master/Examples/Sample_ConfigureACipher.ps1)

### CipherSuites

PProvides a mechanism to set cipher suite order.

#### Requirements

None

#### Parameters

* **[String] IsSingleInstance** _(Key)_: This value must be set to "Yes". { *Yes* }
* **[String[]] CipherSuitesOrder** _(Write)_: Array of ciphers in order of preference.
* **[String] Ensure** _(Write)_:  The desired state of the cipher suite order. { *Present* | Absent }

#### Read-Only Properties from Get-TargetResource

* **[String] Exists** _(Write)_: The current state of the cipher suite order. { Yes | No }

#### Examples

* [Configure a cipher suite order](https://github.com/citadelgroup/SchannelPolicyDsc/blob/master/Examples/Sample_ConfigureACipherSuiteOrder.ps1)

### Hash

Provides a mechanism to set individual hash functions.

#### Requirements

None

#### Parameters

* **[String] Hash** _(Key)_: The name of the hash function you want to configure. { MD5 | SHA | SHA256 | SHA384 | SHA512 }
* **[String] Ensure** _(Write)_: The desired state of the hash function. { *Present* | Absent }

#### Read-Only Properties from Get-TargetResource

* **[String] Exists** _(Write)_: The current state of the hash function. { Yes | No }

#### Examples

* [Configure a hash function](https://github.com/citadelgroup/SchannelPolicyDsc/blob/master/Examples/Sample_ConfigureAHashFunction.ps1)

### KeyExchangeAlgorithm

Provides a mechanism to set individual key exchange algorithms.

#### Requirements

None

#### Parameters

* **[String] Hash** _(Key)_: The name of the key exchange algorithm you want to configure. { Diffie-Hellman | ECDH | PKCS }
* **[String] Ensure** _(Write)_: The desired state of the key exchange algorithm. { *Present* | Absent }

#### Read-Only Properties from Get-TargetResource

* **[String] Exists** _(Write)_: The current state of the key exchange algorithm. { Yes | No }

#### Examples

* [Configure a key exchange algorithm](https://github.com/citadelgroup/SchannelPolicyDsc/blob/master/Examples/Sample_ConfigureAKeyExchangeAlgorithm.ps1)

### Protocol

Provides a mechanism to set individual protocols.

#### Requirements

None

#### Parameters

* **[String] Hash** _(Key)_: The name of the protocol you want to configure. { Multi-Protocol Unified Hello | PCT 1.0 | SSL 2.0 | SSL 3.0 | TLS 1.0 | TLS 1.1 | TLS 1.2 }
* **[String] Type** _(Key)_: The type of the protocol you want to configure. { Client | Server }
* **[String] Ensure** _(Write)_: The desired state of the protocol. { *Present* | Absent }

#### Read-Only Properties from Get-TargetResource

* **[String] Exists** _(Write)_: The current state of the protocol. { Yes | No }

#### Examples

* [Configure a protocol](https://github.com/citadelgroup/SchannelPolicyDsc/blob/master/Examples/Sample_ConfigureAProtocol.ps1)

## Versions

### 1.0.0

* Initial release of SchannelPolicyDsc.