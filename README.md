# WindowsEvents
 Parse Failed Windows logon events in a readable and searchable output.
```
Get-WinEvent -MaxEvents 500 -FilterHashtable @{
    LogName = "Security"
    ID      = "4625"
} | Get-FailedLogon | Format-Table
```
