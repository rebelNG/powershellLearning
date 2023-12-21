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

    $TestServer = Test-Connection -ComputerName $Server -Count 1 -Quiet

    if($TestServer){
        $Session = New-PSSession -ComputerName $Server

        Invoke-Command -Session $Session -ScriptBlock{
            
            
            $Date = Get-Date -Format "MM-dd-yyyy HH:mm"
            $filename = "$CurrentUser-$Date-log.txt"
            $filePath = Join-Path -Path $LogFolder -ChildPath $filename

            param($Services, $CurrentUser)

            $LogContent = @()

            $LogContent += "$Server"
            $LogContent += "$CurrentUser $Date"
            $LogContent += ""

            foreach($Service in $Services){
                # Check if the service name is provided
                if ($Service) {
                    # Check if the website exists
                    $website = Get-Website -Name $Service -ErrorAction SilentlyContinue
                    if ($website) {
                        # Remove the website
                        $WebRemoval = Read-Host -Prompt "Please confirm you want to remove $Service ? Y/N"
                        if($WebRemoval -eq "Y"){
                            Remove-Website -Name $Service
                            Write-Host "Website '$Service' has been removed." -ForegroundColor White
                            $LogContent += "$Service website removal was successful"
                            $LogContent += ""
                        } else {
                            Read-Host -Prompt "Please Press Enter to Exit."
                            $LogContent += "$Service removal was unsuccessful"
                            $LogContent += ""
                            exit
                        }
                        
                    } else {
                        Write-Host "Website '$Service' does not exist or has already been removed." -ForegroundColor Red
                        $LogContent += "Website $Service does not exist"
                    }

                    # Test if folderpaths exist
                    $folderPath1 = "B:\Releases\$Service"
                    $folderPath2 = "E:\inetpub\wwwroot\$Service"
                    $folderPath3 = "L:\IIS\$Service"

                    $folders = @($folderPath1, $folderPath2, $folderPath3)

                    foreach ($folder in $folders) {
                        if (Test-Path -Path $folder -ErrorAction SilentlyContinue) {
                            $FolderRemoval = Read-Host -Prompt "Please confirm you want to remove $folder ? Y/N"
                            if ($FolderRemoval -eq "Y") {
                                Remove-Item -Path $folder -Force -Recurse
                                Write-Host "Folder '$Service' has been removed from: $folder" -ForegroundColor Green
                                $LogContent += "Folder: $Service successfuly removed from $folder"
                                $LogContent += ""
                            } else {
                                Read-Host -Prompt "Please Press Enter to Exit."
                                $LogContent += "Folder: $Service was not removed from $folder"
                                $LogContent += ""
                                exit
                            }
                            
                        } else {
                            Write-Host "Folder '$Service' does not exist at: $folder" -ForegroundColor Red
                            $LogContent += "Folder '$Service' does not exist at $folder"
                        }
                    }
                } else {
                    Write-Host "Please provide a valid website name." -ForegroundColor Red
                }
            }
            
            $LogFolder = "L:\ServiceRemoval Logs"
            $TestFolder = Test-Path $LogFolder -PathType Container
            if($TestFolder -eq $false){
                mkdir $LogFolder
            }

            $LogContent | Out-File -Append -FilePath $filePath
        } -ArgumentList $Services, $CurrentUser
        Remove-PSSession -Session $Session
    } 
}








<#foreach ($Service in $Services){
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