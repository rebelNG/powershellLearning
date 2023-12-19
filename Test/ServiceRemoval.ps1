<#
    Script created by Emmanuel Alozieuwa
    on 18th December, 2023
    Script is designed to help in service/services removal
#>

<#[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string[]]
    $ServicesName
)#>

Write-Output ""

$Location = Split-Path $MyInvocation.MyCommand.Path

$DMLLocation = "\\csdatg04\Users\CDC Wintel\Automation_Scripts\Service Removal"
$FileLocation = $DMLLocation + "\Service Removal script"

$CurrentFileLocation = Get-Content -Path "$Location\CurrentLocation.txt"
$CurrentFileLocation = $CurrentFileLocation.Trim()

$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().name
$CurrentUser = $CurrentUser.split("\")
$CurrentUser = $CurrentUser[1]

$Servers = Get-Content -Path "$FileLocation\ServerList.txt"
$Services = Get-Content -Path "$FileLocation\Services.txt"


foreach($Server in $Servers){

    $TestServer = Test-Connection -ComputerName $Server -Count 2 -Quiet

    if($TestServer){
        foreach ($Service in $Services){
            # Check if the service name is provided
            if ($Service) {
                # Check if the website exists
                $website = Get-Website -Name $Service -ErrorAction SilentlyContinue
                if ($website) {
                    # Remove the website
                    Remove-Website -Name $Service
                    Write-Host "Website '$Service' has been removed." -ForegroundColor White
                } else {
                    Write-Host "Website '$Service' does not exist or has already been removed." -ForegroundColor Red
                }
        
                # Test if folderpaths exist
                $folderPath1 = "B:\Releases\$Service"
                $folderPath2 = "E:\inetpub\wwwroot\$Service"
                $folderPath3 = "L:\IIS\$Service"
        
                $folders = @($folderPath1, $folderPath2, $folderPath3)
        
                foreach ($folder in $folders) {
                    if (Test-Path -Path $folder -ErrorAction SilentlyContinue) {
                        Remove-Item -Path $folder -Force -Recurse
                        Write-Host "Folder '$Service' has been removed from: $folder" -ForegroundColor Green
                    } else {
                        Write-Host "Folder '$Service' does not exist at: $folder" -ForegroundColor Red
                    }
                }
            } else {
                Write-Host "Please provide a valid website name." -ForegroundColor Red
            }
        }
    }
}
















<#foreach ($Service in $ServicesName){
    # Check if the service name is provided
    if ($Service) {
        # Check if the website exists
        $website = Get-Website -Name $Service -ErrorAction SilentlyContinue
        if ($website) {
            # Remove the website
            Remove-Website -Name $Service
            Write-Host "Website '$Service' has been removed." -ForegroundColor White
        } else {
            Write-Host "Website '$Service' does not exist or has already been removed." -ForegroundColor Red
        }

        # Test if folderpaths exist
        $folderPath1 = "B:\Releases\$Service"
        $folderPath2 = "E:\inetpub\wwwroot\$Service"
        $folderPath3 = "L:\IIS\$Service"

        $folders = @($folderPath1, $folderPath2, $folderPath3)

        foreach ($folder in $folders) {
            if (Test-Path -Path $folder -ErrorAction SilentlyContinue) {
                Remove-Item -Path $folder -Force -Recurse
                Write-Host "Folder '$Service' has been removed from: $folder" -ForegroundColor Green
            } else {
                Write-Host "Folder '$Service' does not exist at: $folder" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Please provide a valid website name." -ForegroundColor Red
    }
}#>