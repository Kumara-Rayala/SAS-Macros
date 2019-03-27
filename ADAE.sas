/****************************************************************************
* STUDY     : Aspire Information Technologies Ltd
* PROGRAM   : ADAE.SAS
* FUNCTION  : Creates ADAE Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADAE Analysis dataset
*
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
* 
****************************************************************************/
/*%let studyid=3110A1-3000-AF;*/

%include "D:\Aspire study\macros\setup.sas";
%lib();

proc import datafile="D:\MNT15001\MNT15001\Data\External Data\Coding\MNT15001_AE_Final_20160712_1551.xls"
            out=ae1
			dbms=xls replace;
			getnames=yes;
run;

data ae2;        
 set ae1(rename=(num=num_ llt_c=llt_c_ pt_c=pt_c_ hlt_c=hlt_c_ 
                 hlgt_c=hlgt_c_ soc_c=soc_c_));
	LLT_C=input(llt_c_,best.);
	PT_C=input(PT_C_,best.);
	HLT_C=input(hlt_c_,best.);
	HLGT_C=input(hlgt_c_,best.);
	SOC_C=input(soc_c_,best.);
	NUM=input(num_,best.);
	drop llt_c_ pt_c_ hlt_c_ hlgt_c_ soc_c_ num_;
run;

data adverse;
attrib SUBJID format=$15. llt_t format=$70.;
 set raw.Adverseevents(rename=(subjid=subjid_));
 SUBJID=put(subjid_,z6.);
 where maetext ne "" and strip(upcase(label_md1)) ne "PAGE DELETED";
 if STARTD_VC ="MO" and substr(startd,1,3)="01/" and length(startd)= 10 then do;
  put startd= startd_vc=;
  startd=substr(startd,4);
 end;
 if stopd_vc="MO" and substr(stopd,1,3)="01/" and length(stopd)=10 then do;
  put stopd= stopd_vc=;
  stopd=substr(stopd,4);
 end;
 if startd_vc="YR" and substr(startd,1,6)="01/01/" and length(startd)=10 then do;
  put startd= startd_vc;
  startd=substr(startd,7);
 end;
 if stopd_vc="YR" and substr(stopd,1,6)="01/01/" and length(stopd)=10 then do;
  put stopd= stopd_vc=;
  stopd=substr(stopd,7);
 end;
run;

proc sort data=ae2;
 by subjid maetext visit num;
run;
proc sort data=adverse;
 by subjid maetext visit num;
run;

data ae3 ;
 merge adverse(in=a) ae2(in=b);
 by subjid maetext visit num;
run;

proc import datafile="D:\MNT15001\MNT15001\Data\External Data\Ocular grading\Copy of Ocular grading_Site3_JLarbelee corr.xlsx"
            out=oculr
			dbms=xlsx replace;
			datarow=2;
			getnames=no;
run;
proc transpose data=oculr out=t_oculr;
 var _all_;
run;
proc transpose data=t_oculr out=ocular;
 id col1;
 var _all_;
run; 
data ocular1;
 set ocular;
 if  _n_ > 3; 
 drop _name_ _label_;
run;
data ocular2;
attrib maetext format=$72. STARTD format=$13. STOPD format=$13.;
 set ocular1(rename=(llt_code=llt_c_ pt_code=pt_c_ hlt_code=hlt_c_ 
                 hlgt_code=hlgt_c_ soc_code=soc_c_));
 LLT_C=input(llt_c_,best.);
 PT_C=input(PT_C_,best.);
 HLT_C=input(hlt_c_,best.);
 HLGT_C=input(hlgt_c_,best.);
 SOC_C=input(soc_c_,best.);
 SUBJID1=input(patient,best.);
 maetext=verbatim;
 STARTD=START_DATE;
 STOPD=stop_date;
 if startd="K" then startd="NK";
 drop llt_c_ pt_c_ hlt_c_ hlgt_c_ soc_c_;
run;
proc sort data=ae3;
 by subjid1 maetext startd stopd;
run;
proc sort data=ocular2;
 by subjid1 maetext startd stopd;
run;
data ae4;
 merge ae3(in=a) ocular2(in=b);
 by subjid1 maetext startd /*stopd*/;
run;
data ae5;
 set ae4;
 %usubj;
  STUDYID="&studyid.";
  DOMAIN="AE";
  AETERM=strip(MAETEXT);
  ADEDECOD=strip(pt_t);
  AELLT=strip(llt_t);
  AELLTCD=llt_c;
  AEPTCD=pt_c;
  AEHLT=strip(hlt_t);
  AEHLTCD=hlt_c;
  AEHLGT=strip(hlgt_t);
  AEHLGTCD=hlgt_c;
  AEBODSYS=strip(soc_t);
  AEBDSYCD=soc_c;
  AESOC=strip(soc_t);
  AESOCCD=soc_c;
  AECAT="ADVERSE EVENTS";
  AESCAT=strip(LBLSTYP);
  if strip(upcase(FSAEYN))="YES" then AESER="Y";
   else if FSAEYN="" then AESER="N";
  if strip(upcase(WTHDW))="YES" then AEACN="DRUG WITHDRAWN";
  if strip(upcase(RELATS))="YES" then AEREL="REALTED";
   else if strip(upcase(RELATS))="NO" then AEREL="NOT RELATED";
run;
proc sort data=sdtm_.dm out=trtsdt(keep=usubjid rfstdtc rfendtc);
 by usubjid;
run;
proc sort data=ae5;
 by usubjid;
run;
data trt;
 merge ae5(in=a) trtsdt(in=b);
 by usubjid;
 if a;
run; 
data ae6;
 set trt;
 
/*/*check */*/
/*data check(keep=subjid1 maetext visit Corrected_grading_15_09_2014 TOXGR);  ;*/
/* set ae4;*/
/*  where Corrected_grading_15_09_2014 ne "";*/
/*run;*/
/*proc sql;*/
/* create table class as select monotonic() as ID,* from sashelp.class;*/
/* quit;*/


