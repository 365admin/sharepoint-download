<#---
title: Download
tag: download
api: post

---


## Download a file from a SharePoint document library
We use PNP PowerShell to download a file from a SharePoint document library. The script is a PowerShell script that uses the PNP PowerShell module to download a file from a SharePoint document library. The script takes the following parameters:


#>

param (
    $siteurl = "https://christianiabpos.sharepoint.com/sites/NordicTerminalEstateManagementNetsGroup",
    $folderref = "/sites/NordicTerminalEstateManagementNetsGroup/Shared Documents/General/Reports/Details",
    $filename = "Nordics-DATA.xlsb",
    $copyto = "."
)



#$DocumentLibraries = Get-PnPList | Where-Object { $_.BaseTemplate -eq 101 -and $_.Hidden -eq $false } #Or $_.BaseType -eq "DocumentLibrary"
# foreach ($library in $DocumentLibraries ) {
#     write-host  $library.Title $library.DefaultViewUrl
# } 

if ($null -eq $env:WORKDIR ) {
    $env:WORKDIR = join-path $psscriptroot ".." ".koksmat" "workdir"
}
$workdir = $env:WORKDIR

if (-not (Test-Path $workdir)) {
    New-Item -Path $workdir -ItemType Directory | Out-Null
}

$workdir = Resolve-Path $workdir
set-location $workdir

$PNPAPPID = $env:PNPAPPID
$PNPTENANTID = $env:PNPTENANTID
$PNPCERTIFICATEPATH = join-path $workdir "pnp.pfx"
$PNPSITE = $env:PNPSITE
$bytes = [Convert]::FromBase64String($ENV:PNPCERTIFICATE)
[IO.File]::WriteAllBytes($PNPCERTIFICATEPATH, $bytes)

write-output "Connecting to $PNPSITE"
Connect-PnPOnline -Url $siteurl  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"
			
		
function Parse-JWTtoken {
 
    [cmdletbinding()]
    param([Parameter(Mandatory = $true)][string]$token)
 
    #Validate as per https://tools.ietf.org/html/rfc7519
    #Access and ID tokens are fine, Refresh tokens will not work
    if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { Write-Error "Invalid token" -ErrorAction Stop }
 
    #Header
    $tokenheader = $token.Split(".")[0].Replace('-', '+').Replace('_', '/')
    #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
    while ($tokenheader.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenheader += "=" }
    Write-Verbose "Base64 encoded (padded) header:"
    Write-Verbose $tokenheader
    #Convert from Base64 encoded string to PSObject all at once
    Write-Verbose "Decoded header:"
    [System.Text.Encoding]::ASCII.GetString([system.convert]::FromBase64String($tokenheader)) | ConvertFrom-Json | fl | Out-Default
 
    #Payload
    $tokenPayload = $token.Split(".")[1].Replace('-', '+').Replace('_', '/')
    #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
    while ($tokenPayload.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenPayload += "=" }
    Write-Verbose "Base64 encoded (padded) payoad:"
    Write-Verbose $tokenPayload
    #Convert to Byte array
    $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
    #Convert to string array
    $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
    Write-Verbose "Decoded array in JSON format:"
    Write-Verbose $tokenArray
    #Convert from JSON to PSObject
    $tokobj = $tokenArray | ConvertFrom-Json
    Write-Verbose "Decoded Payload:"
    
    return $tokobj
}
			
$fileref = join-path $folderref $filename
 
# Parse-JWTtoken (Get-PnPAccessToken)

Get-Hexatown-AccessTokenDeviceStep1 $env:PNPAPPID $env:PNPTENANTID

# Get-PnPFile -Url $fileRef -Path $copyto -filename "Nordics-DATA.xlsb" -AsFile -Force
