# Note to self
# -FirstName
# -LastName
# -Full Name
# -UPN
# -Password

#Collect csv file
# $TestCSV = Read-Host -Prompt "Please enter the location of the csv file: "
# if ($TestCSV -like '*.csv') {
#     Write-Host 'File is not a .csv file. Aborting.'
#     $TestCSV = ''
# }

#Collect the number of users that need to be created
try {
    [int]$numberOfUsers = Read-Host -Prompt "Please enter the number of users to be created: "
}
catch {
    Write-Host "There was a problem with this entry. Closing"
}
   
#Get an array of the first names in the test file
$TestCSV = 'T:\Data\TestData.csv'
# $ErrorCounter = 0

$FirstNameFunction = Import-Csv -Path $TestCSV | Select-Object -Property first_name
$LastNameFunction = Import-Csv -Path $TestCSV | Select-Object -Property last_name
$FirstNames = 0..($FirstNameFunction.count - 1)
$LastNames = 0..($LastNameFunction.count - 1)
$Domain = 'collinsnyderlabs.local'

#Write all the values of the csv into an array $FirstNames
$index = 0
foreach ($item in $FirstNameFunction) {
    $FirstNames[$index] = $item.first_name
    ##Write-Host 'Current name:' $FirstNames[$index] `n
    $index++
}
$index = 0

#Write all the values of the csv into an array $LastNames
$index = 0
foreach ($item in $LastNameFunction) {
    $LastNames[$index] = $item.last_name
    ##Write-Host 'Current name:' $LastNames[$index] `n
    $index++
}
$index = 0

#Build a User
function Add-RandomADUser {
    $RandFirstNames = Get-Random -Maximum ($FirstNames.count + 1)
    $RandLastNames = Get-Random -Maximum ($LastNames.count + 1)
    $RandomNumberPassword = Get-Random -Maximum 100000 -Minimum 0
    
    $NewUserFirstName = $FirstNames[$RandFirstNames]
    $NewUserLastName = $LastNames[$RandLastNames]
    ##$NewUserPassword = $RandomNumberPassword

    $NewUserUPN = "$NewUserFirstName.$NewUserLastName@$Domain"

    # if (Check-RandomADUser($NewUserUPN) = -1) {
    #     Write-Host "Duplicate message detected. Attempting again."
    #     $ErrorCounter++
    # }
    # elseif ($ErrorCounter = 5) {
    #     Write-Host "Too many failed attempts at account creation. AD has too many duplicate names on the list. Aborting program."
    #     break
    # }
    # else {
    #     New-ADUser -UserPrincipalName $NewUserUPN -AccountPassword "!!$RandomNumberPassword!!" 
    #     -ChangePasswordAtLogon True -GivenName $NewUserFirstName -Surname $NewUserLastName 
    # }

    # Write-Host "$NewUserFirstName $NewUserLastName"
    New-ADUser -Name "$NewUserFirstName $NewUserLastName" -UserPrincipalName $NewUserUPN -GivenName $NewUserFirstName -Surname $NewUserLastName -AccountPassword (ConvertTo-SecureString -String "!!AXm$RandomNumberPassword!!" -AsPlainText -Force)

    Write-Host "`nUser created: $NewUserFirstName $NewUserLastName - $NewUserUPN"
    Write-Host "Temp Account Password: !!AXm$RandomNumberPassword!!`n"
} 

#Check user against existing AD
# function Check-RandomADUser($tempUPN) {
#     foreach ($CheckUser in (Get-ADUser *)) {
#         if ($CheckUser.UserPrincipalName = $tempUPN) {
#             return -1
#         }
#     }
# }

# while($ErrorCounter -lt 5){
    Start-Transcript -Path "T:\PasswordOutput.txt"
    for($iteration = 0; $iteration -lt $numberOfUsers; $iteration++){
        Add-RandomADUser
    }
    Stop-Transcript
# }
