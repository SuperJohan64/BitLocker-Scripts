# Name: Get-BitLockerStatus.ps1
# Purpose: Checks the BitLocker status on a scope of machines specified by the user.


$Computers = Read-Host "Enter a hostname"

ForEach ($Computer in $Computers) {
    If ((manage-bde -status -computername $Computer.Name | Find 'Protection Status').Contains('Protection On') -eq $True) {Write-Host $Computer.Name}
}

