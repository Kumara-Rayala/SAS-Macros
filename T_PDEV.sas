/***************************************************************************
* COMPANY  : Aspire information technologies Ltd
* PROGRAM  : T_PDEV.sas
* FUNCTION : Creates Protocol Deviation table from the analysis dataset.
* AUTHOR   : Kumara Rayala
* NOTES    :
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
*
****************************************************************************/
%include "D:\Aspire study\macros\setup.sas";
%lib();
proc sort data=adam.addv out=addv;
 by usubjid dvterm trt01an;
  where Randfl="Y" and DVTERM^="" and index(upcase(dvscat),"EFFICACY") and usubjid ne 'MULTIPLE' and upcase(dvcat)='MAJOR';
run;
/*-----------ANY(1)----------------*/
data dv1;
 set addv;
  where DVPRIMEF ne "" or DVSECEF ne "" or DVEXPEF ne "";
  cat="Any [1]";
  ord=1;
run;
proc sort data=dv1 out=dv2 nodupkey;
 by usubjid trt01an ;
run;
data any1;
 set dv2;
 output;
  trt01a='overall';
  trt01an=99;
 output;
run;
/*------------------------ALL-------------------------*/
data all;
 set addv;
  where DVPRIMEF ne "" and DVSECEF ne "" and DVEXPEF ne "";
  ord=2;
run;
proc sort data=all out=all1 nodupkey;
  by usubjid trt01an;
run;
proc sort data=all out=all2 nodupkey;
 by usubjid trt01an dvterm;
run;

data all_f;
 set all1(in=a) all2(in=b);
  if a then do;
   dvterm="Any [2]";
   subord=1;
  end;
     cat="All";
run;
/*--------------Primary efficacy analysis------------------*/
data prim;
 set addv;
  where DVPRIMEF ne "";
  ord=3;
run;
proc sort data=prim out=prim1 nodupkey;
 by usubjid trt01an;
run;
proc sort data=prim1 out=prim2 nodupkey;
 by usubjid trt01an dvterm;
run; 
data prim_f;
 set prim1(in=a) prim2(in=b);
  if a then do;
   dvterm="Any [2]";
   subord=1;
  end;
     cat="Primary efficacy analysis";
run;
/*---------------Secondary efficacy analysis-----------------*/ 
data secon;
 set addv;
  where DVSECEF ne "";
 ord=4;
run;
proc sort data=secon out=sec1 nodupkey;
 by usubjid trt01an;
run;
proc sort data=secon out=sec2 nodupkey;
 by usubjid trt01an dvterm;
run;
data sec_f;
 set sec1(in=a) sec2(in=b);
  if a then do;
  dvterm="Any [2]";
  subord=1;
  end;
    cat="Secondary efficacy analysis";
run;
/*------------------Exploratory efficacy analysis----------------*/
data explo;
 set addv;
  where DVEXPEF ne "";
 ord=5;
run;
proc sort data=explo out=explo1 nodupkey;
 by usubjid trt01an;
run;
proc sort data=explo out=explo2 nodupkey;
 by usubjid trt01an dvterm;
run;
data explo_f;
 set explo1(in=a) explo2(in=b);
 if a then do;
  dvterm="Any [2]";
  subord=1;
 end;
   cat="Exploratory efficacy analysis";
run;
/*---------------appending the all analysis datasets*/
data final_1;
 set explo_f all_f prim_f sec_f ;
run;
data final_2;
 set final_1;
  output;
  trt01an=99;
  trt01a="Overall";
  output;
run;
data final3;
 set final_2(in=a) any1(in=b);
  if b then dvterm="";
run;
proc sort data=final3;
 by ord subord cat dvterm;
run;
proc freq data=final3 noprint;
 by ord subord cat dvterm;
 table trt01an/out=final_4;
run;
/*-----------calculating the percentages based on the bign counts of the ADSL dataset*/
data dm1;
 set adam.adsl;
  where strip(randfl)="Y" and trt01an ne .;
  output;
   trt01an=99;
   trt01a="Overall";
  output;
run;
proc sort data=dm1;
  by trt01an;
run;
proc freq data=dm1 noprint;
 by trt01an;
 tables trt01a/out=bign(drop=percent);
run;
proc sort data=final_4;
 by trt01an;
run;
proc sort data= bign;
 by trt01an;
run;
data final_5;
 merge final_4(in=a drop=percent) bign(in=b rename=(count=bign));
 by trt01an;
 if a;
run;
data final_6;
 set final_5;
 cnt=strip(put(count,best.))||" ("||strip(put((count/bign)*100,5.1))||")";
run;
proc sort data=final_6;
 by ord subord cat dvterm;
run;
proc transpose data=final_6 out=final_t;
 by ord subord cat dvterm;
 id trt01an;
 var cnt;
run;
data final;
 set final_t(drop=_name_);
  array dup (*) _:;
  do i=1 to dim(dup);
   if dup(i) ="" then dup(i)="0  ";
  end;
run;

proc sort data=final;
 by ord descending subord cat dvterm;
run;
data _null_;
 set bign;
  call symput("N"||strip(put(_n_,best.)),"(N="||strip(put(count,best.))||")");
run;
%put &n1 &n2 &n3;
dm "output;clear";
proc report data=final headskip headline spacing=0 nowd split="*" ls=134 ps=43;
    column("__" ord subord cat dvterm _1 _2 _99);
	   define ord/order=data noprint;
	   define subord/order=data noprint;
	   define cat/"Analysis affected" width=24 flow group order=data ;
	   define dvterm/"Deviation" width=50 flow group order=data;
	   define _1/"Moxidectin*(8 mg)*&n1*n (%)" width=20;
	   define _2/"Ivermectin*(150 µg/kg)*&n2*n (%)" width=20;
	   define _99/" *Overall*&n3*n (%)" width=20;
  break after cat/skip;
run;





  



