# Ensure we can run everything
Set-ExecutionPolicy Bypass -Scope Process -Force

# Define the packages to be installed or updated
$packages = Get-Content -Path packages.txt | ForEach-Object {
    # Parse through the packages.txt file
    @{
        Name = $_
        Source = "chocolatey"
    }
}

# Define the source and destination repositories
$sourceRepo = "chocolatey"
$destRepo = "FremantleCommon"

# Define the output directory
$outDir = "$PSScriptRoot\Internalize"

# Remove the output directory if it exists and create a new one
Remove-Item -Path $outDir -Force -Recurse
New-Item -ItemType Directory -Path $outDir -Force

# Check if a package has a newer version, then internalize and push
foreach ($package in $packages) {
    try {
        # Get the latest version from the source repository
        $latestVersion = (choco search $($package.Name) --source=$sourceRepo --exact --all-versions | Select-String -Pattern "\d+(\.\d+)+").Matches.Value | Sort-Object {[version]$_} -Descending | Select-Object -First 1

        # Get the current version from the destination repository
        $currentVersion = (choco search $($package.Name) --source=$destRepo --exact --all-versions | Select-String -Pattern "\d+(\.\d+)+").Matches.Value | Sort-Object {[version]$_} -Descending | Select-Object -First 1

        # Check if the latest version is newer than the current version
        if ([version]$latestVersion -gt [version]$currentVersion) {
            Write-Output "Internalizing and pushing new version of $($package.Name) ($latestVersion)"

            # Internalize the package
            choco download $($package.Name) --source=$sourceRepo --version=$latestVersion --outdir=$outDir --internalize

            
            Write-Output "choco download $($package.Name) --source=$sourceRepo --version=$latestVersion --outdir=$outDir --internalize"


            # Push the internalized package to the destination repository
            $internalizedPackage = Get-ChildItem -Path "$outDir" -Filter *.nupkg -Recurse
            choco push --source $destRepo $internalizedPackage.FullName
        } else {
            Write-Output "No update needed for $($package.Name) (current version: $currentVersion)"
        }
    } catch {
        Write-Output "Error processing $($package.Name): $_"
    }
}

# Clean up the output directory
Remove-Item -Path $outDir -Force -Recurse
