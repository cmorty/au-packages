$ErrorActionPreference = 'Stop'


$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = "jitsi-meet-electron"
  file    = "$toolsdir\app-32.7z"
  file64  = "$toolsdir\app-64.7z"
  unzipLocation  = "$toolsDir"
  checksum       = 'E04FD144AF3CAFFDCF61D0DC9C5BA5B1422CEDF95039B0BCDF57AA77A6279242'
  checksum64     = 'E7A25F626D2BF4F61FA4FA905F1096B658D47AA930EED84E7ED9603980912304'
  checksumType   = 'sha256'
  ChecksumType64 = 'sha256'
}


Write-Verbose "Unpacking"
Install-ChocolateyZipPackage @packageArgs

Get-ChildItem $toolsdir\*.7z | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

Write-Verbose "Searching for exe"
$files = get-childitem "$toolsdir" -include "*.exe" -recurse


foreach ($file in $files) {
  #generate an ignore file
  if($file.Name -like "Jitsi*") {
    Write-Verbose "Crating Start Menu enty for $($file.BaseName)"
    $newlink ="$($env:ProgramData)\Microsoft\Windows\Start Menu\Programs\$($file.BaseName).lnk"
    Install-ChocolateyShortcut -shortcutFilePath $newlink  -targetPath "$file"
    Add-Content "$toolsdir\chocoUninstall.ps1" -Value "Remove-Item `"$($newlink)`" -Force -ea ignore"
  } else {
    Write-Verbose "Ignoring $($file.Name)"
    New-Item "$file.ignore" -type file -force | Out-Null
  }
}
