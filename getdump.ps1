$pair = '$diepazure:k7dBzw0vWf952A5Mu79JuG2DmrsptQ7jslH4pL3fxterdmlxZi0MZWjigLEH'
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$Encoded = [System.Convert]::ToBase64String($Bytes)
$basicAuthValue = "Basic $Encoded "
$headers = @{ Authorization = $basicAuthValue}
$response = Invoke-RestMethod -Uri "https://diepazure.scm.azurewebsites.net/api/processes/-1" -Method GET -Headers $headers -ContentType "application/json"
$processid = $response.id
$command="d:\devtools\sysinternals\procdump -accepteula -ma $processid -m 300 -s 5 -n 1 D:\home\Logfiles\";
iex $command
Start-Sleep -s 300
Invoke-WebRequest -uri "https://diepazure.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop" -Method POST -Headers $headers -ContentType "application/json"