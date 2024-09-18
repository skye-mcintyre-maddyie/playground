# Define the current directory
$directory = Get-Location
# Define the default file to save the hashes
$hashFile = "$directory\hashes.txt"

# Option 1: Save the hashes to a single file
function Save-Hashes {
    $hashes = @()
    Get-ChildItem -Path $directory -Filter *.zip | ForEach-Object {
        $fileName = $_.Name
        $hash = Get-FileHash -Path $_.FullName -Algorithm SHA256
        $hashes += "$fileName`t$($hash.Hash)"
    }
    $hashes | Out-File -FilePath $hashFile
    Write-Output "Hashes saved to ${hashFile}"
}

# Option 2: Check the hashes against the saved hashes
function Check-Hashes {
    if (-Not (Test-Path -Path $hashFile)) {
        Write-Output "Hash file not found!"
        return
    }
    $savedHashes = @{}
    Get-Content -Path $hashFile | ForEach-Object {
        $parts = $_ -split "`t"
        $savedHashes[$parts[0]] = $parts[1]
    }
    Get-ChildItem -Path $directory -Filter *.zip | ForEach-Object {
        $fileName = $_.Name
        $currentHash = Get-FileHash -Path $_.FullName -Algorithm SHA256
        if ($savedHashes[$fileName] -eq $currentHash.Hash) {
            Write-Output "${fileName}: Hash matches"
        } else {
            Write-Output "${fileName}: Hash does not match"
        }
    }
}

# Main script logic
if (Test-Path -Path $hashFile) {
    Check-Hashes
} else {
    Save-Hashes
}
