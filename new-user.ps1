

$validInput = $false

while (-not $validInput) {
    $fname = Read-Host "Enter First Name"
    $firstLetter = $fname.Substring(0, 1)
    if ($firstLetter -ceq $firstLetter.ToUpper()) {
        $validInput = $true
    } else {
        Write-Host "Capital!"
    }
}


$validInput = $false

while (-not $validInput) {
    $lname = Read-Host "Enter Last Name "
    if ($firstLetter -ceq $firstLetter.ToUpper()) {
        $validInput = $true
    } else {
        Write-Host "Capital!"
    }
}


#This creates the error log
New-Item "C:\User Scripts\New User Creation\Error Logs\$firstletter$lname.txt" | Out-Null



$logFilePath = "C:\User Scripts\New User Creation\Error Logs\$firstletter$lname.txt"


#Writes the log in appened mode 
$stream = [System.IO.StreamWriter]::new($logFilePath, $true)


#Formats the log message 
function Log-Error {
    param (
        [string]$Message
    )
    $formattedMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error: $Message"
    $stream.WriteLine($formattedMessage)
}


#Used to test for any errors 
$scriptCode = {



$validInput = $false

while (-not $validInput) {
    $number = Read-Host "Enter a value in the ###.###.#### format"
    
    if ($number -match '^\d{3}\.\d{3}\.\d{4}$') {
        $validInput = $true
    } else {
        Write-Host "Invalid input. Please enter the value in the ###.###.#### format."
    }
}


$validInput = $false

while (-not $validInput) {
    $computername = Read-Host "Enter Computer Name in format BBYWS-Serial"
    if ($firstLetter -ceq $firstLetter.ToUpper()) {
        $validInput = $true
    } else {
        Write-Host "Capital!"
    }
}

$validInput = $false

while (-not $validInput) {
    $computerversion = Read-Host "Enter Laptop Version ex. Lenovo T470, X13, etc "
    if ($firstLetter -ceq $firstLetter.ToUpper()) {
        $validInput = $true
    } else {
        Write-Host "Capital!"
    }
}

$manager = "Managers Name"
$description = "Accounting Assistant"
$title = "Accounting Assistant"
$department = "Accounting"
$firstletter = $fname.Substring(0, 1)
$username = "$firstletter$lname"
$Path = "OU=Users,OU=Accounting,OU=Office,OU=Burnaby,DC=dc,DC=com"
$ComputerPath = "OU=Computers,OU=Accounting,OU=Office,OU=Burnaby,DC=dc,DC=com"
$template = "AccoutingTemplate"  
$user = Get-ADUser -Identity $template -Properties MemberOf

$groupPaths = $user.MemberOf | ForEach-Object {
    $group = Get-ADGroup -Identity $_
    $group.DistinguishedName
}

New-ADUser -Name "$fname $lname" -Givenname "$fname" -Surname "$lname" -Office "Burnaby" -EmailAddress "$username@ventanaconstruction.com" -SamAccountName "$username" -UserPrincipalName "$username@ventanaconstruction.com" -Department "$department" -Title "$title" -Company "Ventana Construction Corporation" -Description "$description" -Path "$path" -Enabled $true -AccountPassword(Read-Host -AsSecureString "Input a Password") -Displayname "$fname $lname" -OfficePhone "$number" -Mobile "$number"

Get-ADComputer $computername | Move-ADObject -TargetPath $ComputerPath

Set-ADComputer $computername -Description "$computerversion - $fname $lname"




Get-ADUser -Identity $username -Properties name, officephone, office, emailaddress, department, title, company |
    Select-Object name, officephone, office, emailaddress, department, title, company | 
    Out-File -FilePath "C:\User Scripts\New User Creation\Creation Logs\$username Info.txt"

$computers = get-adcomputer $computername -Properties * | Select-Object Name, Description, DistinguishedName


Add-Content -Path "C:\User Scripts\New User Creation\Creation Logs\$username Info.txt" -value $computers


#Adds user into the groups from template
foreach ($groupPaths in $groupPaths) {
Add-ADGroupMember -Identity $groupPaths -Members $username
    Write-Host "User $username added to group $groupPaths."
    Add-Content -Path "C:\User Scripts\New User Creation\Creation Logs\$username Info.txt" -Value "User $username added to group $groupPaths."
}
Add-Content -Path "C:\User Scripts\New User Creation\Creation Logs\$username Info.txt" -Value "
	
Applications:           Manager:           SharePoint:           Hardware:           License:       
Office 365              $manager           Operation Manual      Laptop and Phone    Business Premium
VLC
7-Zip 
Adobe Reader
Greenshot
Connectwise Connect
Sophos VPN
Sentinel One
Create-a-check
Sage
Pirical Printer
JAMs
Dash.construction
"
	    
	     




#Sync to office
$remoteComputer = "BBSHC1JIM1V" 
$scriptBlock = {
Start-ADSyncSyncCycle delta
}

Invoke-Command -ComputerName $remoteComputer -ScriptBlock $scriptBlock






error_test

}


try {
    Invoke-Command -ScriptBlock $scriptCode
}
catch {

    Log-Error -Message $_.Exception.Message
}










$stream.Close()
