$domain = $env:APPSETTING_WEBSITE_SITE_NAME
$password = 'k7dBzw0vWf952A5Mu79JuG2DmrsptQ7jslH4pL3fxterdmlxZi0MZWjigLEH'
$pair = "`$$($domain):$password"
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$Encoded = [System.Convert]::ToBase64String($Bytes)
$basicAuthValue = "Basic $Encoded "
$headers = @{ Authorization = $basicAuthValue}
$instanceId = $env:WEBSITE_INSTANCE_ID
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie 
$cookie.Name = "ARRAffinity"
$cookie.Value = $instanceId
$cookie.Domain = "$domain.scm.azurewebsites.net"
$session.Cookies.Add($cookie);
$response = Invoke-RestMethod -Uri "https://$domain.scm.azurewebsites.net/api/processes/-1" -Method GET -Headers $headers -ContentType "application/json" -WebSession $session
$processid = $response.id
$command="d:\devtools\sysinternals\procdump -accepteula -ma $processid -m 300 -s 5 -n 1 D:\home\Logfiles\";
iex $command
Start-Sleep -s 300
Invoke-RestMethod -uri "https://$domain.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop" -Method POST -Headers $headers -ContentType "application/json"
