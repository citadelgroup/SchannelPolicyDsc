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
class Protocol {
    [DscProperty(Key)]
    [ValidateSet('Multi-Protocol Unified Hello','PCT 1.0','SSL 2.0','SSL 3.0','TLS 1.0','TLS 1.1','TLS 1.2')]
    [string] $Protocol

    [DscProperty(Key)]
    [ValidateSet('Client','Server')]
    [string] $Type
    
    [DscProperty()]
    [Ensure] $Ensure = [Ensure]::Present

    [DscProperty(NotConfigurable)]
    [Enabled] $Enabled

    [Protocol] Get() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
        $Key = $RootKey + "\" + $this.Protocol + "\" + $this.Type
        $Item = Get-Item -Path $Key -ErrorAction SilentlyContinue

        if(($Item | Get-ItemProperty).Enabled -eq 1 -and ($Item | Get-ItemProperty).DisabledByDefault -eq 0) {
            $this.Enabled = [Enabled]::Yes
        }
        elseif(($Item | Get-ItemProperty).Enabled -eq 0 -or ($Item | Get-ItemProperty).DisabledByDefault -eq 1) {
            $this.Enabled = [Enabled]::No
        }
        else {
            #This depends on the protocol, but we'll assume Yes for now
            $this.Enabled = [Enabled]::Yes
        }

        return $this
    }
  
    [void] Set() {
        if($this.Ensure -eq [Ensure]::Present) {
            Switch-SchannelProtocol -Protocol $this.Protocol -Type $this.Type -Enable $true
        }
        else {
            Switch-SchannelProtocol -Protocol $this.Protocol -Type $this.Type -Enable $false
        }
    }

    [bool] Test() {
        $RootKey = 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
        $Key = $RootKey + "\" + $this.Protocol + "\" + $this.Type
        $Item = Get-Item -Path $Key -ErrorAction SilentlyContinue

        if($this.Ensure -eq [Ensure]::Present) {
            if(($Item | Get-ItemProperty).Enabled -eq 1 -and ($Item | Get-ItemProperty).DisabledByDefault -eq 0) {
                return $true
            }
            else {
                return $false
            }
        }
        else {
            if(($Item | Get-ItemProperty).Enabled -eq 0 -or ($Item | Get-ItemProperty).DisabledByDefault -eq 1) {
                return $true
            }
            else {
                return $false
            }
        }
    }
}
