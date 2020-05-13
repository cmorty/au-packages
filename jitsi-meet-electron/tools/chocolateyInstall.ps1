$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'jitsi-meet-electron'
  fileType       = 'exe'
  softwareName   = 'Jitsi Meet Electron'

  checksum       = '52840d84646b4ec498025e647ce178a64bbbb3cf4ba1656569c2f118cf8f3ca4'
  checksumType   = 'sha256'
  url            = 'https://github.com/jitsi/jitsi-meet-electron/releases/download/v2.0.2/jitsi-meet.exe'

  silentArgs     = '/S /ALLUSERS'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
