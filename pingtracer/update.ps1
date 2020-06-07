import-module au

$domain   = 'https://github.com'
$ghproj = 'bp2008/pingtracer'
$releases = "$domain/$ghproj/releases/latest"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*)('.*')" = "`$1'tools/$($Latest.Filename32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
    ".\pingtracer.nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
    }
    ".\tools\VERIFICATION.txt" = @{
      "(?i)(URL:).*"             = "`${1} $($Latest.URL32)"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}


function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function global:au_GetLatest {
  #$ProgressPreference = 'SilentlyContinue'
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases

  $re    = '\.zip$'
  $url   = $download_page.links | ? href -match $re | select -First 1 -expand href

  $version  = ($url -split '/' | Select-Object -Last 1 -Skip 1 )

  $releaseNotesUrl = $download_page.BaseResponse.ResponseUri.AbsoluteUri

  @{
    URL32 = $domain + $url
    Version = $version
    ReleaseNotes = $releaseNotesUrl
  }
}


update -ChecksumFor none
