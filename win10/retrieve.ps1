#Requires -Version 5.1

# Ensures that Invoke-WebRequest uses TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$json = Invoke-WebRequest 'https://api.uupdump.net/listid.php?sortByDate=1&search=Windows%2010%2021H2%20amd64' -UseBasicParsing | ConvertFrom-Json

$firstBuild = $json.response.builds.PSObject.Properties | Select-Object -First 1

Write-Output "The default browser will be opened on https://uupdump.net/get.php?id=$($firstBuild.Value.uuid)&edition=updateOnly ..."
Start-Process "https://uupdump.net/get.php?id=$($firstBuild.Value.uuid)&edition=updateOnly"

Write-Output ''
Write-Output 'Press any key to close this windows...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
