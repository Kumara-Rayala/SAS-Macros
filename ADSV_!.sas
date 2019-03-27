/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
* PROGRAM   : ADSV_1.SAS
* FUNCTION  : Creates ADSV_1 Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADSV_1 Analysis dataset
*
*---------------------------------------------------------------------------
* Version Info.
* -------------
* 1. New program
* 
****************************************************************************/
dm'log;clear';
dm'output;clear';
%include "D:\Aspire study\macros\setup.sas";
%lib();
data sv1;
 length subjid date date1 $200. visit $400.;
  set   raw.adverseevents						(in=a1	keep=subjid siteid visit date maetext	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.bloodchemistrylocallabp1			(in=a2	keep=subjid siteid visit date 	rename=(subjid=subjid_n siteid=siteid_n))
		raw.bloodchemistrylocallabp2			(in=a3	keep=subjid siteid visit date 	rename=(subjid=subjid_n siteid=siteid_n))
		raw.bloodchemistrylocallabp3			(in=a4	keep=subjid siteid visit date 	rename=(subjid=subjid_n siteid=siteid_n))
		raw.conclusionofparticipation			(in=a5	keep=subjid siteid visit date 	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.electrocardiogram					(in=a6	keep=subjid siteid visit date 	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.exclusioneligibilityamd2p1			(in=a7	keep=subjid siteid date 		rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.hematologylocallabp1		 		(in=a8	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n))
		raw.hematologylocallabp2				(in=a9	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n))
		raw.inclusioneligibility				(in=a10	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.intestinalhelminth					(in=a12	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n))
		raw.lymphaticfilarisasis				(in=a13	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.lymphaticfileriasisbaseline			(in=a14	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.nodulepalpation						(in=a99	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.nonpharmaceuticaltherapy			(in=a15	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.nonstudymedsgeneral					(in=a16	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.occularexamination					(in=a17	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.occularexaminationp1				(in=a18	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp2				(in=a19	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp3				(in=a20	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp4				(in=a21	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp5				(in=a22	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp6				(in=a23	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp7				(in=a24	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularexaminationp8				(in=a25	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.occularmicrofilarialcount			(in=a26	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.physicalexam						(in=a27	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.physicalexaminitialp1				(in=a28	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.physicalexaminitialp2				(in=a29	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.physicalexaminitialp3				(in=a30	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.physicalexaminitialp4				(in=a31	keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=SCREENING*/
		raw.serumpregnancytestlocallab			(in=a32	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n))
		raw.skinsnipsp1							(in=a33 keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.skinsnipsp2							(in=a34 keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.skinsnipsp3							(in=a35	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n))
		raw.testarticle							(in=a36 keep=subjid siteid date			rename=(subjid=subjid_n siteid=siteid_n date=date_n))		/*VISIT=DAY 1*/
		raw.urinalysislocallabp1				(in=a37	keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.urinalysislocallabp2				(in=a38	keep=subjid siteid visit date date1		rename=(subjid=subjid_n siteid=siteid_n date=date_n date1=date1_n))
		raw.urinalysislocallabp3				(in=a39	keep=subjid siteid visit date date1		rename=(subjid=subjid_n siteid=siteid_n date=date_n date1=date1_n))
		raw.urinepregnancytestlocallab			(in=a40 keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
		raw.vitalsigns 							(in=vs1 keep=subjid siteid visit date	rename=(subjid=subjid_n siteid=siteid_n))
		raw.vitalsignsd1p1 						(in=vs2 keep=subjid siteid eventd: actt:	rename=(subjid=subjid_n siteid=siteid_n))
		raw.vitalsignsd1p2 						(in=vs3 keep=subjid siteid eventd: actt:	rename=(subjid=subjid_n siteid=siteid_n actt5=actt5_))
		raw.vitalsignsd2d14 					(in=vs4 keep=subjid siteid visit eventd: actt:	rename=(subjid=subjid_n siteid=siteid_n actt=actt_ actt1=actt1_ actt2=actt2_))
		raw.vitalsignsm1 						(in=vs5 keep=subjid siteid eventd: actt:	rename=(subjid=subjid_n siteid=siteid_n))
		raw.vitalsignsscreening 				(in=vs6 keep=subjid siteid eventd: actt:	rename=(subjid=subjid_n siteid=siteid_n))
		raw.vitalsignsunscheduled 				(in=vs7 keep=subjid siteid eventd: actt:	rename=(subjid=subjid_n siteid=siteid_n))
		raw.vitalsignswithweight 				(in=vs8 keep=subjid siteid visit date		rename=(subjid=subjid_n siteid=siteid_n date=date_n));

    if a7 or a10 or a14 or a18 or a19 or a20 or a21 or a22 or a23 or a24 or a25 or a28 or a29 or a30 or a31 then VISIT="SCREENING";
 	if a36 then visit="DAY 1";
	if vs2 then visit="DAY 1";
	if vs3 then visit="DAY 1";
	if vs5 then visit="MONTH 1";
	if vs6 then visit="SCREENING";
	if vs7 then visit="UNSCHEDULED";
    subjid=compress(put(subjid_n,z6.));
    siteid=compress(put(siteid_n,best.));
    date=compress(put(date_n,yymmdd10.),".");
    date1=compress(put(date1_n,yymmdd10.),".");
 if a1 and maetext eq "" then delete;
 drop date1_n date_n maetext;
run;
data sv2;
 set sv1;
  if compress(actt5_) not in ("" "ND") then ACTT5=input(actt5_,time5.);
  if compress(actt_) not in ("" "ND") then ACTT=input(compress(actt_),time8.);
  if compress(actt1_) not in ("" "ND") then ACTT1=input(compress(actt1_),time8.);
  if compress(actt2_) not in ("" "ND") then ACTT2=input(actt2_,time8.);
  if compress(date) = "" and compress(date1) ne  "" then date=date1;
  drop actt5_ actt_ actt1_ actt2_ date1 subjid_n siteid_n;
run;
proc sort data=sv2 out=sv3 nodup;
 by subjid siteid visit date eventd actt eventd1 actt1 eventd2 actt2 eventd3 actt3 eventd4 actt4 eventd5 actt5;
run;
proc transpose data=sv3 out=sv4(drop=col2 col3 col4);
 by subjid siteid visit date eventd:;
 var actt:;
run;
data sv5;
 set sv4;
 time=compress(put(col1,tod5.));
 if date="" and eventd ne . then date=compress(put(eventd,yymmdd10.));
  if date="" and eventd = . and eventd3 ne . then date=compress(put(eventd3,yymmdd10.));
  drop eventd: col1 _name_;
run;
proc sort data=sv5 out=sv6 nodupkey;
 by subjid siteid visit date time;
run;
data sv7;
 set sv6;
  if visit= "CONCLUSION OF PARTICIPATION" then delete;
  if date = "" then delete;
  if index(visit,"UNSCHEDULED") then visit="UNSCHEDULED";
run;
/*Creation of visit start date and end date*/
proc sort data=sv7 out=sv8 nodup;
  by subjid siteid visit date time;
run;
data sv9 stdt(rename=(date=date1 time=time1)) endt(rename=(date=date2 time=time2));
 set sv8;
 by subjid siteid visit date time;
 if first.date then output stdt;
 if last.date then output endt;
 if ^first.date and ^last.date then output sv9;
run;
proc sort data=stdt;
 by subjid siteid visit date1 time1;
run;
data stdt_;
 set stdt;
 by subjid siteid visit date1 time1;
  if first.visit;
run;
proc sort data=endt;
 by subjid siteid visit date2 time2;
run;
data endt_;
 set endt;
 by subjid siteid visit date2 time2;
  if last.visit;
run;

proc sort data=sv9;
 by subjid siteid visit date time;
run;
data sv9_1;
 set sv9;
 by subjid siteid visit date time;
  if first.visit;
run;

data sv10;
 merge sv9_1(in=a) stdt_(in=b) endt_(in=c);
 by subjid siteid visit;
 if visit ne "UNSCHEDULED";
run;
data sv11;
 set sv10;
  if date1=date and strip(time) ne "." then SVSTDTC=strip(date)||"T"||strip(time);
   else if date1 ne date and strip(time1)= "." then SVSTDTC=strip(date1);
    else if date1 ne date and strip(time1) ne "." then SVSTDTC=strip(date1)||"T"||strip(time1);
  if date2 ne "" and strip(time2) ne "." then SVENDTC=strip(date2)||"T"||strip(time2);
   else if date2 ne "" and strip(time2) eq "." then SVENDTC=strip(date2);
   drop date: time:;
run;

/*unscheduled visits*/;

data uns1;
 set sv7;
 if strip(visit) eq "UNSCHEDULED";
run;
proc sort data=uns1 out=uns2 nodup;
 by subjid siteid visit date time;
run;
data uns3 un;
 set uns2;
 if time ne "." then output un;
  else output uns3;
run;
proc sort data=uns3;
 by subjid siteid visit date;
 run;
proc sort data=un;
 by subjid siteid visit date;
 run;
data uns4;
 merge uns3(drop=time) un;
 by subjid siteid visit date ;
run;
proc sort data=uns4 out=uns5 nodup;
 by subjid siteid visit date;
run;
data uns6;
 set uns5;
 by subjid siteid visit date;
  if first.visit then num=0;
  num+1;
run;
data uns7;
 set uns6(rename=(visit=visit_));
 VISIT=strip(visit_)||" "||strip(put(num,best.));
 if time ne "" and date ne "" then date_=strip(date)||"T"||strip(time);
  else if date ne "" and time ="" then date_=date;
  drop visit_ num date time;
 run;
proc sort data=uns7;
 by subjid siteid visit date_;
run;
data unstdt unendt;
 set uns7;
 by subjid siteid visit date_;
  if first.visit then output unstdt;
  if last.visit then output unendt;
run;
data uns8;
 merge unstdt(rename=(date_=SVSTDTC)) unendt(rename=(date_=SVENDTC));
 by subjid siteid visit ;
run;
/*Adding unschedule vists the main dataset */
data sv12;
 set uns8(rename=(visit=visit_)) sv11 (rename=(visit=visit_));
  if index(visit_,"DAY") then VISIT=strip(substr(visit_,1,1))||strip(substr(visit_,5));
   else if index(visit_,"MONTH") then VISIT=strip(scan(visit_,2,""))||strip(substr(visit_,1,1));
    else VISIT=propcase(visit_);
	%usubj();
run;
proc sort data=sdtm_.dm out=dm(keep=usubjid rfstdtc);
 by usubjid;
run;
proc sort data=sv12;
 by usubjid;
run;
proc sort data=sdtm.tv out=tv(keep=visit visitnum visitdy) nodupkey;
 by visit visitnum;
run;
data sv13;
 merge sv12(in=a) dm(in=b);
 by usubjid;
 if a;
 if svstdtc ne "" and rfstdtc ne "" then do;
   if input(svstdtc,yymmdd10.) >= input(rfstdtc,yymmdd10.) then SVSTDY=(input(svstdtc,yymmdd10.) - input(rfstdtc,yymmdd10.))+1;
    else if input(svstdtc,yymmdd10.) < input(rfstdtc,yymmdd10.) then SVSTDY=input(svstdtc,yymmdd10.) - input(rfstdtc,yymmdd10.);
 end;
  if svendtc ne "" and rfstdtc ne "" then do;
   if input(svendtc,yymmdd10.) >= input(rfstdtc,yymmdd10.) then SVENDY=(input(svendtc,yymmdd10.) - input(rfstdtc,yymmdd10.))+1;
    else if input(svendtc,yymmdd10.) < input(rfstdtc,yymmdd10.) then SVENDY=input(svendtc,yymmdd10.) - input(rfstdtc,yymmdd10.);
 end;

 drop subjid siteid visit_;
run;
proc sort data=sv13;
 by visit;
run;
data sv14;
 merge sv13(in=a) tv(in=b);
 by visit;
 if a;
run;
 data SV_f;
 length EPOCH $100.;
   set sv14;
    if visitnum=1 then EPOCH="SCREENING";
	 else if 2<= visitnum <=8 then EPOCH="EARLY FOLLOW-UP";
	 else if 9<= visitnum <=12 then EPOCH="LONGTERM FOLLOW-UP";
	 else if visitnum=99 then EPOCH="";
 STUDYID="&STUDYID";
 DOMAIN="SV";
run;
proc sort data=sv_f;
 by usubjid visitnum visit;
run;

%spec(DOMAIN=SV);









  



 












  


