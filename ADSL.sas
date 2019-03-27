/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
* PROGRAM   : ADSL.SAS
* FUNCTION  : Creates ADSL Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADSL Analysis dataset
*
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
* 
****************************************************************************/
dm'log;clear';
%include "D:\Aspire study\macros\setup.sas";
%lib();
proc sort data=sdtm.dm out=dm;
 by usubjid;
run;
data adsl1;
 set dm;
 SITEN=input(siteid,best.);
 if length(brthdtc)=7 then BRTHDTC1=strip(brthdtc)||"-01";
  else if length(brthdtc)=4 then BRTHDTC1=strip(brthdtc)||"-01-01";
   else if length(brthdtc)=10 then BRTHDTC1=strip(brthdtc);
run;

data rand(keep=usubjid randdt) comp(keep=usubjid compdt);
 set sdtm.ds;
  if upcase(strip(dsterm))="RANDOMIZATION" then do;
      RANDDT=DSSTDTC;
  output rand;
  end;
  if upcase(strip(dsterm))="STUDY COMPLETED" then do;
      COMPDT=DSSTDTC;
  output comp;
  end;
run;
proc sort data=work.rand out=randt nodupkey dupout=randp;
 by usubjid;
run;
proc sort data=work.comp out=compt nodupkey dupout=compp;
 by usubjid;
run;

data adsl2;
 merge adsl1(in=a) randt(in=b) compt(in=c);
  by usubjid;
   if rfxstdtc ="" and randdt ne "" then rfxstdtc1=randdt;
   else rfxstdtc1=rfxstdtc;

   if rfxstdtc1 ne "" and brthdtc1 ne "" then 
     AAGE=int((input(RFXSTDTC1,is8601da.)-input(BRTHDTC1,is8601da.))/365.25);

   if aage < 18 then AGEGRP=1;
   else if aage >=18 then AGEGRP=2;

   if length(rfxstdtc)=10 then SAFFL="Y";
   else SAFFL="N";

   if length(rfxstdtc)=10 then MITTFL="Y";
   else MITTFL="N";
  
run;
/*EMITTFL CREATION*/
proc sort data=sdtm.ex out=ex nodupkey;
 by usubjid exstdtc;
run;
proc sort data=sdtm.zs out=zs;
 by usubjid;
 where zstestcd ="OVLVC" and visit in ("Screening" "1M" "6M" "12M" "18M");
run;
data zs_ex;
 merge zs(in=a) ex(in=b);
  by usubjid;
  if a ;
  if exstdtc ne "" and zsdtc ne "" then do;
   if input(zsdtc,is8601da.)< input(exstdtc,is8601da.) then
      STDY=input(zsdtc,is8601da.)- input(exstdtc,is8601da.);
   else if input(zsdtc,is8601da.)>= input(exstdtc,is8601da.) then
           STDY=(input(zsdtc,is8601da.)- input(exstdtc,is8601da.))+1;
  end;

  if (visit="Screening" and stdy < 1) or
     (visit="1M" and 45 >= stdy >=22) or
     (visit="6M" and 270 >= stdy >=136) or
     (visit="12M" and 450 >= stdy >=271) or
     (visit="18M" and stdy >450) then var="Y";
run;
proc sort data=zs_ex;
 by usubjid visit;
 where var="Y";
run;

data zs_ex1;
 set zs_ex;
 by usubjid visit;
  if first.visit;
run;

proc transpose data=zs_ex1 out=zs_ex2;
 by usubjid;
 id visit;
 var var;
run;

data zs_ex3;
 merge zs_ex2(in=a) adsl2(keep=usubjid saffl in=b);
  by usubjid;
  if saffl="Y" and screening="Y" and _12m="Y" then EMITTFL="Y";
   else EMITTFL="N";
