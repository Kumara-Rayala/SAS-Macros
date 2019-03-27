/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
* PROGRAM   : ADEX.SAS
* FUNCTION  : Creates ADEX Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADEX Analysis dataset
*
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
* 
****************************************************************************/
/*%let studyid=3110A1-3000-AF;*/
dm 'log;clear';
dm 'output;clear';
%include "D:\Aspire study\macros\setup.sas";
%lib;
proc sort data=raw.testarticle out=test;
  by subjid;
run;
proc sort data=sdtm_.dm out=trt(keep=usubjid rfstdtc actarm actarmcd);
  by usubjid;
run;

data ex1;
 set test(drop=subjid);
 SUBJID=put(subjid1,z6.);
 %usubj();
run;
data ex2;
 merge ex1(in=a) trt(in=b);
 by usubjid;
 if a;
 STUDYID="&studyid";
 DOMAIN="EX";
 EXTRT=actarm;
 EXDOSE=AMT;
 EXDOSEU="";
 EXDOSFRM=compress(AMTU||"SULES");
 EXROUTE="ORAL";
 EXFAST=ATEYN;
run;
proc sort data=ex2 out=ex3;
 by usubjid startd;
 where length(startd)=10 and upcase(startd)not in ("","NA");
run;
data ex_st(keep=usubjid startd rename=(startd=EXSTDT)) ex_en(keep=usubjid startd rename=(startd=EXENDT));
 set ex3;
  by usubjid startd;
   if first.usubjid then output ex_st;
   if last.usubjid then output ex_en;
run;
data ex4;
 merge ex2(in=a) ex_st(in=b) ex_en(in=c);
 by usubjid;
 if a;
 EXSTDTC=put(input(exstdt,ddmmyy10.),is8601da.);
 EXENDTC=put(input(exendt,ddmmyy10.),is8601da.);
run;
data ex5;
 set ex4;
  where strip(upcase(startd))not in ("","NA");
   if length(exstdtc)=10 and length(rfstdtc)=10 then do;
    if input(exstdtc,is8601da.)>= input(rfstdtc,is8601da.) then
      EXSTDY=(input(exstdtc,is8601da.)-input(rfstdtc,is8601da.))+1;   
    else if input(exstdtc,is8601da.)< input(rfstdtc,is8601da.) then
      EXSTDY=input(exstdtc,is8601da.)-input(rfstdtc,is8601da.);
   end;
   if length(exendtc)=10 and length(rfstdtc)=10 then do;
    if input(exendtc,is8601da.)>= input(rfstdtc,is8601da.) then
      EXENDY=(input(exendtc,is8601da.)-input(rfstdtc,is8601da.))+1;
    else if input(exendtc,is8601da.)< input(rfstdtc,is8601da.) then
      EXENDY=input(exendtc,is8601da.)-input(rfstdtc,is8601da.);
   end;
run;
proc sort data=ex5;
 by usubjid exstdtc exendtc;
run;

data ex_f;
 set ex5;
 by usubjid exstdtc exendtc;
  if first.usubjid then EXSEQ=0;
   EXSEQ+1;
run;
%spec(domain=EX);







