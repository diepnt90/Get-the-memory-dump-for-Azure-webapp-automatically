# Get-the-memory-dump-for-Azure-webapp-automatically
Get the memory dump for Azure webapp automatically

Create a Powershell file with the following content.
----------------------------------------------------

$pair = '$diepazure:k7dBzw0vWf952A5Mu79JuG2DmrsptQ7jslH4pL3fxterdmlxZi0MZWjigLEH'

$Bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)

$Encoded = [System.Convert]::ToBase64String($Bytes)

$basicAuthValue = "Basic $Encoded "

$headers = @{ Authorization = $basicAuthValue}

$response = Invoke-RestMethod -Uri "https://diepazure.scm.azurewebsites.net/api/processes/-1" -Method GET -Headers $headers -ContentType "application/json"

$processid = $response.id

$command="d:\devtools\sysinternals\procdump -accepteula -ma $processid -m 300 -s 5 -n 1 D:\home\Logfiles\";

iex $command

Start-Sleep -s 

Invoke-WebRequest -uri "https://diepazure.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop" -Method POST -Headers $headers -ContentType "application/json"


------------------------------------------------------------------------------------------------------------------------------------------------------------------
Parameters:

$pair = 'username:password'

username = webapp name

Password = check by selecting property on any webjob

![alt text](https://github.com/diepnt90/Get-the-memory-dump-for-Azure-webapp-automatically/blob/master/img/credential.JPG)

d:\devtools\sysinternals\procdump -accepteula -ma $response.id -m 300 -s 5 -n 1 D:\home\Logfiles\

$response.id : process id of non-scm w3wp

-m : memory 

300 : 300MB

-s 5 : wait 5 second to get dump after reaching threshold

-n 1 : get 1 dump

For CPU or any exception you can check below article for modifying the command

https://knowledge.broadcom.com/external/article?legacyId=tech95826

Start-Sleep: wait 5 minutes for writing the dump

https://diepazure.scm.azurewebsites.net/api/continuouswebjobs/getdump/stop

diepazure : the webapp name

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
