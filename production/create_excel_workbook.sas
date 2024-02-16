/***********************************************************************************
 PROGRAM DESCRIPTION: Create Monthly Company HR Excel Report                      
************************************************************************************
 SUMMARY: Program prepares and uploads data for the third party legal data report.
          Report can be found in All Reports -> Legal -> Third Party Reports.    
          Report identifies all requested third party legal data. Program executes
          as a job every day at 6AM (EST).                                        
 CREATED BY: Peter S                                                              
 DATE: 04/1/2024                                                                  
************************************************************************************
 REQUIRED INPUT DATA                                                              
************************************************************************************
 1. <DATE>_emp_info_raw.xlsx : main folder > data                                
    - Excel file contains all of the HR data from our systems. The default file    
      name is <YYYY>M<MM>_emp_info_raw for the year and month the data was extracted.                                                         
***********************************************************************************
 REQUIRED PROGRAM FILES                                                           
***********************************************************************************
 - 00_config.sas - Creates macro variables and programs for the Excel output.
 - 01_prepare_data.sas - Prepares the <date>_emp_info_raw.xlsx file into SAS tables. 
 - 02_worksheet01.sas - Creates the first worksheet with a workbook overview.
 - 03_worksheet02.sas - List of all employees.
 - 04_worksheet03.sas - Company overview information.
 - 05_worksheet04.sas - Division analysis.
 - 06_worksheet05.sas - Employee leave overview.
***********************************************************************************
* OUTPUT FILES                                                                     
***********************************************************************************
 1. <DATE>_HR_REPORT.xlsx
   - Location: main folder > production > output 
   - Dynamically names the workbook using the month and year.
***********************************************************************************
  REQUIREMENT: SPECIFY MAIN FOLDER PATH                                       
***********************************************************************************/
/* Specify the path to your main workshop folder */
%let folder_path = C:/Users/pestyl/OneDrive - SAS/github repos/ExcelMasterywithSAS_Workshop;




/**************************************************/
/* CUSTOM SETTINGS                                */
/**************************************************/
%include "&folder_path/production/programs/00_config.sas";

/**********************/
/* PREPARE DATA       */
/**********************/
/* Program will read from the raw Excel data (main folder > data) and prepare the final tables in the WORK library */
%include "&production_path./programs/01_prepare_data.sas";


/**************************************************/
/* CREATE EXCEL WORKBOOK                          */
/**************************************************/
/* Close all output destinations */
ods _all_ close;

/* Use PNG images */
ods graphics / imagefmt=png;

/* Write to Excel and create a **DYNAMIC WORKBOOK NAME**  */
ods excel file="&outpath/&currMonthYear._HR_REPORT_FINAL.xlsx" 
          options(sheet_interval ="NONE");


/* Run the following programs. Each program creats a worksheet */
%include "&production_path./programs/02_worksheet01.sas";
%include "&production_path./programs/03_worksheet02.sas";
%include "&production_path./programs/04_worksheet03.sas";
%include "&production_path./programs/05_worksheet04.sas";
%include "&production_path./programs/06_worksheet05.sas";


/* Close and write to Excel */
ods excel close;

/* Reopen HTML destination */
ods html;