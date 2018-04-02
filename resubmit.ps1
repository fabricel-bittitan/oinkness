Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

Import-Module 'C:\Program Files (x86)\BitTitan\BitTitan PowerShell\BitTitanPowerShell.dll'

$username = "<define username>"
$password = "<define password>"
$SecurePassword = $password | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword

$connectorPageSize = 50
$connectorOffSet = 0

$t = Get-MW_Ticket -Credentials $cred

$connector = Get-MW_MailboxConnector -Ticket $t -FilterBy_String_Name "ProjectName"

do
{
    $items = Get-MW_Mailbox -ticket $t -FilterBy_Guid_ConnectorId $connector.Id -PageOffset $connectorOffSet -PageSize $connectorPageSize
    foreach ($item in $items)
    {
        Write-Host "Checking item" $item.ImportEmailAddress "with ID:" $item.Id

        $lastMigrationAttempt = Get-MW_MailboxMigration -ticket $t -FilterBy_Guid_MailboxId $item.Id -SortBy_CreateDate_Descending | Select-Object -Property MailboxId, CompleteDate, Status, Type, ItemTypes | Select -First 1

        Write-Host "Found Status:" $lastMigrationAttempt

        if ($lastMigrationAttempt.Status -eq "Failed")
        {                   
            Write-Host "Resubmitting Item" $item.ImportEmailAddress
            $result = Add-MW_MailboxMigration -Ticket $t -MailboxId $lastMigrationAttempt.MailboxId -Type $lastMigrationAttempt.Type -ConnectorId $connector.Id -UserId $t.UserId -Status Submitted -ItemTypes $lastMigrationAttempt.ItemTypes
        }
    }
    $connectorOffset += $connectorPageSize
    Write-Host "Switch Page" -foregroundcolor red -backgroundcolor Yellow
}
while ($items)