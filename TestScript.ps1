# Note to self
# -FirstName
# -LastName
# -Full Name
# -UPN
# -Password

#Collect the number of users that need to be created
{
    try {
        [int]$numberOfUsers = Read-Host -Prompt "Please enter the number of users to be created: "
    }
    catch {
        Write-Host "There was a problem with this entry. Closing"
    }
}
   
#Get an array of the first names in the test file
{
    $TestCSV = 'C:\Users\colli\OneDrive\Documents\LabWork\TestData.csv'
    $ErrorCounter = 0

    $FirstNameFunction = Import-Csv -Path $TestCSV | Select-Object -Property first_name
    $LastNameFunction = Import-Csv -Path $TestCSV | Select-Object -Property last_name
    $FirstNames = 0..($FirstNameFunction.count - 1)
    $LastNames = 0..($LastNameFunction.count - 1)
    $Domain = '@testing.com'
}

#Write all the values of the csv into an array $FirstNames
{
    $index = 0
    foreach ($item in $FirstNameFunction) {
        $FirstNames[$index] = $item.first_name
        Write-Host 'Current name:' $FirstNames[$index] `n
        $index++
    }
    $index = 0
}

#Write all the values of the csv into an array $LastNames
{
    $index = 0
    foreach ($item in $LastNameFunction) {
        $LastNames[$index] = $item.last_name
        Write-Host 'Current name:' $LastNames[$index] `n
        $index++
    }
    $index = 0
}

#Build a User
function Add-RandomADUser {
    $RandFirstNames = Get-Random -Maximum ($FirstNames.count + 1)
    $RandLastNames = Get-Random -Maximum ($LastNames.count + 1)
    $RandomNumberPassword = Get-Random -Maximum 100000 -Minimum 0
    
    $NewUserFirstName = $FirstNames[$RandFirstNames]
    $NewUserLastName = $LastNames[$RandLastNames]
    $NewUserPassword = $RandomNumberPassword

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

    New-ADUser -UserPrincipalName $NewUserUPN -AccountPassword "!!$RandomNumberPassword!!" 
    -ChangePasswordAtLogon True -GivenName $NewUserFirstName -Surname $NewUserLastName 

} 

#Check user against existing AD
# function Check-RandomADUser($tempUPN) {
#     foreach ($CheckUser in (Get-ADUser *)) {
#         if ($CheckUser.UserPrincipalName = $tempUPN) {
#             return -1
#         }
#     }
# }