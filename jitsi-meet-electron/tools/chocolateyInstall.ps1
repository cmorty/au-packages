﻿$ErrorActionPreference = 'Stop'


$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = "jitsi-meet-electron"
  file    = "$toolsdir\app-32.7z"
  file64  = "$toolsdir\app-64.7z"
  unzipLocation  = "$toolsDir"
  checksum       = '965880BD9E57873A741F3C8DA35A586983A4CF6464F0307830F928DEECB12693'
  checksum64     = '449B5FD000F609D89FEF35FFB064D018F241EBC5E03013402E1F6B35CE9E4EAB'
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
