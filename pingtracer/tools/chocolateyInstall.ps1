$ErrorActionPreference = 'Stop'


$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageArgs = @{
  unzipLocation  = "$toolsDir"
  packageName    = "pingtracer"
  file           = 'tools/PingTracer.1.8_x32.zip'
  checksum       = '292777976917364EA471BFED8CCDEF105761521DD90BDF0092D043B3856BFE04'
  checksumType   = 'sha256'
}


Write-Verbose "Unpacking"
Install-ChocolateyZipPackage @packageArgs

Write-Verbose "Searching for exe"
$files = get-childitem "$toolsdir" -include "*.exe" -recurse


# This will create a Shim for all exe and will add a line chocoUninstall.ps1 to remove it on uninstall
foreach ($file in $files) {
  Write-Verbose "Crating Start Menu enty for $($file.BaseName)"
  $newlink ="$($env:ProgramData)\Microsoft\Windows\Start Menu\Programs\$($file.BaseName).lnk"
  Install-ChocolateyShortcut -shortcutFilePath $newlink  -targetPath "$file"
  Add-Content "$toolsdir\chocoUninstall.ps1" -Value "Remove-Item `"$($newlink)`" -Force -ea ignore"
}
