/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
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
DM 'LOG;CLEAR';
DM 'OUTPUT;CLEAR';
proc datasets lib=work kill;
quit;
%include "D:\Aspire study\macros\setup.sas";
%lib;
proc import datafile="D:\MNT15001\MNT15001\Data\External Data\Coding\MNT15001_AE_Final_20160712_1551.xls"
            out=sheet1
			dbms=xls replace;
run;
data ae1;
 set sheet1(rename=(num=num_ llt_c=llt_c_ pt_c=pt_c_ hlt_c=hlt_c_ hlgt_c=hlgt_c_
                    soc_c=soc_c_));
 LLT_C=input(llt_c_,best.);
 PT_C=input(pt_c_,best.);
 HLT_C=input(hlt_c_,best.);
 HLGT_C=input(hlgt_c_,best.);
 SOC_C=input(soc_c_,best.);
 NUM=input(num_,best.);
 drop llt_c_ pt_c_ hlt_c_ hlgt_c_ soc_c_ num_;
run;
data adverse;
 set raw.adverseevents(rename=(subjid=subjid_));
 SUBJID=put(subjid_,z6.);
 where maetext ne "" and label_md ne "PAGE DELETED";
   if strip(upcase(startd_vc))="MO" and length(startd)=10 and substr(startd,1,3)='01/'
     then do;
	 put startd= startd_vc=;
	 startd=substr(startd,4);
   end;
   if strip(upcase(stopd_vc))="MO" and length(stopd)=10 and substr(stopd,1,3)='01/'
     then do;
	 put stopd= stopd_vc=;
	 stopd=substr(stopd,4);
   end;
   if strip(upcase(startd_vc))="YR" and length(startd)=10 and substr(startd,1,6)='01/01/'
     then do;
	 put startd= startd_vc=;
	 startd=substr(startd,7);
   end;
    if strip(upcase(stopd_vc))="YR" and length(stopd)=10 and substr(stopd,1,6)='01/01/'
     then do;
	 put stopd= stopd_vc=;
	 stopd=substr(stopd,7);
   end;
run;
proc sort data= ae1;
 by subjid maetext visit num;
run;
proc sort data=adverse;
 by subjid maetext visit num;
run;
data ae2;
 length SUBJID $12. LLT_T $66.;
 merge adverse(in=a) ae1(in=b);
 by subjid maetext visit num;
run;
proc import datafile="D:\MNT15001\MNT15001\Data\External Data\Ocular grading\Copy of Ocular grading_Site3_JLarbelee corr.xlsx"
            out=ocular
			dbms=xlsx replace;
run;
proc transpose data=ocular out=ocular1(drop=_name_ _label_);
  var _all_;  
run;
proc transpose data=ocular1 out=ocular2(drop=_name_);
 id col1;
 var _all_;
run;
data ocular3;
 set ocular2(rename=(verbatim=MAETEXT start_date=startd stop_date=stopd));
  if _n_ > 1;
  subjid1=input(patient,best.);
  if startd="K" then startd="NK"; 
run;
proc sort data=ocular3;
 by subjid1 maetext startd;
run;
 proc sort data=ae2;
 by subjid1 maetext startd;
run;
data ae3;
length STARTD $65. STOPD $65.;
 merge ae2(in=a) ocular3(in=b);
  by subjid1 maetext startd;
run;
data ae4;
 set ae3;
 STUDYID="&studyid";
 DOMAIN="AE";
 AESPID=strip(put(num,best.));
 AETERM=strip(maetext);
 AELLT=strip(llt_t);
 AELLTCD=llt_c;
 AEDECOD=strip(pt_t);
 AEPTCD=pt_c;
 AEHLT=strip(hlt_t);
 AEHLTCD=hlt_c;
 AEHLGT=strip(hlgt_t);
 AEHLGTCD=hlgt_c;
 AECAT="ADVERSE EVENTS";
 AESCAT=strip(LBLSTYP);
 AEBODSYS=strip(soc_t);
 AEBDSYCD=soc_c;
 AESOC=strip(soc_t);
 AESOCCD=soc_c;
 if strip(upcase(FSAEYN))="YES" then AESER="Y";
  else AESER="N";

 if upcase(strip(WTHDW))="YES" then AEACN="DRUG WITHDRAWN";

 if strip(upcase(oth))="YES" then AEACNOTH="Y";
  else if strip(upcase(oth))="NO" then AEACNOTH="N";

 if strip(upcase(RELATS))="NO" then AEREL="NOT RELATED";
  else if strip(upcase(RELATS))="YES" then AEREL="RELATED";

 if OUTCOM=2 then AEOUT="PERSISTED";
  else if OUTCOM=1 then AEOUT="RESOLVED";
   else if OUTCOM=3 then AEOUT="DEATH";

 if OUTCOM=3 then AESDTH="Y";
  else AESDTH="N";

 if upcase(strip(HOSP))="YES" then AESHOSP="Y";
  else if upcase(strip(HOSP))="NO" then AESHOSP="N";

 if upcase(strip(contt))="YES" then AECONTRT="Y";
  else if upcase(strip(contt))="NO" then AECONTRT="N";

 if not missing(toxgr) then AETOXGR="Grade"||strip(put(toxgr,best.));

 if not missing(startd) and anydigit(startd) >0 then do;
     if count(upcase(startd),"NK")=2 then AESTDT=substr(startd,7);
       else if substr(upcase(startd),1,2) in("NK" "UK") then AESTDT=substr(startd,4);
       else AESTDT=startd;
     if length(aestdt)=10 then AESTDTC=put(input(aestdt,anydtdte10.),is8601da.);
	  else if length(aestdt)=7 then AESTDTC=compress(substr(aestdt,4)||"-"||substr(aestdt,1,2));
	   else AESTDTC=AESTDT;
	end;
 if not missing(stopd) and anydigit(stopd) >0 then do;
     if count(upcase(stopd),"NK")=2 then AEENDT=substr(stopd,7);
       else if substr(upcase(stopd),1,2) in("NK" "UK") then AEENDT=substr(stopd,4);
       else AEENDT=stopd;
     if length(aeendt)=10 then AEENDTC=put(input(aeendt,anydtdte10.),is8601da.);
	  else if length(aeendt)=7 then AEENDTC=compress(substr(aeendt,4)||"-"||substr(aeendt,1,2));
	  else AEENDTC=AEENDT; 
  end;

