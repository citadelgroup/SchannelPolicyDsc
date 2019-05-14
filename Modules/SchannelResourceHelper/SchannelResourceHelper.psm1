#https://www.hass.de/content/setup-your-iis-ssl-perfect-forward-secrecy-and-tls-12
#https://support.microsoft.com/nl-nl/kb/245030

#region Helper function
function Switch-SchannelProtocol {
    param (
        [ValidateSet('Multi-Protocol Unified Hello','PCT 1.0','SSL 2.0','SSL 3.0','TLS 1.0','TLS 1.1','TLS 1.2')]
        [string]$Protocol,

        [ValidateSet("Server","Client")] 
        [string]$Type,

        [bool]$Enable
    )

    $protocolRootKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols' 
    $protocolKey = $protocolRootKey + "\" + $Protocol + "\" + $Type

    if(-not (Test-Path -Path $protocolKey)) {
        New-Item -Path $protocolKey -Force | Out-Null
    }

    switch ($Enable) {
        True  { $value = '0xffffffff' }
        False { $value = '0'          }
    }

    New-ItemProperty -Path $protocolKey -Name 'Enabled' -Value $value -PropertyType Dword -Force | Out-Null
    New-ItemProperty -Path $protocolKey -Name 'DisabledByDefault' -Value ([int](-not $Enable)) -PropertyType Dword -Force | Out-Null
}

function Test-SchannelItem {
    param (
        [string] $ItemKey,
        [bool] $Enable
    )
    
    switch ($Enable) {
        True  { $value = '4294967295' }
        False { $value = '0'          }
    }

    $result = $false
    $ErrorActionPreference = "SilentlyContinue"

    if(Get-ItemProperty -Path $ItemKey -Name Enabled) {
        if((Get-ItemPropertyValue -Path $ItemKey -Name Enabled) -eq $value) {
            $result = $true
        }
    }

    return $result
}

function Switch-SchannelItem {
    param (
        [string] $ItemKey,
        [bool] $Enable
    )

    if(-not (Test-Path -Path $ItemKey))
    {
        if($ItemKey -match "\\SecurityProviders\\SCHANNEL\\Ciphers")
        {
            $itemKeyArray = $ItemKey.Split('\')
            $rootKey = [string]::Join('\', $itemKeyArray[0..4])
            $subKey = $itemKeyArray[5]
            $keyCreate = $itemKeyArray[6]
            [void](Get-Item $rootKey).openSubKey($subKey, $true).CreateSubKey($keyCreate)
        }
        else
        {
            New-Item -Path $ItemKey -Force | Out-Null
        }
    }
    switch ($Enable)
    {
        True {$value = '0xffffffff'}
        False {$value = '0'}
    }

    New-ItemProperty -Path $ItemKey -Name 'Enabled' -Value $value -PropertyType Dword -Force | Out-Null
}

#endregion
