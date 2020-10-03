<# 

The "One-liner" for SCCM/MDT TS'

$BitLocker = Get-WmiObject -Namespace Root\cimv2\Security\MicrosoftVolumeEncryption -Class Win32_EncryptableVolume; $id = $BitLocker.GetKeyProtectors(3).Volumekeyprotectorid; manage-bde -protectors -adbackup $env:SystemDrive -id $id

#>

# Copies the BitLocker Recovery key to the Computer object in Active Directory.
$BitLocker = Get-WmiObject -Namespace Root\cimv2\Security\MicrosoftVolumeEncryption -Class Win32_EncryptableVolume
$id = $BitLocker.GetKeyProtectors(3).Volumekeyprotectorid
manage-bde -protectors -adbackup $env:SystemDrive -id $id