# Get-the-memory-dump-for-Azure-webapp-automatically
Get the memory dump for Azure webapp automatically

Create a Powershell file with the following content.

$pair = '$diepazure:k7dBzw0vWf952A5Mu79JuG2DmrsptQ7jslH4pL3fxterdmlxZi0MZWjigLEH'
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$Encoded = [System.Convert]::ToBase64String($Bytes)
$basicAuthValue = "Basic $Encoded "
$headers = @{ Authorization = $basicAuthValue}
$command="d:\devtools\sysinternals\procdump -accepteula -ma 7316 -m 300 -s 5 -n 1 D:\home\Logfiles\";
iex $command
Start-Sleep -s 300
Invoke-WebRequest -uri "https://diepazure.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop" -Method POST -Headers $headers -ContentType "application/json"

Parameters:

$pair = 'username:password'

username = webapp name
Password = check by selecting property on any webjob

![alt text](https://github.com/diepnt90/Get-the-memory-dump-for-Azure-webapp-automatically/blob/master/img/credential.JPG)

