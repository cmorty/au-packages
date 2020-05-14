$ErrorActionPreference = 'Stop'


$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = "jitsi-meet-electron"
  file    = "$toolsdir\app-32.7z"
  file64  = "$toolsdir\app-64.7z"
  unzipLocation  = "$toolsDir"
  checksum       = '0363AF8E59CDA3B7428AD147FE32CB01122463EB7B866808DD8646212CA6F712'
  checksum64     = '9902903E8ACCABA33AC7AC7F774C1381A030C0B5A89CDF2A76BCCEFE6606AE07'
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
    Install-ChocolateyShortcut -shortcutFilePath "$($env:ProgramData)\Microsoft\Windows\Start Menu\Programs\$($file.BaseName).lnk" -targetPath "$file"
  } else {
    Write-Verbose "Ignoring $($file.Name)"
    New-Item "$file.ignore" -type file -force | Out-Null
  }
}
