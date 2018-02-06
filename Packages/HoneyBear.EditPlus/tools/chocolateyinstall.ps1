$ErrorActionPreference = 'Stop'; # stop on all errors

$params = $env:chocolateyPackageParameters
if ($params -eq $null -or $params -eq "") {
    throw "Please specify parameters."
}

$parameters = ConvertFrom-StringData -StringData $env:chocolateyPackageParameters.Replace(";", "`n")
if ($parameters["token"] -eq $null) {
    throw "'token' parameter is required."
}

$token = 'token ' + $parameters["token"]
$packageName= 'HoneyBear.EditPlus' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'epp300_en.exe'

Write-Host "token=$token"

curl -H @{Authorization = $token; Accept = 'application/vnd.github.v3.raw';} -O "$toolsDir\epp300_en.exe" https://github.com/eoin55/HoneyBear.Chocolatey.Storage.Secure/raw/master/EditPlus/epp300_en.exe

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  file          = $fileLocation

  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '-q'           # Install4j
  softwareName  = 'HoneyBear.EditPlus' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
}

Install-ChocolateyInstallPackage @packageArgs