run;
/*End*/
/*Creation of SMDLVLBL SMDLVLBLN INFINTBL INFINTBLN*/
/*creation of MICROFILARIAE count*/
proc sort data=sdtm.zs out=smzs(keep=usubjid visitnum visit zstest zsorres zsloc zsdy);
 by usubjid visitnum zstest zsloc;
 where zsorresu ="MICROFILARIAE" and zsdy < 1;
run;
data smzs1;
 set smzs;
 by usubjid visitnum zstest zsloc;
 if last.zsloc;
run;

proc sort data=smzs1;
 by usubjid visitnum zsloc;
 run;

 data smzs2;
   set smzs1;
   by usubjid visitnum zsloc;
   if last.zsloc;
   zsmf=input(zsorres,best.);
 run;
/*creation of skinsnip weight (mg)*/
 proc sort data=sdtm.zs out=swzs(keep=usubjid visitnum visit zstest zsorres zsloc zsdy);
  by usubjid visit zsloc;
  where strip(upcase(zsorresu))="MG" and zsdy < 1;
run;
 data swzs1;
  set swzs;
   by usubjid visit zsloc;
    if last.zsloc;
	zsmg=input(zsorres,best.);
run;

/*creation of mf/mg*/
 proc sort data=smzs2;
  by usubjid visitnum zsloc;
run;
 proc sort data=swzs1;
  by usubjid visitnum zsloc;
run;
data smsw;
 merge smzs2 swzs1;
  by usubjid visitnum zsloc;
  smw=zsmf/zsmg;
run;
/*Final creation of the  SMDLVLBL SMDLVLBLN INFINTBL INFINTBLN variables*/
proc sql;
 create table smsw1 as
  select usubjid,mean(smw) as meansmw from smsw group by usubjid;
quit;
proc sort data=smsw1 out=smsw2 nodupkey;
 by usubjid;
run;

data smsw3;
length SMDLVLBL INFINTBL $80.;
 set smsw2;

/*creation of SMDLVLBLN SMDLVLBL*/
  if meansmw < 20 then SMDLVLBLN=1;
   else if meansmw >=20 then SMDLVLBLN=2;
  if SMDLVLBLN=1 then SMDLVLBL="<20 mf/mg";
   else if SMDLVLBLN=2 then SMDLVLBL=">=20 mf/mg";

/*Creation of INFINTBL INFINTBLN */
  if meansmw < 20 then INFINTBLN=1;
   else if 50 > meansmw >= 20 then INFINTBLN=2;
   else if 80 > meansmw >= 50 then INFINTBLN=3;
   else if meansmw >=80 then INFINTBLN=4;

  if INFINTBLN=1 then INFINTBL="<20 mf/mg";
   else if INFINTBLN=2 then INFINTBL=">=20 mf/mg to <50 mf/mg";
   else if INFINTBLN=3 then INFINTBL=">=50 mf/mg to <80 mf/mg";
   else if INFINTBLN=4 then INFINTBL=">=80 mf/mg";
run;

/*merging of EMITTFL SMDLVLBL SMDLVLBLN INFINTBL INFINTBLN to main dataset*/
proc sort data=adsl2;
 by usubjid;
run;
proc sort data=zs_ex3;
 by usubjid;
run;
proc sort data=smsw3;
 by usubjid;
run;

