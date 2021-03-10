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
* Extend the dropdown, and if done correctly, you should see RevatureDatabase listed here. Click it to select the database.
* Click ```Test Connection``` to ensure the connection is working properly. If so, click OK.
* Repeat these exact steps for ```(project)RevatureDW```, pointing to RevatureDW instead.

##### Setting the Package Connections
Many packages in this solution use the project connections, but a few use connections to Excel or Flat Files. We must set these up as well.
* Double click the ExceltoDB.dtsx. This is the package that extracts the data from the dataset and loads it into a Relational Database.
* In addtion to the two project connections, there will be an Excel Connection and a Flat File connection.
![ExcelToDBConnections](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/ExcelToDBConnections.PNG)
  * The Excel connection connects to the dataset, while the Flat File connection connects to a csv file with US States information.
* Double click the Excel Connection and browse to P3-RevatureRecruitment\Datasets\MSBI P3 Dataset_V4_Clean.xlsx. Click OK.
  * The program should automatically detect the proper Excel version, but in the event it does not choose Microsoft Excel 2007-2010.
* Double click the Flat File Connection and Browse to P3-RevatureRecruitment\Datasets\50_us_states_all_data.csv.
* Ensure that all configurations match the following image.
![FlatFileCofiguration](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/FlatFileConfiguration.PNG)
  * Click Columns in the left pane. If done correctly, you should see two columns: StateFull and StateAbbrev.
---
* Double click CreateDimDate.dstx. This package loads dim_Date from an Excel file.
* Double click ```dimDate``` in the Connection Managers pane, underneath the Design window.
* Browse to P3-RevatureRecruitment\Datasets\dimDate.xlsx and hit OK.
  * Like before, select Microsoft Excel 2007-2010 for the Excel version if it does not detect it automatically.
---
* Double click InsertData_Into_fct_Training.dtsx. This package loads the fct_Training table.
* Double click ```RevatureDW_ADO``` in the Connection Managers pane.
  * This connection is an ADO.NET connection. The script files are not compatible with the OLE DB Connection that the project connections use, so it is necessary to have this       package connection.
* Like with the project connections, insert the server name the data warehouse is hosted on. Select Windows Authentication, or SQL Server Authentication if necessary, and point   to RevatureDW.
* Click ```Test Connection``` to ensure the connection is working properly. If so, click OK.
---
* Double click pkg_fct_Recruitment.dtsx. This package is responsible for loading the fct_Recruitment table.
* This package uses Username and Password parameters in it's data flow. 
  * If you are using Windows Authentication then the following steps are unecessary.
* In the Design window, click the Parameters tab.

![fctRecruitmentParamters](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/fctRecruitmentParameters.PNG)
* If using SQL Server Authentication, and using the same server for both the database and data warehouse, enter the username and password in the ```Value``` field for both DB     and DW.
---
Now that all the packge connections are set, all that remains is to configure the final SQL Task.
* Double click the Controller.dtsx, or navigate to it's tab if it is still open in the Design window. 
* At the end of the flow, double click ```Change ActionDate for STEM Majors```.
  * This is an Execute SQL Task that updates date fields in fct_Offers and fct_Latency to differentiate the data a little more.
* In the Task Editor, locate the Connection field in the SQL Statement section, and click the drop down menu.
* Select the RevatureDW connection. Click OK.
![ActionDateQuery](https://github.com/920-MSBI-Recruitment/P3-RevatureRecruitment/blob/dev/Images/ActionDateQueryConfiguration.PNG)
##### Running the Package
* Assuming the following steps were followed properly, and the schemas are in place on the server, the package can now be run.
* Ensure that the Controller.dtsx package is open. Click the Start button, next to the green play button.
* The package will now run in it's entirety. As the package executes, the other packages will open themselves and mark themselves complete as the package goes. 
* If everything goes to plan, the package should finish with every component having a green check mark. The database and data warehouse are now loaded.

### SSAS
This section will detail how to setup the tabular models for each domain relevant to the business questions asked by the project owner.

#### Requirements
* Microsoft SQL Server 2016 or greater.
* Microsoft SQL Server Management Studio
* Microsoft SQL Server Analysis Services
* Microsoft Visual Studio 2017 (SSDT)

TBD

### Power Bi and SSRS
This section will detail how to setup and publish the Power Bi to a Power Bi Web Service workspace, as well as how to migrate SSRS reports to Power Bi.

#### Requirements
* Microsoft SQL Server 2016 or greater.
* Microsoft SQL Server Reporting Services
* Microsoft Power Bi
* Microsoft Visual Studio 2017 (SSDT)

TBD
