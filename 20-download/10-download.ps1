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
			
		

			
$fileref = join-path $folderref $filename

Get-PnPAccessToken | Set-Clipboard



#Get-PnPFile -Url $fileRef -Path $copyto -filename "Nordics-DATA.xlsb" -AsFile -Force
