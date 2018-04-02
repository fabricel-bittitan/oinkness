Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

Import-Module 'C:\Program Files (x86)\BitTitan\BitTitan PowerShell\BitTitanPowerShell.dll'

$username = "<define username>"
$password = "<define password>"
$SecurePassword = $password | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword

$t = Get-MW_Ticket -Credentials $cred

$connector = Get-MW_MailboxConnector -Ticket $t -FilterBy_String_Name "ProjectName"

$connectorPageSize = 50
$connectorOffSet = 0

do
{
    $items = Get-MW_Mailbox -ticket $t -FilterBy_Guid_ConnectorId $connector.Id -PageOffset $connectorOffSet -PageSize $connectorPageSize

    foreach ($item in $items)
    {
        Write-Host "Testing Item" $item.ImportEmailAddress
        $lastMigrationAttempt = Get-MW_MailboxMigration -ticket $t -FilterBy_Guid_MailboxId $item.Id -SortBy_CreateDate_Descending | Select -First 1

        if ($lastMigrationAttempt.Status -eq "Failed")
        {
            $fullmigrationStat = Get-MW_MailboxStat -Ticket $t -FilterBy_Guid_MailboxId $item.Id
            $migrationInfoStats = $fullmigrationStat.migrationStatsInfos

            foreach ($itemInfo in $migrationInfoStats)
            {
                $migrationStat = $itemInfo.migrationStats

                if (($itemInfo.ItemType -eq "Mail") -and ($migrationStat.SuccessCountTotal -ne 0))
                {
                    Write-Host "Resubmitting Item" $item.ImportEmailAddress -foregroundcolor red -backgroundcolor green
                    $result = Add-MW_MailboxMigration -Ticket $t -MailboxId $lastMigrationAttempt.MailboxId -Type $lastMigrationAttempt.Type -ConnectorId $connector.Id -UserId $t.UserId -Status Submitted `
                        -ItemTypes $lastMigrationAttempt.ItemTypes -Priority 1
                    break;
                } 
            }
        }
    }
    $connectorOffset += $connectorPageSize
    Write-Host "Switch Page" -foregroundcolor red -backgroundcolor Yellow
}
while ($items)