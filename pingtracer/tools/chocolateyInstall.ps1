$ErrorActionPreference = 'Stop'


$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


$packageArgs = @{
  unzipLocation  = "$toolsDir"
  packageName    = "pingtracer"
  file           = "$toolsDir/PingTracer.1.9_x32.zip"
  checksum       = 'E0129B715F44E3DC6485D30A7CB5C18C16AB3D901155027670A77CCBE1AFD219'
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
