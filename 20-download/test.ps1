$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Accept", "application/json")


$body = @"
{
  `"body`": {
    `"assetskey`": `"Nordic-All`",
    `"pin`": `"sd978fds9aafdsjklm,124`",
    `"site`": `"Terminal Estate Reporting`"
  }
}
"@

$response = Invoke-RestMethod 'http://localhost:8336/v1/download/onefile' -Method 'POST' -Headers $headers -Body $body
$downloadInfo = $response | ConvertTo-Json
write-host $downloadInfo