data adsl3;
 length TRT01P TRT01A $80.;
 merge adsl2(in=a drop=randdt) zs_ex3(keep=usubjid emittfl in=b) smsw3(keep=usubjid SMDLVLBL SMDLVLBLN INFINTBL INFINTBLN in=c);
 by usubjid;
 if a;
 ARMITTFL=MITTFL;
 if COMPDT ne "" then COMPLTFL="Y"; 
  else COMPLTFL="Y";
 SCRNFL="Y";
 if strip(ARMCD)="A" then TRT01P="Moxidectin# (8 mg)";
  else if strip(ARMCD)="B" then TRT01P="Ivermectin#(150 µg/kg)";
 if strip(ARMCD)="A" then TRT01PN=1;
  else if strip(ARMCD)="B" then TRT01PN=2;

 if strip(ACTARMCD)="A" then TRT01A="Moxidectin# (8 mg)";
  else if strip(ACTARMCD)="B" then TRT01A="Ivermectin#(150 µg/kg)";
 if strip(ACTARMCD)="A" then TRT01AN=1;
  else if strip(ACTARMCD)="B" then TRT01AN=2;

 RFSTDT=input(rfstdtc,yymmdd10.);
 RFPENDT=input(rfpendtc,yymmdd10.);
 if rfstdt ne . and rfpendt ne . then STDDUR=(rfpendt-rfstdt)+1;
 TRTSDT=input(rfxstdtc,yymmdd10.);
 TRTEDT=input(rfxendtc,yymmdd10.);
 if trtsdt ne . and trtedt ne . then TRTDUR=(trtedt-trtsdt)+1;
 ICDT=input(RFICDTC,yymmdd10.);
 format rfstdt rfpendt trtsdt trtedt icdt yymmdd10.;
run;
/*Blind broken,randomised variables creation*/
proc sort data=sdtm.suppds out=supds;
 by studyid rdomain usubjid idvarval;
run;
proc sort data=sdtm.suppdm out=supdm;
 by studyid rdomain usubjid;
run;
proc transpose data=supdm out=dmm;
 by studyid rdomain usubjid;
 id qlabel;
 var qval;
run;
proc transpose data=supds out=dss;
 by studyid rdomain usubjid idvarval;
 id qnam;
 var qval;
run;

proc sort data=dss(keep=usubjid cbrkyn rsntmx);
by usubjid;
run;
proc sort data=dmm(drop=studyid rdomain _name_ _label_);
by usubjid;
run;
data adsl4;
 merge adsl3(in=a) dss(in=b) dmm(in=c);
 by usubjid;
 if CBRKYN="YES" then BLNDFL="Y";
  else if CBRKYN="NO" then BLNDFL="N";
 if length(Randomization_date)=10 then do;
    RANDDT=input(Randomization_date,yymmdd10.);
	format randdt date9.;
 end;
 if Randomization_number ne "" then RANDNB=input(Randomization_number,best.);
run;
proc sort data=sdtm.ds out=ds;
 by usubjid;
run;
data disc dscd;
 set ds;
  if dscat="DISPOSITION EVENT" and dsdecod="NOT COMPLETED" then do; 
   if dsdecod="NOT COMPLETED" then DISCFL="Y";
    else if dsdecod="COMPLETED" then DISCFL="N";
   DSREAS=dsterm;
   output disc;
  end;
  if dscat="DISPOSITION EVENT" and (dsdecod ="NOT COMPLETED" or dsdecod ="COMPLETED") then do;
     DSDT=input(dsstdtc,yymmdd10.);
	 format dsdt date9.;
   output dscd;
  end;
run;

proc sort data=disc(keep=usubjid discfl dsreas ); by usubjid;run;
proc sort data=dscd(keep=usubjid dsdt); by usubjid;run;
proc sort data=adsl4; by usubjid;run;

/*proc sql;*/
/*create table adsl5 as*/
/* select COALESCE(a.usubjid,b.usubjid,c.usubjid) as usubjid1,a.*,b.*,c.* from adsl4 as a left join disc as b on a.usubjid=b.usubjid*/
/*                                    left join dscd as c on a.usubjid=c.usubjid;*/
/*quit;*/

data adsl5;
 merge adsl4(in=a) disc(in=b) dscd(in=c);
 by usubjid;
 if a;
 if length(strip(brthdtc))=10 then BRTHDTD=put(input(brthdtc,yymmdd10.),date9.);
  else if length(strip(brthdtc))=7 then do;
          BRTHDTD1="01-"||strip(brthdtc);
		  BRTHDTD=substr(put(input(brthdtc,yymmdd10.),date9.),3);
  end;
  else if length(strip(brthdtc))=4 then BRTHDTD=strip(brthdtc);
  drop BRTHDTD1;
run;

/*per protocol population*/







  
 



 


