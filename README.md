# Get-the-memory-dump-for-Azure-webapp-automatically
Get the memory dump for Azure webapp automatically

Create a Powershell file with the following content.
----------------------------------------------------

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

Start-Sleep -s 

Invoke-WebRequest -uri "https://$domain.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop" -Method POST -Headers $headers -ContentType "application/json"



------------------------------------------------------------------------------------------------------------------------------------------------------------------
#How to use


Password = check by selecting property on any webjob

![alt text](https://github.com/diepnt90/Get-the-memory-dump-for-Azure-webapp-automatically/blob/master/img/credential.JPG)

Modify the procdump command to match with your purpose
Blow is an example to get the dump when memory usage reaches 300 MB

d:\devtools\sysinternals\procdump -accepteula -ma $response.id -m 300 -s 5 -n 1 D:\home\Logfiles\

$response.id : process id of non-scm w3wp. It will automatically get by webjob.

-m : memory 

300 : 300MB

-s 5 : wait 5 second to get dump after reaching threshold

-n 1 : get 1 dump

For CPU or any exception you can check below article for modifying the command

https://knowledge.broadcom.com/external/article?legacyId=tech95826

Start-Sleep: wait 5 minutes for writing the dump

https://$domain.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop


getdump: the name you type when creating the webjob

then save as .ps1 file and zip it

Go to webjod and add as below

![alt text](https://github.com/diepnt90/Get-the-memory-dump-for-Azure-webapp-automatically/blob/master/img/addwebjob.JPG)

Name: type the correct name as you wrote above. For example: getdump

File upload: the zip file of ps1

Then OK

Go to Kudu then webjob dashboard and choose "getdump" then you can see the output that Procdump is monitoring and get dump if the memory usage  reached threshold

![alt text](https://github.com/diepnt90/Get-the-memory-dump-for-Azure-webapp-automatically/blob/master/img/monitoring.JPG)

Once, the job gets a dump and completes writing the dump, it will stop the webjob by itself.
