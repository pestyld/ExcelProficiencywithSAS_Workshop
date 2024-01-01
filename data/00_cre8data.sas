/*************************************************/
/* CREATE DATA FOR THE WORKSHOP                  */
/*************************************************/
/* - Uses the sample sampsio library             */
/* - Should be available in your SAS enviornment */
/* - Creates 4 tables in your WORK library       */
/*************************************************/

/************************************************************************/
/* REQUIREMENT: Set the path to your workshop root folder               */
/************************************************************************/
/* - This program will dynamically find the location of the root folder */
/* - This works in SAS9 for SAS Studio and Enterprise Guide             *; 
/* - This works in SAS Viya in SAS Studio                               */
/* - If the code doesn't work, manually enter your main folder for this */
/*   workshop in the %let path macro variable                           */
/************************************************************************/
%let fileName =  /%scan(&_sasprogramfile,-1,'/');
%let data_path = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));


/* Confirm in the log that the path macro variable is referencing the main workshop folder */
%put &=data_path;



/**************************************************/
/*  CREATE EMP_INFO.XLSX FILE IN THE DATA FOLDER  */
/**************************************************/
/* Use the SAMPSIO default SAS library to create the XLSX workbook */
/* - Modify the years to more current years                        */
/* - Increase salary by 30%                                        */

libname xlout xlsx "&data_path/emp_info.xlsx";

data xlout.empinfo;
	set sampsio.empinfo;
	call streaminit(1);
	addYears=rand('uniform',10,29);
	HDATE=mdy(month(HDATE),day(HDATE),YEAR(HDATE)+addYears);
	BIRTHDAY=mdy(month(BIRTHDAY), day(BIRTHDAY), year(BIRTHDAY)+addYears);
	TODAYS_DATE=mdy(04,01,2024);
	format TODAYS_DATE date9.;
	drop addYears;
run;

data xlout.salary;
	set sampsio.salary;
	SALARY = SALARY * 1.40;
run;

data xlout.jobcodes;
	set sampsio.jobcodes;
run;

data xlout.leave;
	set sampsio.leave;
	call streaminit(1);
	LEAVEDAYS=rand('uniform',14,120);
	LVBEGDTE=mdy(rand('uniform',1,4),day(LVBEGDTE),2024);	
	LVENDDTE=LVBEGDTE+LEAVEDAYS;
	drop LEAVEDAYS;
run;

libname xlout clear;




/********************************/
/*  DELETE BAK FILE             */
/********************************/
* If the bak files exists, delete using the FDELETE function *;
* Reference the Excel workbook .bak file *;
filename f_bak "&data_path/emp_info.xlsx.bak";
data _null_;
	if fexist('f_bak') = 1 then do;
		f_bak_exists = fdelete('f_bak');
		put 'NOTE: The file was deleted';
	end;
run;