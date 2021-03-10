# Revature Recruitment Startup

## Description
There are several components of this project that need to be setup in order to continue working on it. These components include running the SSIS packages to instantiate the 
Relational Database and Data Warehouse, properly deploying the several Tabular Analysis models to an Analysis Service, and publishing the various SSRS and Power Bi reports to
the Power Bi Web Service. Following this startup file will allow anyone who continues this project in the future a good starting point.

### Getting Started - SSIS
#### Requirements
* Microsoft SQL Server 2016 or greater.
* Microsoft SQL Server Management Studio
* Microsoft SQL Server Integration Services (SSIS)
* Microsft SQL Server Data Tools (SSDT) 2017
* Microsoft Excel
---
* Clone the Git Repository to your machine.
  * ```git clone "https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment.git"```
* Navigate to the P3-RevatureRecruitment\SSIS directory.
  * In this directory is a collection of all the SSIS solutions/packages that the teams developed.
* Open the RevatureRecruitmentSSIS directory, right click the .sln file, and open with Microsoft Visual Studio 2017.
  * This is the master solution for all things SSIS related for this project. Opening with VS 2017 ensures that you use the standalone SSDT you should have installed.
![VS 2017](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/OpenWithVS2017.PNG)
* In the Solution Explorer, you will see a list of packages the solution contains. Double click Controller.dtsx to open the main execution of this solution.
