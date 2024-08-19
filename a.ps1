$localPath = "C:\Users\bob\Corporate_Information"
$ftpServer = "ftp://192.168.25.69/upload"
$ftpUser = "ftpuser"
$ftpPassword = "ftpuserpa55w0rd"
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPassword)
function Add-Directory {
  param (
    [string]$remotePath
  )
  $request = [System.Net.FtpWebRequest]::Create($remotePath)
  $request.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
  $request.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPassword)
  try {
    $response = $request.GetResponse()
    $response.Close()
  }
  catch {
    Write-Host "Directory already exists or error occured: $_"
  }
}
function Add-Item {
  param (
    [string]$itemPath,
    [string]$ftpPath
  )
  if (Test-Path $itemPath -PathType Container) {
    $itemName = [System.IO.Path]::GetFileName($itemPath)
    $ftpDirectory = "$ftpPath/$itemName"
    Add-Directory -remotePath $ftpDirectory
    Get-ChildItem $itemPath | ForEach-Object {
      Add-Item -itemPath $_.FullName -ftpPath $ftpDirectory
    }
  }
  else {
    $fileName = [System.IO.Path]::GetFileName($itemPath)
    $ftpFileUrl = "$ftpPath/$fileName"
    $uri = New-Object System.Uri($ftpFileUrl)
    $webClient.UploadFile($uri, $itemPath)
    Write-Host "File uploaded: $itemPath -> $ftpFileUrl"
  }
}
Add-Directory -remotePath $ftpServer
Add-Item -itemPath $localPath -ftpPath $ftpServer
$webClient.Dispose()