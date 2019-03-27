/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
* PROGRAM   : ADDM.SAS
* FUNCTION  : Creates ADDM Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADDM Analysis dataset
*
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
* 
****************************************************************************/
/*%let studyid=3110A1-3000-AF;*/

/*%macro msusbjid ();*/
/* attrib usubjid $40.;*/
/* USUSBJID="&studyid.-"||subjid;*/
/*%mend;*/
%include "D:\Aspire study\macros\setup.sas";
%lib;
data demography1;
 set raw.demography;
run;
/*USUBJID BRTHDTC SEX RACE AGE*/
data dm1;
 set demography1(rename=(subjid=subjid_ sex=sex_ race=race_));
 SUBJID=put(subjid_,z6.);
 %usubj;
 if length(brthdtc)=10 then brthdte=put(input(brthdtc,ddmmyy10.),yymmdd10.);
  else if length(brthdtc)=7 then brthdte=compress(scan(brthdtc,2,'/')||'/'||scan(brthdtc,1,'/'));
   else if length(brthdtc)=4 then brthdte=compress(brthdtc);

 if sex_=1 then SEX="M";
  else if sex_=2 then SEX="F";
  
 if upcase(race_)="BLACK OR AFRICAN AMERICAN" then RACE="Black or African American";
  else if upcase(race_)="ASIAN" then RACE="Asian";
   else if upcase(race_)="WHITE" then RACE="White";
	else RACE="Other";
 DMDTC=put(date,yymmdd10.);
run;
/*RFSTDTC RFXSTDTC RFENDTC RFXENDTC*/
data trt;
 set raw.testarticle(rename=(subjid=subjid_ ));
 SUBJID=put(subjid_,z6.);
 %usubj;
  where startd not in ('NA' '') and amt ne 0;
  if length(startd)=10 then start_=put(input(startd,ddmmyy10.),yymmdd10.);
  else if length(startd)=7 then start_=compress(scan(startd,2,'/')||'/'||scan(startd,1,'/'));
  else if length(startd)=4 then start_=compress(startd);
run;
proc sort data=trt;
 by usubjid start_;
run;
data rfsdt(keep=usubjid start_
           rename=(start_=RFSTDTC))
     rfxsdt(keep=usubjid start_
            rename=(start_=RFXSTDTC))
	 rfend(keep=usubjid start_
           rename=(start_=RFENDTC))
	 rfxend(keep=usubjid start_
            rename=(start_=RFXENDTC));
 set trt;
 by usubjid start_;
  if first.usubjid then do;
     output rfsdt;
	 output rfxsdt;
  end;
  if last.usubjid then do;
     output rfend;
	 output rfxend;
  end;
run;
proc sort data=dm1;
 by usubjid;
run;
data dm2;
 merge dm1(in=a) rfsdt(in=b) rfxsdt(in=c) rfend(in=d) rfxend(in=e);
 by usubjid;
 if a ;
run;
/*RFICDTC*/
data rfic(keep= usubjid rficdtc);
 set raw.inclusioneligibility(rename=(subjid=subjid_ ));
 SUBJID=put(subjid_,z6.);
 %usubj;
 where eligibility=1;
/* where consdt ne .;*/
 if not missing(consdt) then RFICDTC=put(consdt,yymmdd10.);
 run;
/*RFPENDTC*/
data rfpend(keep=usubjid rfpendtc);
 set raw.Conclusionofparticipation(rename=(subjid=subjid_ ));
 SUBJID=put(subjid_,z6.);
 %usubj;
 where  rsntrm=1;
  if not missing(date) then RFPENDTC=put(date,yymmdd10.);
run;
/*DTHDTC DTHFL*/
data death;
 set raw.deathreport(rename=(subjid=subjid_ ));
 SUBJID=put(subjid_,z6.);
 %usubj;
 where date ne .;
    DTHDTC=put(date,yymmdd10.);
	DTHFL="Y";
keep usubjid dthdtc dthfl;
run;
/*importing randomisation list */
proc import datafile="D:\MNT New\MNT SDTM\randomisation_list.xlsx"
/*            table=randomisation_listt*/
			out=randlist
			dbms=xlsx replace;
			getnames=yes;
run;
data random;
 set randlist(rename=(group=group_));
  where not missing(da_act_trt_label) and not missing(rnd_trt_label);

  subjid_=input(da_subjid,best.);
 SUBJID=put(subjid_,z6.);
 %usubj;
 attrib ARMCD ACTARMCD format= $8.
        ARM ACTARM format= $25.
        GROUP format=$7.;
 ARM=rnd_trt;
 ARMCD=rnd_trt_label;
 ACTARM=da_act_trt;
 ACTARMCD=da_act_trt_label;
 RANDNO=rnd_randno;
 GROUP=group_;
 keep usubjid arm armcd actarm actarmcd randno GROUP;
run;

data dm3;
 merge dm2(in=a) rfic(in=b) rfpend(in=c) death(in=d) random(in=e);
 by usubjid;
  if a;
  AGEU="YEARS";
  DOMAIN="DM";
  if missing(rfstdtc) then do;
     actarm='Not Dosed';
	 actarmcd='NOTDOSED';
  end;
	 /*DMDY*/
   if input(dmdtc,yymmdd10.) ne . and input(rfstdtc,yymmdd10.) ne . then do;
  if input(dmdtc,yymmdd10.) < input(rfstdtc,yymmdd10.) then 
     DMDY=input(dmdtc,yymmdd10.)-input(rfstdtc,yymmdd10.);
  else if input(dmdtc,yymmdd10.)>= input(rfstdtc,yymmdd10.) then
       DMDY=input(dmdtc,yymmdd10.)-input(rfstdtc,yymmdd10.)+1;
  end;
  STUDYID="&studyid.";
  keep STUDYID DOMAIN USUBJID SUBJID RFSTDTC RFENDTC RFXSTDTC RFXENDTC RFICDTC RFPENDTC
       DTHDTC DTHFL SITEID INVNAM BRTHDTC AGE AGEU SEX RACE ARMCD ARM 
       ACTARMCD ACTARM COUNTRY DMDTC DMDY
;
run;
proc sort data=dm3 out=adam_.ADDM;
 by usubjid;
run;




/*data dd;*/
/* do date="26/07/1985","05/1960","1975";*/
/* output;*/
/*end;run;*/
/*data d;*/
/* set dd;*/
/*  if length(date)=10 then dt=put(input(date,ddmmyy10.),yymmdd10.);*/
/*  else if length(date)=7 then dt=compress(scan(date,2,'/')||'/'||scan(date,1,'/'));*/
/*  else if length(date)=4 then dt=compress(date);*/
/*run;*/

  