run;
proc sort data=sdtm_.dm out=rfstendt(keep=subjid rfstdtc rfendtc);
 by subjid;
run;
proc sort data=ae4;
 by subjid;
run;
data ae5;
  merge ae4(in=a) rfstendt(in=b);
  by subjid;
  if a;
run;
data ae6;
 set ae5;
 %usubj;
 visitdate=put(date,is8601da.);
  if not missing(aestdtc) and length(aestdtc)=10 and not missing(rfstdtc) then do;
    if input(aestdtc,is8601da.) >= input(rfstdtc,is8601da.) then 
       AESTDY=(input(aestdtc,is8601da.)-input(rfstdtc,is8601da.))+1;
	else if input(aestdtc,is8601da.) < input(rfstdtc,is8601da.) then 
       AESTDY=input(aestdtc,is8601da.)-input(rfstdtc,is8601da.);
  end;
  if not missing(aeendtc) and length(aeendtc)=10 and not missing(rfstdtc) then do;
    if input(aeendtc,is8601da.) >= input(rfstdtc,is8601da.) then
	   AEENDY=(input(aeendtc,is8601da.)-input(rfstdtc,is8601da.))+1;
    else if input(aeendtc,is8601da.) < input(rfstdtc,is8601da.) then
	   AEENDY=input(aeendtc,is8601da.)-input(rfstdtc,is8601da.);
  end;
  if length(visitdate)=10 and not missing(rfstdtc) then do;
    if input(visitdate,is8601da.) >= input(rfstdtc,is8601da.) then
	   VISITDY=(input(visitdate,is8601da.) - input(rfstdtc,is8601da.))+1;
    if input(visitdate,is8601da.) < input(rfstdtc,is8601da.) then
	   VISITDY=input(visitdate,is8601da.) - input(rfstdtc,is8601da.);
  end;

  if length(aeendtc)=10 and not missing(rfstdtc) then do;
   if input(aeendtc,is8601da.) < input(rfstdtc,is8601da.) then AEENRF="BEFORE";
  end;
  if length(aeendtc)=10 and not missing(rfstdtc) and not missing(rfendtc) then do;
   if input(rfstdtc,is8601da.) <= input(aeendtc,is8601da.) <= input(rfendtc,is8601da.)
         then AEENRF="DURING";
  end;
  if length(aeendtc)=10 and not missing(rfendtc) then do;
   if input(aeendtc,is8601da.)>input(rfendtc,is8601da.) then AEENRF="AFTER";
  end;
  if outcom=2 then AEENRF="AFTER";

  if scan(visit,1) in ("DAY" "MONTH") then do;
   if scan(visit,1)="DAY" then visit_=compress(substr(scan(visit,1),1,1)||scan(visit,2));
   if scan(visit,1)="MONTH" then visit_=compress(scan(visit,2)|| substr(scan(visit,1),1,1));
  end;
  else if scan(upcase(visit),1)= "UNSCHEDULED" then do;
   if anydigit(visit)=0 then visit_=scan(propcase(visit),1)||" 1";
   if anydigit(visit)>0 then visit_=scan(propcase(visit),1)||" "||scan(visit,-1);
  end;
    else do visit_=propcase(visit);
	end;
  
	if not missing(aestdtc) and missing(aeendtc) then AEONGO="ONGOING";
	 else AEONGO="";

	if aestdy ge 1 then AETRTEM="Y";

	if not missing(Corrected_grading_15_09_2014) then 
       OTOXGR=Corrected_grading_15_09_2014;
	
