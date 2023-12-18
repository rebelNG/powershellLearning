[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $ServicesName
)

# Check if the service name is provided
if ($ServicesName) {
    # Check if the website exists
    $website = Get-Website -Name $ServicesName -ErrorAction SilentlyContinue
    if ($website) {
        # Remove the website
        Remove-Website -Name $ServicesName
        Write-Host "Website '$ServicesName' has been removed."
    } else {
        Write-Host "Website '$ServicesName' does not exist or has already been removed."
    }

    # Test if folderpaths exist
    $folderPath1 = "D:\Releases\$ServicesName"
    $folderPath2 = "E:\inetpub\wwwroot\$ServicesName"
    $folderPath3 = "L:\IIS\$ServicesName"

    $folders = @($folderPath1, $folderPath2, $folderPath3)

    foreach ($folder in $folders) {
        if (Test-Path -Path $folder -ErrorAction SilentlyContinue) {
            Remove-Item -Path $folder -Force -Recurse
            Write-Host "Folder '$ServicesName' has been removed from: $folder"
        } else {
            Write-Output "Folder '$ServicesName' does not exist at: $folder"
        }
    }
} else {
    Write-Host "Please provide a valid website name."
}