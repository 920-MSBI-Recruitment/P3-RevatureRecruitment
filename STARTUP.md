# Revature Recruitment Startup

## Description
There are several components of this project that need to be setup in order to continue working on it. These components include running the SSIS packages to instantiate the 
Relational Database and Data Warehouse, properly deploying the several Tabular Analysis models to an Analysis Service, and publishing the various SSRS and Power Bi reports to
the Power Bi Web Service. Following this startup file will allow anyone who continues this project in the future a good starting point.

### Getting Started - Setting up the Schema
Provided with this project are the Schema files for the relational database (RevatureDatabase) and the data warehouse (RevatureDW). It is essential that we execute these scripts
to ensure that the following SSIS steps work properly

#### Requirements
* Microsoft SQL Server 2016 or greater.
* Microsoft SQL Server Management Studio.
---
* Open SQL Server Management Studio and connect to the instance you want to host these databases on.
  * This can be a local instance of SQL Server or an Azure SQL Server.
* Navigate to the P3-RevatureRecruitment\Backups and Schemas directory and double click the RevatureDBSetup.sql file.
  * This should automatically open the script in SSMS. Alternatively, open the file in SSMS by clicking File->Open->File and navigating to the same folder.
* Execute the script by clicking Execute, next to the green play button.
  * If done properly, the Messages box at the bottom of the screen should say ```Commands completed successfully.```
* Repeat this process for the RevatureDW_Schema.sql file.

### SSIS
This section will detail how to use the SSIS packages to load the relational database and data warehouse with the information found the the dataset. These steps will detail the process for loading to a local SQL instance, though loading to an Azure SQL Server is a very similar process and will be explained where applicable.

#### Requirements
* Microsoft SQL Server 2016 or greater.
* Microsoft SQL Server Management Studio
* Microsoft SQL Server Integration Services (SSIS)
* Microsoft Visual Studio 2017 (SSDT)
* Microsoft Excel
---
##### Acquiring the Solution
* Clone the Git Repository to your machine.
  * ```git clone "https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment.git"```
* Navigate to the P3-RevatureRecruitment\SSIS directory.
  * In this directory is a collection of all the SSIS solutions/packages that the teams developed.
* Open the RevatureRecruitmentSSIS directory, right click the .sln file, and open with Microsoft Visual Studio 2017.
  * This is the master solution for all things SSIS related for this project. Opening with VS 2017 ensures that you use the standalone SSDT you should have installed.
![VS 2017](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/OpenWithVS2017.PNG)
* In the Solution Explorer, you will see a list of packages the solution contains. Double click Controller.dtsx to open the main package of this solution.
* The center of the screen should now show the Design window, with the Data Flow of this package. The bottom of the screen shows the Connection Managers used by this package.
 * If you see a lot of red X's in this window, this is not unusual. There is some tidying that must be done before the package can be executed.

##### Setting the Project Connections
Each component in this design window is linked to a package listed in the Solution Explorer. We must now begin the process of setting our data connections.
* In the Controller.dtsx package, there will be two connections listed in the Connection Managers pane:
![Controller Connections](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/ControllerPackageConnections.PNG)
 * Notice that these two connections are prefixed with (project). This states that these connections are used throughout the entire project.
* Double click ```(project)RevatureDB``` to open the Connection Manager window.
* Input the server name of the instance you loaded the RevatureDatabase schema onto. 
* For authentication, use Windows Authentication is it is setup on your server. Otherwise, use SQL Server Authentication and whichever account you use to access the engine.
 * For Azure SQL Servers, input the Azure server name and select SQL Server Authentication. Ensure you enter the proper credentials used to access the cloud database.
* In the ```Connect to a database``` portion of the window, click the button for ```Select or enter a database name:```.
* Extend the dropdown, and if done correctly, you should see RevatureDatabase listed here. Select it and hit OK.
* Repeat these exact steps for ```(project)RevatureDW```, pointing to RevatureDW instead.

##### Setting the Package Connections
Many packages in this solution use the project connections, but a few use connections to Excel or Flat Files. We must set these up as well.
* Double click the ExceltoDB.dtsx. This is the package that extracts the data from the dataset and loads it into a Relational Database.
