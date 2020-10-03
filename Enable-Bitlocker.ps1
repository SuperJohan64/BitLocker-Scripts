# Launch Script: powershell.exe -ExecutionPolicy Bypass -File ".\Enable-Bitlocker.ps1"
#
# Name: Enable-Bitlocker.ps1
# Description: Enables Bitlocker on unecrypted systems and backs up the recovery information to AD DS.

# Returns the directory from which the script is running.
function Get-ScriptDirectory {
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

pushd (get-scriptDirectory)

# Initializes the Tpm
Initialize-Tpm

# Get the target volume's encryption properties.
$volume = Get-WmiObject win32_EncryptableVolume -Namespace root\CIMv2\Security\MicrosoftVolumeEncryption -Filter "DriveLetter = 'C:'"

# If this is a machine that is not encrypted, encrypt it.
if ($volume.encryptionmethod -eq 0) {
    manage-bde -on c: -s -rp

    # Creates a backup of the Bitlocker Recovery Information to AD DS.
    $drive = Get-BitLockerVolume | ?{$_.KeyProtector | ?{$_.KeyProtectorType -eq 'RecoveryPassword'}} | select -f 1
    $key = $drive | select -exp KeyProtector | ?{$_.KeyProtectorType -eq 'RecoveryPassword'} | select -f 1
    Backup-BitLockerKeyProtector $drive.MountPoint $key.KeyProtectorId
}