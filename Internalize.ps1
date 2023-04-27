# Ensure we can run everything
Set-ExecutionPolicy Bypass -Scope Process -Force

# Define the packages to be installed or updated
$packages = @(
    @{
        Name = "dotnet-6.0-aspnetruntime"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "dotnet-6.0-desktopruntime"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "dotnet-7.0-aspnetruntime"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "dotnet-7.0-desktopruntime"
        Source = "chocolatey"
        Enable = 1
    },
    @{
        Name = "vscode"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "vnc-connect"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "7zip"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "vlc"
        Source = "chocolatey"
        Enable = 0
    },
    @{
        Name = "obs"
        Source = "chocolatey"
        Enable = 1
    }
)

# Define the repo and output directories
$repoDir = "$env:BOXROOT\FM Game Systems\Choco"
$outDir = "$PSScriptRoot\Internalize"

# Remove the output directory if it exists and create a new one
Remove-Item -Path $outDir -Force -Recurse
New-Item -ItemType Directory -Path $outDir -Force

# Internalize and push the enabled packages
foreach ($package in $packages) {
    # Check if the package is enabled
    if ($($package.Enable)) {
        try {
            # Internalize the package
            Write-Output "Internalizing $($package.Name)"
            choco download $($package.Name) --source=$($package.Source) --outdir=$outDir --internalize
            # Update the package status based on the internalization result
            $package.Status = "Internalized"
        } catch {
            Write-Output "Error internalizing $($package.Name): $_"
            $package.Status = "Internalize failed"
        }
    } else {
        $package.Status = "Not enabled"
    }
}

# Push the internalized packages to the repo directory
Get-ChildItem -Path "$outDir" -Filter *.nupkg | ForEach-Object { 
    try {
        # Push the package to the repository
        Write-Output "Pushing $($_.FullName) to repo"
        choco push --source "$repoDir" "$($_.FullName)"
    } catch {
        Write-Output "Error pushing $($_.FullName) to repo: $_"
    }
}

# Check for installed packages and update if necessary using internalized packages from the repo
foreach ($package in $packages) {
    # Check if the package is enabled
    if ($($package.Enable)) {
        try {
            # Check if the package is already installed
            $installedPackage = choco list --local-only --exact $($package.Name) | Where-Object { $_ -match "packages installed" }
            
            # Update the package if it's installed, otherwise install it
            if ($installedPackage -ne $null) {
                Write-Output "Updating $($package.Name)"
                choco upgrade $($package.Name) --source=$repoDir
            } else {
                Write-Output "Installing $($package.Name)"
                choco install $($package.Name) --source=$repoDir
            }
        } catch {
            Write-Output "Error installing/updating $($package.Name): $_"
        }
    }
}