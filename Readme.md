# Fremantle Chocolatey Packages 

This repository contains a PowerShell script for installing and updating various software packages for Fremantle using the Chocolatey package manager. The script checks for installed packages, installs missing packages, and upgrades outdated packages to their latest versions.

The script uses a text file, packages.txt, to determine the list of packages to manage. 

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

To add or remove a software package, simply edit the packages.txt file. Add a new line for each package you wish to manage, or remove lines for packages you no longer need.

Define the `$repoDir` and `$outDir` variables in the script to set the paths for the repository and output directories


Additional [Chocolatey ](https://docs.chocolatey.org/en-us/) documentation and resources.

Pass the argument --install-directory=value to set or change the default install directory for local packages Fremantle requries.




