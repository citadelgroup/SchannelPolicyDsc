$resourceModuleRootPath = Split-Path -Path (Split-Path $PSScriptRoot -Parent) -Parent
$modulesRootPath = Join-Path -Path $resourceModuleRootPath -ChildPath 'Modules'
Import-Module -Name (Join-Path -Path $modulesRootPath -ChildPath 'SchannelResourceHelper\SchannelResourceHelper.psm1') -Force

enum Ensure {
    Absent
    Present
}

enum Enabled {
    Yes
    No
}

[DscResource()]
class Cipher {
    [DscProperty(Key)]
    [ValidateSet('AES 128/128','AES 256/256','DES 56/56','NULL','RC2 128/128','RC2 40/128','RC2 56/128','RC4 128/128','RC4 40/128','RC4 56/128','RC4 64/128','Triple DES 168')]
    [string] $Cipher
    
    [DscProperty()]
    [Ensure] $Ensure = [Ensure]::Present

    [DscProperty(NotConfigurable)]
    [Enabled] $Enabled

    [Cipher] Get() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
        $Key = $RootKey + "\" + $this.Cipher

        if(Test-SchannelItem -ItemKey $Key -Enable $true) {
            $this.Enabled = [Enabled]::Yes
        }
        elseif(Test-SchannelItem -ItemKey $Key -Enable $false) {
            $this.Enabled = [Enabled]::No
        }
        else {
            #This depends on the cipher, but we'll assume Yes for now
            $this.Enabled = [Enabled]::Yes
        }

        return $this
    }
  
    [void] Set() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
        $Key = $RootKey + "\" + $this.Cipher
        
        if($this.Ensure -eq [Ensure]::Present) {
            Switch-SchannelItem -ItemKey $Key -Enable $true
        }
        else {
            Switch-SchannelItem -ItemKey $Key -Enable $false
        }
    }

    [bool] Test() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
        $Key = $RootKey + "\" + $this.Cipher

        if($this.Ensure -eq [Ensure]::Present) {
            if(Test-SchannelItem -ItemKey $Key -Enable $true) {
                return $true
            }
            else {
                return $false
            }
        }
        else {
            if(Test-SchannelItem -ItemKey $Key -Enable $false) {
                return $true
            }
            else {
                return $false
            }
        }
    }
}
