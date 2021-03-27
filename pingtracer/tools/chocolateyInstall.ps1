$ErrorActionPreference = 'Stop'


$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageArgs = @{
  unzipLocation  = "$toolsDir"
  packageName    = "pingtracer"
  file           = "$toolsDir/PingTracer.1.10.1_x32.zip"
  checksum       = '30C454FFC454E6B104804FCBFA6ACE2D62F77E84B0A050670BA84D937B5282E7'
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
