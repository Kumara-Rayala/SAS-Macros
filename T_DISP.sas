/***************************************************************************
* COMPANY  : Aspire information technologies Ltd
* PROGRAM  : T_DISP.sas
* FUNCTION : Creates Disposition table from the analysis dataset.
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
 where RANDFL="Y";
run;

data disp1;
 set adsl;
 where trt01an ne .;
  output;
  TRT01AN=99;
  TRT01A="Overall";
  output;
run;
proc sql noprint;
 create table bign as 
 select count(distinct usubjid) as bign,trt01an,trt01a from disp1
        where randfl="Y" and trt01an ne .
        group by trt01an,trt01a;

 create table disp2 as
 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "All randomized subjects" as cat,1 as ord from disp1
        where randfl="Y" and trt01an ne .
        group by trt01an,trt01a

  outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "Subjects who received study medication" as cat,2 as ord from disp1
        where saffl="Y"
		group by trt01an,trt01a

   outer union corr
 
 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "mITT population [1]" as cat,3 as ord from disp1
        where mittfl="Y"
		group by trt01an,trt01a

   outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "e-mITT population [2]" as cat,4 as ord from disp1
        where emittfl="Y"
		group by trt01an,trt01a

 outer union corr
 
 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "PP population [3]" as cat,5 as ord from disp1
        where pprotfl="Y"
		group by trt01an,trt01a

  outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "AR-mITT population [4]" as cat,6 as ord from disp1
        where armittfl="Y"
		group by trt01an,trt01a

  outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "Subjects who completed the study [5]" as cat,7 as ord from disp1
        where COMPLTFL="Y"
		group by trt01an,trt01a

 outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,lvisit,
        "Subjects who completed the study [5]" as cat,7 as ord from disp1
        where compltfl="Y"
		group by trt01an,trt01a,lvisit

 outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,
        "Subjects who prematurely discontinued study[6]" as cat,8 as ord from disp1
		where discfl="Y"
		group by trt01an,trt01a

 outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,lvisit,
        "  Last Scheduled Visit attended [7]" as cat,9 as ord from disp1
		where trt01an ne . and lvisit ne ""
		group by trt01an,trt01a,lvisit
 
 outer union corr

 select count(distinct usubjid) as cnt,trt01an,trt01a,dsreas,
        "Reason for withdrawal" as cat,10 as ord from disp1
		where discfl="Y" and dsreas ne ""
		group by trt01an,trt01a,dsreas;
 
 create table disp3 as
 select a.*,b.bign from disp2 as a left join bign as b on a.trt01an=b.trt01an;
quit;
proc sql;
 create table disp4 as
  select a.*,b.compN from disp3 as a left join (select *,cnt as compN from disp3 
         where cat="Subjects who completed the study [5]" and lvisit="") as b 
         on a.cat=b.cat and a.trt01an=b.trt01an and a.ord=b.ord
    ;
quit;
data disp5;
 set disp4;
  if cat="Subjects who completed the study [5]" and lvisit ne "" then
     count=strip(put(cnt,best.))||" ( "||strip(put((cnt/compn)*100,6.1))||")";
  else count=strip(put(cnt,best.))||" ( "||strip(put((cnt/bign)*100,6.1))||")";
run;
proc sort data=disp5;
by ord cat lvisit dsreas;
run;
proc transpose data=disp5 out=disp5_t;
 by ord cat lvisit dsreas;
 id trt01an;
 var count;
run;
proc sort data=sdtm.tv out=tv(keep=visit visitnum) nodupkey;
 by visit;
 where visitnum <99.1;
run;
data tv;
length cat $46.;
 set tv;
 cat="  Last Scheduled Visit attended [7]";
 ord=9;
run;
proc sort data=disp5_t;
 by lvisit cat ord;
run;
data disp6;
 merge disp5_t(rename=(lvisit=visit)) tv;
  by visit cat ord;
  if cat="Subjects who completed the study [5]" and visit ="12M" then 
     cat="  Last Visit at Month 12";
  else if cat="Subjects who completed the study [5]" and visit ="18M" then 
     cat="  Last Visit at Month 18";
  if 99 > visitnum > 1 and cat="  Last Scheduled Visit attended [7]" then do;
   if substr(visit,1,1)="D" then cat="    "||substr(visit,1,1)||"ay "||substr(visit,2);
   else if substr(strip(reverse(visit)),1,1)="M" then cat="    "||substr(strip(reverse(visit)),1,1)||"onth "||compress(visit,'',"a");
  end;
  else if visitnum=1 then cat="    "||strip(visit);
  if visitnum=99 then visitnum=0;
run;
proc sort data=disp6;
 by ord visitnum;
run; 
data dup;
 length dsreas1 $50.;
 do dsreas1="Reason for withdrawal",
        "Unsatisfactory Response � Efficacy",
        "Adverse Event",
		"SUBJECT REQUEST",
		"INVESTIGATOR REQUEST",
		"DEATH",
		"Discontinuation of Study by Sponsor",
		"Protocol Violation",
		"LOST TO FOLLOW-UP",
		"Other";
output;end;
run;
data dup1;
 set dup;
 subord=_n_;
 cat="Reason for withdrawal";
 ord=10;
run;
proc sort data=dup1;
 by cat dsreas1;
run;
proc sort data=disp6;
 by cat dsreas;
run;
proc sql noprint;
create table disp7 as
 select a.*,coalesce(a.cat,b.cat) as cat1,coalesce(a.ord,b.ord)as ord1,b.subord,
        b.dsreas1 from disp6 as a full join dup1 as b 
        on a.cat=b.cat and a.dsreas=b.dsreas1;
quit;
quit;

data disp8;
 set disp7(drop=_name_);
  if dsreas ="" and dsreas1 ne "" and cat1 ne dsreas1 then 
     cat1="    "||strip(dsreas1);
   else if dsreas ne "" then cat1="    "||propcase(strip(dsreas));
  if subord=. and visitnum ne . then subord=visitnum;
  array dup (*) _:;
   do i=1 to dim(dup);
    if cat1 not in ( "  Last Scheduled Visit attended [7]" "Reason for withdrawal" ) then do;
     if dup(i)="" then dup(i)="0";
	end;
   end;
run;
proc sort data=disp8(keep=cat1 _: ord1 subord);
 by ord1 subord ;
run;
data _null_;
 set bign;
  call symput("N"||strip(put(_n_,best.)),"(N="||strip(put(bign,best.))||")");
run;
%put &n1 &n2 &n3;
dm 'output;clear';

options orientation=landscape;
ods rtf file="D:\MNT New\T_DEMOG.rtf";
proc report data=disp8 headskip headline spacing=0  nowd split="*" ls=134 ps=43;
   column ('__' ord subord cat1 _1 _2 _99);
    
     define ord/order=data noprint;
	 define subord/order=data noprint;
     define cat1 /"Statistics" width=50 flow;
	 define _1/"Moxidectin*(8 mg)*&n1*n (%)" width=28;
	 define _2/"Ivermectin*(150 �g/kg)*&n2*n (%)" width=28;
	 define _99/" *Overall*&n3*n (%)" width=28;
run;
ods rtf close;
DM OUTPUT'PRINT FILE="D:\MNT New\T_DEMOG.LST" REPLACE';
