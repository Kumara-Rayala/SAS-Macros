/****************************************************************************
* COMPANY   : Aspire Information Technologies Ltd
* PROGRAM   : ADSV.SAS
* FUNCTION  : Creates ADSV Analysis Dataset dataset
* AUTHOR    : Kumara Rayala
* OUTPUT    : ADSV Analysis dataset
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
  length subjid date $200. visit $400.;
	set raw.adverseevents						(in=a1	keep=subjid siteid visit date maetext	rename=(subjid=subjid_n siteid=siteid_n date=date_n))
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
   
	Subjid=put(subjid_n,z6.);
    format subjid $200. visit $400.;
	if a7 or a10 or a14 or a18 or a19 or a20 or a21 or a22 or a23 or a24 or a25 or a28 or a29 or a30 or a31 then visit="SCREENING";
	if a36 then visit="DAY 1";
	if vs2 then visit="DAY 1";
	if vs3 then visit="DAY 1";
	if vs5 then visit="MONTH 1";
	if vs6 then visit="SCREENING";
	if vs7 then visit="UNSCHEDULED";

	%usubj();
	date=put(date_n,is8601da.);
	date1=put(date1_n,is8601da.);
	if a1 then dset="AE";
	if a1 and maetext = "" then delete;
	if compress(actt5_) ne "ND" then ACTT5=input(compress(actt5_),time5.);
	if compress(actt_) ne "ND" then ACTT=input(compress(actt_),time5.);
	if compress(actt1_) ne "ND" then ACTT1=input(compress(actt1_),time5.);
	if compress(actt2_) ne "ND" then ACTT2=input(compress(actt2_),time5.);
	drop maetext;
run;

data sv2;
 set sv1;
  if compress(date) in("" ".") and compress(date1) not in ("" ".") then date=date1;
  if visit ne "";
   drop actt_ actt1_ actt2_ actt5_ date1 date_n date1_n;
run;

proc sort data=sv2 out=sv3 nodupkey;
 by usubjid visit date eventd actt eventd1 actt1 eventd2 actt2 eventd3 actt3 eventd4 actt4 eventd5 actt5;
run;

proc transpose data=sv3 out=sv4;
 by usubjid visit date eventd:;
 var actt:;
run;
 
data sv5;
 set sv4;
  if compress(date) in ("" ".") and eventd ne . then date=compress(put(eventd,is8601da.));
   else if compress(date) in ("" ".") and eventd =. and eventd3 ne . then
                                                     date=compress(put(eventd3,is8601da.));
   if col1 ne . then time=put(col1,tod5.);
   
   if time = "" and compress(date) not in ("",".") then time="xxx";
   
   if time ="xxx" then spc="1";
    else spc="2";
 drop col1 event:;
run;






