<#---
title: Download Graph
tag: onefile
connection: sharepoint
input: download-request.json
output: download-response.json
api: post
---

This API is used to download a file from a SharePoint site. The API requires a `download-request.json` file in the workdir. The file should contain the following fields:

```json
{
  "assetskey": "Nordic-All",
  "pin": "**************",
  "site": "Terminal Estate Reporting"
}
```
The site is defined in the hub sites list `Connected Sites` where the title matches the `site` field in the request. 

The API will return a `download-response.json` file in the workdir. The file will contain the following fields:

```
{
  "relativePath": "/sites/NordicTerminalEstateManagementNetsGroup/Shared%20Documents/General/Reports/DATA/Nordics-DATA.xlsb",
  "publiclink": "https://christianiabpos.sharepoint.com/sites/NordicTerminalEstateManagementNetsGroup/_layouts/15/download.aspx?UniqueId=8528e2af-a827-4f28-ac71-1dd5964829a0&Translate=false&tempauth=****",
  "filename": "Nordics-DATA.xlsb",
  "status": "",
  "parentPath": "",
  "sharepointlink": "https://christianiabpos.sharepoint.com/sites/NordicTerminalEstateManagementNetsGroup/Shared%20Documents/General/Reports/DATA/Nordics-DATA.xlsb?d=w8528e2afa8274f28ac711dd5964829a0&csf=1&web=1&e=1E0hex"
}

```

#>
if ($null -eq $env:WORKDIR ) {
    $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
    New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir

<#

## Helper function to call Graph API
#>
function GraphAPI($accessToken, $method, $url, $body, $ignoreError) {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $($accessToken)" )
    
    
    $errorCount = $error.Count
    $CurrentErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    $result = Invoke-RestMethod ($url) -Method $method -Headers $headers -Body $body 
    
    $ErrorActionPreference = $CurrentErrorActionPreference
    if (!$ignoreError -and $errorCount -ne $error.Count) {
        Write-Error $url
    }

    return $result

}

<#
Integration Hub site reference
#>
$integrationSiteUrl = "https://christianiabpos.sharepoint.com/sites/SharePointIntegrationHub"
$downloadResponse = @{
    sharepointlink = ""
    relativePath   = ""
    publiclink     = ""
    filename       = ""
    parentPath     = ""
    status         = ""
}

$downloadRequest = Get-Content (join-path $workdir "download-request.json") | ConvertFrom-Json


Connect-PnPOnline -Url $integrationSiteUrl  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

$listItem = Get-PnpListItem -List "Connected Sites"  -Query "<View><Query><Where><Eq><FieldRef Name='Title'/><Value Type='Text'>$($downloadRequest.site)</Value></Eq></Where></Query></View>"
$hasError = $false
if ($null -eq $listItem ) {
    $hasError = $true
    $downloadResponse.status = "Site not found"
}

if (!$hasError) {
    $spokeUrl = $listItem.FieldValues.SiteURL.Url
    $spokeSiteUrl = $spokeUrl.Split("/Lists/")[0]
    $spokeListName = $spokeUrl.Split("/Lists/")[1].Split("/")[0]

    Connect-PnPOnline -Url  $spokeSiteUrl   -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"
    $assetsItem = Get-PnpListItem -List $spokeListName # -Query "<View><Query><Where><Eq><FieldRef Name='Title'/><Value Type='Text'>$($downloadRequest.key)</Value></Eq></Where></Query></View>"
    $pin = $assetsItem.FieldValues.pincode
    if ($pin -ne $downloadRequest.pin) {
        $hasError = $true
        $downloadResponse.status = "Pin not valid"
    }
    else {
        $downloadResponse.sharepointlink = $assetsItem.FieldValues.FileLink.Url
         
        $linkSiteUrl = $downloadResponse.sharepointlink.Split("?")[0]
        if ($false -eq $linkSiteUrl.StartsWith($spokeSiteUrl)) {
            $hasError = $true
            $downloadResponse.status = "Link not valid"
        }
        else {
            $downloadResponse.relativePath = $linkSiteUrl.Split(".sharepoint.com")[1]
            $downloadResponse.filename = split-path  $downloadResponse.relativePath -leaf

            $sitePath = $downloadResponse.relativePath.Split("/")[2]

            $accessToken = Get-PnPAccessToken
           
            # $siteInfo = GraphAPI -accessToken $accessToken -method "GET" -url "https://graph.microsoft.com/v1.0/sites/christianiabpos.sharepoint.com:/sites/$sitePath" $null $false
            $rootdriveUrl = "https://graph.microsoft.com/v1.0/sites/christianiabpos.sharepoint.com:/sites/$($sitePath):/drive"
            # $drivesUrl = "https://graph.microsoft.com/v1.0/sites/christianiabpos.sharepoint.com:/sites/$($sitePath):/drives"
            
            # "https://graph.microsoft.com/v1.0/drives/b!lYfFCOgec0aSEKaB1bEJFftCsdkK70tFj5S5Ge0P7rdVwaLLmkujS4bEfl9A4xO6"
            # https://graph.microsoft.com/v1.0/drives/b!lYfFCOgec0aSEKaB1bEJFftCsdkK70tFj5S5Ge0P7rdVwaLLmkujS4bEfl9A4xO6/root:/General/Reports/DATA/Nordics-DATA.xlsb:/
            # https://graph.microsoft.com/v1.0/drives/b!lYfFCOgec0aSEKaB1bEJFftCsdkK70tFj5S5Ge0P7rdVwaLLmkujS4bEfl9A4xO6/root:/General/Reports/DATA/Nordics-DATA.xlsb:
            #write-host $downloadResponse.relativePath
            $driveInfo = GraphAPI -accessToken $accessToken -method "GET" -url $rootdriveUrl $null $false
   
            #            $drivesInfo = GraphAPI -accessToken $accessToken -method "GET" -url $drivesUrl $null $false
            $filePath = $downloadResponse.relativePath.Split("Shared%20Documents")[1]
            $driveId = $driveInfo.id
            # $filePath = "/General/Reports/DATA/Nordics-DATA.xlsb"
            $itemUrl = "https://graph.microsoft.com/v1.0/drives/$($driveId)/root:$($filePath):"
            $itemInfo = GraphAPI -accessToken $accessToken -method "GET" -url $itemUrl $null $false
            $downloadResponse.publiclink = $itemInfo.'@microsoft.graph.downloadUrl'
        }
    }
        
}
     

$resultPath = join-path $env:WORKDIR "download-response.json"
$downloadResponse | ConvertTo-Json -Depth 10 | Out-File -FilePath $resultPath -Encoding utf8NoBOM



