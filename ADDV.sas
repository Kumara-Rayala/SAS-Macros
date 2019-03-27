/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
* PROGRAM   : ADDV.SAS
* FUNCTION  : Creates ADDV Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADDV Analysis dataset
*
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
* 
****************************************************************************/
/*%let studyid=3110A1-3000-AF;*/
dm "output;clear";
dm "log;clear";
%include "D:\Aspire study\macros\setup.sas";
%lib();
proc import datafile="D:\MNT15001\MNT15001\Data\External Data\Deviations\Copy of Subject Protocol Deviations 8.7.2016.xlsx"
            out=dv1
			dbms=xlsx replace;
			getnames=no;
			datarow=2;
run;
data dv2;
 set dv1;
 if a ne "";
run;
proc transpose data=dv2 out=dv2_1;
 var _all_;
run;
proc transpose data=dv2_1 out=dv2_2;
 id col1;
 var _all_;
run;
data dv3;
 set dv2_2;
  if _n_ >3;
  drop _name_ _label_;
run;
data dv4 ;
 set dv3;
  len= length(deviation_description);
run;
 