run;
proc sort data=ae6;
 by usubjid aedecod aestdtc aeendtc;
run;
data ae7;
 set ae6;
 by usubjid aedecod aestdtc aeendtc;
 if first.usubjid then AESEQ=0 ;
  AESEQ+1;
run;
proc sort data=ae7;
 by usubjid aedecod aestdtc aeendtc;
run;
data ae8;
 set ae7(drop=visit);
  VISIT=VISIT_;
  VISITNUM=VISIT1;
  attrib
STUDYID label= 'Study Identifier'
DOMAIN label="Domain Abbreviation"
USUBJID label="Unique Subject Identifier"
AESEQ label="Sequence Number"
AESPID label="Sponsor-Defined Identifier"
AETERM label="Reported Term for the Adverse Event"
AELLT label="low level Term"
AELLTCD label="Low level Term Code"
AEDECOD label="Dictionary-Derived Term"
AEPTCD label="Preferred Term Code"
AEHLT label="High Level Term"
AEHLTCD label="High Level Term Code"
AEHLGT label="High Level Group Term"
AEHLGTCD label="High Level Group Term Code"
AECAT label="Category for Adverse Event"
AESCAT label="Subcategory for Adverse Event"
AEBODSYS label="Body System or Organ Class"
AEBDSYCD label="Body System or Organ Class Code"
AESOC label="Primary System Organ Class"
AESOCCD label="Primary System Organ Class Code"
AESER label="Serious Event"
AEACN label="Action Taken with Study Treatment"
AEACNOTH label="Other Action Taken"
AEREL label="Causality"
AEOUT label="Outcome of Adverse Event"
AESDTH label="Results in Death"
AESHOSP label="Requires or Prolongs Hospitalization"
AECONTRT label="Concomitant or Additional Trtmnt Given"
AETOXGR label="Standard Toxicity Grade"
VISIT label="Visit Name"
VISITNUM label="Visit Number"
VISITDY label="Visit Day"
AESTDTC label="Start Date/Time of Adverse Even"
AEENDTC label="End Date/Time of Adverse Event"
AESTDY label="Study Day of Start of Adverse Event"
AEENDY label="Study Day of End of Adverse Event"
AEENRF label="End Relative to Reference Period";   
run;
/*AE SUPP*/
 data suppae1;
  attrib
   STUDYID 	label="Study Identifier"	        Length=$15
   RDOMAIN 	label="Related Domain Abbreviation" Length=$2
   USUBJID	label="Unique Subject Identifier"   Length=$40
   IDVAR	label="Identifying Variable"        Length=$10
   IDVARVAL	label="Identifying Variable Value"  Length=$40
   QNAM		label="Qualifier Variable Name"     Length=$10
   QLABEL	label="Qualifier Variable Label"    Length=$40
   QVAL		label="Data Value"                  Length=$200
   QORIG	label="Origin"                      Length=$40
   QEVAL	label="Evaluator"                   Length=$200;
  set ae7;
   RDOMAIN=DOMAIN;
   IDVAR="AESEQ";
   IDVARVAL=strip(put(AESEQ,best.));
   QORIG="CRF";
   QEVAL="";
  if otoxgr ne "" then do;
   QNAM="OTOXGR";
   QVAL=strip(otoxgr);
   QLABEL="Corrected Grading";
   output;
  end;
  if aeongo ne "" then do;
   QNAM="AEONGO";
   QVAL=strip(aeongo);
   QLABEL="Adverse Event Ongoing";
   output;
  end;
  if aetrtem ne "" then do;
   QNAM="AETRTEM";
   QVAL=strip(aetrtem);
   QLABEL="Treatement Emergent AE";
   output;
  end;
  keep STUDYID RDOMAIN USUBJID IDVAR IDVARVAL QNAM QVAL QLABEL QORIG QEVAL;
run;
%let var=%str( STUDYID DOMAIN USUBJID AESEQ AESPID AETERM AELLT AELLTCD AEDECOD AEPTCD AEHLT 
     AEHLTCD AEHLGT AEHLGTCD AECAT AESCAT AEBODSYS AEBDSYCD AESOC AESOCCD AESER AEACN
     AEACNOTH AEREL AEOUT AESDTH AESHOSP AECONTRT AETOXGR VISIT VISITNUM VISITDY 
     AESTDTC AEENDTC AESTDY AEENDY AEENRF);
proc sort data=ae8 out=ADAM_.ADAE(label="Adverse Events - AE" keep=&var);
 by studyid usubjid aeterm aestdtc;
run;
proc sort data=suppae1 out=sdtm_.Suppae(label="Supplemental Qualifiers - AE");
 by STUDYID RDOMAIN USUBJID IDVAR IDVARVAL QNAM;
run;

dm log 'print file="D:\MNT New\MNT SDTM\AE.log" replace';
      

 



 


 







