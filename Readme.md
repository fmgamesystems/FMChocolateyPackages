# Fremantle Chocolatey Packages 

This repository contains a PowerShell script for installing and updating various software packages for Fremantle using the Chocolatey package manager. The script checks for installed packages, installs missing packages, and upgrades outdated packages to their latest versions.

## Usage

1. Clone or download this repository to your local machine.

2. Open PowerShell with Administrator privileges.

3. Navigate to the directory where the `Internalize.ps1` script is located.

4. Run the script within command in PowerShell:
    ```
    .\Internalize.ps1
    ```

The script will check if the software packages listed in the `$packages` variable are installed on the system, and install or update them as necessary.

## Customization

To enable or disable a specific software package, set the `Enable` property to `1` (enabled) or `0` (disabled) in the `$packages` variable.

To add a new software package, add a new entry to the `$packages` variable following the same structure as the existing entries, and set the `Name`, `Source`, and `Enable` properties accordingly.

Define the `$repoDir` and `$outDir` variables in the script to set the paths for the repository and output directories


Additional [Chocolatey ](https://docs.chocolatey.org/en-us/) documentation and resources.


