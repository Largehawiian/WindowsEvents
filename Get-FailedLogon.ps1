<#
    .SYNOPSIS
        Filters Windows Event Log for failed logon events.
    .DESCRIPTION
        Filters Windows Event Log for failed logon events sorting relevant information into an object.
    .NOTES
        
    .LINK
        https://github.com/Largehawiian/WindowsEvents
    .EXAMPLE
    Get-WinEvent -MaxEvents 500 -FilterHashtable @{
    LogName = "Security"
    ID      = "4625"
    } | Get-FailedLogon | Format-Table
    #>
function Get-FailedLogon {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)][array]$InputObject
    )
    begin {
        class LogonEvent {
            [String]$TimeCreated
            [String]$SecurityID
            [String]$AccountName
            [String]$AccountDomain
            [String]$FailureReason
            [String]$WorkstationName
            [String]$SourceNetworkAddress
            hidden[array]$FilteredData

            LogonEvent () {}

            LogonEvent ($TimeCreated, $FilteredData) {
                $this.TimeCreated = $TimeCreated
                $this.SecurityID = $FilteredData[3].split("`t")[-1].trim()
                $this.AccountName = $FilteredData[12].split("`t")[-1].trim()
                $this.AccountDomain = $FilteredData[5].split("`t")[-1].trim()
                $this.FailureReason = $FilteredData[16].split("`t")[-1].trim()
                $this.WorkstationName = $FilteredData[25].split("`t")[-1].trim()
                $this.SourceNetworkAddress = $FilteredData[26].split("`t")[-1].trim()
            }

            Static [LogonEvent]LogonReport ($TimeCreated, $FilteredData) {
                return [LogonEvent]::new($TimeCreated, $FilteredData)
            }
        }
    }
    process {
        $FilteredData = $InputObject.message.split("`n").trim()
        [LogonEvent]::LogonReport($InputObject.TimeCreated, $FilteredData)
    }
}
