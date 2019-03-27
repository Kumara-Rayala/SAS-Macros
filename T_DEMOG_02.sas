/***************************************************************************
* COMPANY  : Aspire information technologies Ltd
* PROGRAM  : T_DEMOG_02.sas
* FUNCTION : Creates Demography table from the analysis dataset.
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
proc sort data=adam.adsl out=adsl;
  by usubjid;
  where upcase(strip(mittfl))="Y" and trt01an ne . and siteid ne "";
run;
%macro mean(var=,cat=,ord=);
data &var.;
 set adsl;
 where &var. ne .;
run;
data &var.;
 set &var.;
 output;
  trt01an=99;
  trt01a="Overall";
 output;
run;
proc means data=&var. noprint maxdec=0 missing ;
 class siteid trt01an;
 var &var.;
 output out=&var._m n=n mean=Mean std=sd min=Minimum q1=Q1 Median=Median q3=Q3 
                  Max=Maximum;
run;
data &var._m;
 set &var._m;
  if not missing(siteid) and not missing(trt01an);
run;
data &var._m1;
 set &var._m;
 N_=put(n,5.0);
 Mean_=put(mean,5.1);
 Std_=put(sd,5.2);
 min_=put(minimum,5.0);
 q1_=put(q1,5.1);
 Median_=put(median,5.1);
 q3_=put(q3,5.1);
 max_=put(maximum,5.0);
 drop n mean sd minimum q1 median q3 maximum;
 cat=&cat.;
 ord=&ord.;
run;
proc sort data=&var._m1;
 by siteid ord cat ;
proc transpose data=&var._m1 out=&var._t;
 by siteid ord cat ;
 id trt01an;
 var n_ mean_ std_ min_ q1_ median_ q3_ max_;
run;

data &var._f(drop=_name_);
 length stat $60.;
 set &var._t;
  subord=_n_;
  stat=_name_;
run;
%mend;
%mean(var=age,cat="Age (years) [1]",ord=1);
%mean(var=heightbl,cat="Height (m) at Screening",ord=5);
%mean(var=weightbl,cat="Weight (kg) at Screening",ord=6);
%mean(var=bmibl,cat="Body mass index (kg/m^2) at Screening [2],",ord=7);
%mean(var=bsabl,cat="Body surface area (m^2) at Screening [3]",ord=8);
  
data mean_final;
 set bmibl_f age_f heightbl_f weightbl_f bsabl_f;
run;
/* Calculating the counts and percentages of agegroup,sex,race--------- */
data adsl_cat;
set adsl;
output;
trt01an=99;
trt01a="Overall";
output;
run;

proc freq data=adsl_cat noprint;
 by siteid;
 tables trt01an/out=bign(drop=percent);
run;

data cat1;
length cat $50.;
 length varcat $100.;
 set adsl_cat(in=a where=(agegrp ne .)) adsl_cat(in=b where=(sex ne "")) 
     adsl_cat(in=c where=(race ne ""));
	 if a then do;
           ord=2;
           cat="Age Category n (%)";
	 end;
	 if b then do;
           ord=3;
		   cat="Sex n (%)";
	 end;
	 if c then do;
           ord=4;
		   cat="Race n (%)";
	 end;
	if ord =2 and agegrp = 1  then varcat="12 to <18 years";
	if ord =2 and agegrp = 2 then varcat=">=18 years";
    if ord =2 then subord=agegrp;
	if ord=3 and sex ne "" then varcat=strip(sex);
	if ord=4 and race ne "" then varcat=strip(race);
run;
proc sort data=cat1;
 by siteid ord subord cat trt01an;
run;
proc freq data=cat1 noprint;
 by siteid ord subord cat trt01an;
 table varcat/out=cat_2(drop=percent);
 where varcat ne "";
run;

proc sort data=bign;
 by siteid trt01an;
run;
proc sort data=cat_2;
 by siteid trt01an;
run;
data cat_3;
 merge cat_2(in=a) bign(in=b rename=(count=bign));
 by siteid trt01an;
 cnt=strip(put(count,5.))||" ("||strip(put((count/bign)*100,5.1)||")");
run;
proc sort data=cat_3;
 by siteid ord subord  cat varcat;
run;
proc transpose data=cat_3 out=cat_t;
 by siteid ord subord  cat varcat;
 id trt01an;
 var cnt;
run;
data cat_f(drop=_name_ rename=(varcat=stat));
 set cat_t;
  if strip(varcat)="M" then do;
     subord=1;
	 varcat="Male";
  end;
  else if strip(varcat)="F" then do;
          subord=2;
		  varcat="Female";
  end;
run;
proc format;
 value $stat 
			 "max_"   ="Maximum                                "
             "N_"     ="n"
             "Mean_"  ="Mean"
			 "Std_"   ="SD"
			 "min_"   ="Minimum"
			 "q1_"    ="Q1"
			 "Median_"="Median"
			 "q3_"    ="Q3";
	   $site 
run;
data final;
length stat $100.;
 set cat_f mean_final;
 format stat $stat.;
run;

proc sort data=final;
 by siteid ord subord ;
run;

dm 'output;clear';
proc report data=final nowd headskip headline spacing=0 split="*" ls=134 ps=43;
  by siteid;
      column ("__" ord subord cat stat _1 _2 _99);
	   define ord/order=data noprint;
	   define subord/order=data noprint;
	   define cat/" " width=50 flow group order=data;
	   define stat/"Statistics" width=30 group order=data;
	   define _1/"Moxidectin*(8 mg)*&n1*n (%)" width=18;
	   define _2/"Ivermectin*(150 µg/kg)*&n2*n (%)" width=18;
	   define _99/" *Overall*&n3*n (%)" width=18;
  break after cat/skip;
run;





