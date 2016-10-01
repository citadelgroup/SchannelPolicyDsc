# Load the Helper Module 
Import-Module -Name "$PSScriptRoot\..\Helper.psm1" 

# Localized messages
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
        ItemTest                       = Testing {0} {1}
        ItemEnable                     = Changing {0} {1}
        ItemDisable                    = Removing {0} {1}
        ItemNotCompliant               = {0} {1} not compliant.
        ItemCompliant                  = {0} {1} compliant.
       
'@
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."
    $itemKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
    (Get-ItemPropertyValue -Path $itemKey -Name Functions)

    
    $returnValue = @{
    CipherSuitesOrder = [System.String[]](Get-ItemPropertyValue -Path $itemKey -Name Functions)
    Ensure = [System.String]$Ensure
    }

    $returnValue
    
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [System.String[]]
        $CipherSuitesOrder,

        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    if($Ensure -eq "Present")
    {
        Write-Verbose -Message ($LocalizedData.ItemEnable -f "CipherSuites" , $Ensure)
        Set-CipherSuitesOrder -cipherSuitesOrder $CipherSuites
    }

    if($Ensure -eq "Absent")
    {
        Write-Verbose -Message ($LocalizedData.ItemDisable -f "CipherSuites" , $Ensure)
        Remove-CipherSuitesOrder
    }

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [System.String[]]
        $CipherSuitesOrder,

        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )
    
    $Compliant = $false
    $itemKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
    Write-Verbose -Message ($LocalizedData.ItemTest -f "CipherSuites" , $Ensure)
    if($Ensure -eq "Present")
    {
        if(Test-CipherSuitesOrder -cipherSuitesOrder $CipherSuitesOrder)
        {
            $Compliant = $true
        }
    }

    if($Ensure -eq "Absent")
    {
        if(Get-ItemProperty -Path $itemKey -Name 'Functions' -ErrorAction SilentlyContinue)
        {
            if ((Get-ItemPropertyValue -Path $itemKey -Name "Functions" ) -ne $null)
            {
                $Compliant = $false
            }
        }
    }

    if($Compliant)
    {
        Write-Verbose -Message ($LocalizedData.ItemCompliant -f "CipherSuites" , $Ensure)
    }
    else
    {
        Write-Verbose -Message ($LocalizedData.ItemNotCompliant -f "CipherSuites" , $Ensure)
    }     
    return $Compliant
}


Export-ModuleMember -Function *-TargetResource

