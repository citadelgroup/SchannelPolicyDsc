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
class Hash {
    [DscProperty(Key)]
    [ValidateSet('MD5','SHA','SHA256','SHA384','SHA512')]
    [string] $Hash
    
    [DscProperty()]
    [Ensure] $Ensure = [Ensure]::Present

    [DscProperty(NotConfigurable)]
    [Enabled] $Enabled

    [Hash] Get() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes'
        $Key = $RootKey + "\" + $this.Hash

        if(Test-SchannelItem -ItemKey $Key -Enable $true) {
            $this.Enabled = [Enabled]::Yes
        }
        elseif(Test-SchannelItem -ItemKey $Key -Enable $false) {
            $this.Enabled = [Enabled]::No
        }
        else {
            #This depends on the hash, but we'll assume Yes for now
            $this.Enabled = [Enabled]::Yes
        }

        return $this
    }
  
    [void] Set() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes'
        $Key = $RootKey + "\" + $this.Hash
        
        if($this.Ensure -eq [Ensure]::Present) {
            Switch-SchannelItem -ItemKey $Key -Enable $true
        }
        else {
            Switch-SchannelItem -ItemKey $Key -Enable $false
        }
    }

    [bool] Test() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes'
        $Key = $RootKey + "\" + $this.Hash

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
