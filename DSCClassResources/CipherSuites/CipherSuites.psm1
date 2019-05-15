$resourceModuleRootPath = Split-Path -Path (Split-Path $PSScriptRoot -Parent) -Parent
$modulesRootPath = Join-Path -Path $resourceModuleRootPath -ChildPath 'Modules'
Import-Module -Name (Join-Path -Path $modulesRootPath -ChildPath 'SchannelResourceHelper\SchannelResourceHelper.psm1') -Force

enum Ensure {
    Absent
    Present
}

enum Exists {
    Yes
    No
}

[DscResource()]
class CipherSuites {
    [DscProperty(Key)]
    [ValidateSet("Yes")]
    [string] $IsSingleInstance

    [DscProperty(Mandatory)]
    [System.String[]] $CipherSuitesOrder
    
    [DscProperty()]
    [Ensure] $Ensure = [Ensure]::Present

    [DscProperty(NotConfigurable)]
    [Exists] $Exists

    [CipherSuites] Get() {
        $itemKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
        $item = Get-ItemProperty -Path $itemKey -ErrorAction SilentlyContinue

        if($item) {
            $this.Exists = [Ensure]::Yes
            $this.CipherSuitesOrder = (Get-ItemPropertyValue -Path $itemKey -Name Functions -ErrorAction SilentlyContinue).Split(',')
        }
        else {
            $this.Exists = [Ensure]::No
        }

        return $this
    }
  
    [void] Set() {
        if($this.Ensure -eq [Ensure]::Present) {
            $itemKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002' 
            $cipherSuitesAsString = [string]::Join(',', $this.CipherSuitesOrder)
            New-Item $itemKey -Force 
            New-ItemProperty -Path $itemKey -Name 'Functions' -Value $cipherSuitesAsString -PropertyType 'String' -Force | Out-Null
        }
        else {
            $itemKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\' 
            Remove-Item $itemKey -Force
        }
    }

    [bool] Test() {
        $itemKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
        $item = Get-ItemProperty -Path $itemKey -ErrorAction SilentlyContinue

        if($item) {
            $CurrentCipherSuitesOrder = Get-ItemPropertyValue -Path $itemKey -Name Functions -ErrorAction SilentlyContinue
        }
        else {
            $CurrentCipherSuitesOrder = ""
        }

        if($this.Ensure -eq [Ensure]::Present) {
            if($item -and $CurrentCipherSuitesOrder -eq [string]::join(',', $this.CipherSuitesOrder)) {
                return $true
            }
            else {
                return $false
            }
        }
        else {
            if($item) {
                return $false
            }
            else {
                return $true
            }
        }
    }
}
