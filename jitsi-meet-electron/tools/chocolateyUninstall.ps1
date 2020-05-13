$ErrorActionPreference = 'Stop';

$packageName = 'jitsi-meet-electron'



$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName 'Jitsi Meet*'

if ($key.Count -eq 1) {
  $key | % {
    # IMO Uninstall-ChocolateyPackage should support passing parameters as part of the file..... :(
    $file, $params = [regex]::Split( $_.UninstallString, ' (?=(?:[^"]|"[^"]*")*$)')
    $packageArgs = @{
      packageName    = $packageName
      fileType       = 'EXE'
      silentArgs     = '/S' + $params
      validExitlodes = @(0)
      file           = $file
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
