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
 dm'log;clear';
 dm'output;clear';
%include "D:\Aspire study\macros\setup.sas";
 %lib;
 proc sql noprint;
  select count(*) into :blab1 from raw.Bloodchemistrylocallabp1;
  select count(*) into :blab2 from raw.Bloodchemistrylocallabp2;
  select count(*) into :blab3 from raw.Bloodchemistrylocallabp3;
quit;
%put &blab1;
%put &blab2;
%put &blab3;

proc sort data=raw.Bloodchemistrylocallabp1 out=Bloodlab1; by subjid visit; run;
proc sort data=raw.Bloodchemistrylocallabp2 out=Bloodlab2; by subjid visit; run;
proc sort data=raw.Bloodchemistrylocallabp3 out=bloodlab3; by subjid visit; run;

data Bloodchemlab;
 merge Bloodlab1 Bloodlab2 Bloodlab3;
 by subjid visit;
run;

proc sql noprint;
 select count(*) into :hlab1 from raw.Hematologylocallabp1;
 select count(*) into :hlab2 from raw.Hematologylocallabp2;
quit;
%put &hlab1;
%put &hlab2;

proc sort data=raw.Hematologylocallabp1 out=Hemalab1; by subjid visit; run;
proc sort data=raw.Hematologylocallabp2 out=Hemalab2; by subjid visit; run;

data Hematolab;
 merge hemalab1 hemalab2;
 by subjid visit;
run;

proc sql noprint;
 select count(*) into :urilab1 from raw.Urinalysislocallabp1;
 select count(*) into :urilab2 from raw.Urinalysislocallabp2;
 select count(*) into :urilab3 from raw.Urinalysislocallabp3;
quit;

%put &urilab1;
%put &urilab2;
%put &urilab3;

proc sort data=raw.Urinalysislocallabp1 out=urinlab1; by subjid visit;run;
proc sort data=raw.Urinalysislocallabp2 out=urinlab2; by subjid visit;run;
proc sort data=raw.Urinalysislocallabp3 out=urinlab3; by subjid visit;run;

data urinlab;
 merge urinlab1 urinlab2 urinlab3;
 by subjid visit;
run;

proc sort data=raw.Urinepregnancytestlocallab out=uripreg;
by subjid visit;
run;
/*Blood Chemistry */
data Bloodchem;
length LBORRES LBSTRESC date LBNAM LBPROTH $50. LBCOMM $200.;
 set Bloodchemlab(rename=(subjid=subjid_ siteid=siteid2));
  subjid=put(subjid_,z6.);
  %usubj();
 LBNAM=strip(lbproth);
 LBNAMOTH=strip(lbsite);
/* if strip(date) ne " " and length(strip(date))=10 then date1=input(date,ddmmyy10.);*/
/*  format date ddmmyy10.;*/
  length LBTEST $200.;
  if strip(fstatus) ="YES" then LBFAST="Y";
   else if strip(fstatus)="NO" then LBFAST="N";
    else if strip(fstatus) ne "" then put "ALE""RT:Fasting Status Not Coded." usubjid= fstatus=;

array resultsc {*} LVA_SO LVAL_PO LVAL_CL LVAL_GL LVAL_BUN LVA_U LVA_C LVA_PT LVA_A 
                   LVA_B LVA_AP LVA_LDH LVA_GGT LVA_AST LVA_ALT;
array resultsn {*} LVA_SO_NUM LVAL_PO_NUM LVAL_CL_NUM LVAL_GL_NUM LVAL_BUN_NUM 
                   LVA_U_NUM LVA_C_NUM LVA_PT_NUM LVA_A_NUM LVA_B_NUM LVA_AP_NUM
                   LVA_LDH_NUM LVA_GGT_NUM LVA_AST_NUM LVA_ALT_NUM;
array comm     {*} COMMX COMMX_PO COMMX_CL COMMX_GL COMMX_BUN COMMX_U COMMX_C 
	               COMMX_PT COMMX_A COMMX_B COMMX_AP COMMX_LDH COMMX_GGT COMMX_AST 
                   COMMX_ALT;
array test     {15} $200 _temporary_ ("Sodium" "Potassium" "Chloride" "Glucose" 
                   "Blood Urea Nitrogen" "Urea" "Creatinine" "Protein_Total" "Albumin"
                   "Bilirubin_Total" "Alkaline Phosphatase" "LDH" "Gamma Glutamyl Transferase"
                   "SGOT_AST" "SGPT_ALT");
 do i=1 to dim(resultsc);
     LBSTRESN=.;
  if resultsc(i) ne "" then do;
     LBORRES=strip(resultsc(i));
	 LBSTRESC=strip(resultsc(i));
	 LBSTRESN=resultsn(i);
	 LBTEST=strip(test(i));
	 LBCOMM=strip(comm(i));
	 if strip(lborres)="ND" then LBSTAT="NOT DONE";
	  else LBSTAT="";
  output;
  end;
 end;
run;
/**Hematology*/
data hematology;
length commx $100.;
  set hematolab(rename=(subjid=subjid_ date=date_ siteid=siteid2));
   subjid=put(subjid_,z6.);
   %usubj();
   LBNAM="LABPRIMARYOTHER";
   LBNAMOTH="";
    if length(strip(date_))=9 then date=compress(substr(strip(date_),1,5)||"/"||substr(strip(date_),6,4));
	 else date=date_;
/*   if date ne "" and length(strip(date))=10 then date1=input(date_,ddmmyy10.);*/
   
   array resultsc {*} LVA_W LVA_HG LVA_HC LVA_PL LVA_N1 LVA_LC LVA_MC LVA_E LVA_B LVA_O;
   array resultsn {*} LVA_W_NUM LVA_HG_NUM LVA_HC_NUM LVA_PL_NUM LVA_N_NUM LVA_LC_NUM
                      LVA_MC_NUM LVA_E_NUM LVA_B_NUM LVA_O_NUM;
   array comm     {*} COMMX_W COMMX_HG COMMX_HC COMMX_PL COMMX_N COMMX_LC COMMX_MC
                      COMMX_E COMMX_B COMMX_O;
   array tests    {10} $200 _temporary_ ("WBC" "Haemoglobin" "Haematocrit" "Platelets"
                      "Neutrophils" "Lymphocytes" "Monocytes" "Eosinophils" "Basophils"
                      "Other"); 
    do i=1 to dim(resultsc);
	   LBSTRESN=.;
	  if i=1 then wbc=.;
	  if i=1 and resultsn(i) ne . then WBC=resultsn(i);
	  
	  if resultsc(i) ne "" then do;
	    LBORRES=strip(resultsc(i));
		LBCOMM=strip(comm(i));
		LBTEST=strip(tests(i));
		
		if siteid2 in (1 3) and lbtest in ("Neutrophils" "Lymphocytes" "Monocytes" "Eosinophils" "Basophils") then do;
		  if wbc ne . and resultsn(i) ne . then LBSTRESN=resultsn(i)*wbc*0.01;
		   LBSTRESC=strip(put(lbstresn,best.));
		end;
		else do;
		 LBSTRESN=resultsn(i);
		 LBSTRESC=LBORRES;
		end;

	   if strip(lborres)="ND" then LBSTAT="NOT DONE";
        else LBSTAT="";
	  output;
	 end;
	end;
run;
/*Urini Pregnancy*/
 data UrinPregnancy(drop=date_);
  set uripreg(rename=(subjid=subjid_ date=date_ siteid=siteid2));
   subjid=put(subjid_,z6.);
   %usubj();
   if date_ ne . then date=put(date_,ddmmyy10.);
    else date="";
 if lval ne "" ;
   LBTESTCD="HCG";
   LBTEST="Choriogonadotropin Beta";
   LBORRES=strip(lval);
   LBSTRESC=LBORRES;
   LBCOMM=strip(commx);
   LBSTRESN=.;
run;
/*Urinanalysis*/

data urinanalysis(drop=date_);
  length LPARM_UR_SPEC LPARM_UR_PH LPARM_UR_PA LPARM_UR_GL_S LPARM_UR_KA LPARM_UR_HB LPARM_UR_B LPARM_UR_URO LPARM_UR_NITR LPARM_UR_LE 
         LPARM_UR_RBC LPARM_UR_WBC LPARM_EPI_CELLS LPARM_UR_BACT LPARM_UR_USPEC_CAST LPARM_UR_UNSPEC_CRYST LPARM_UR_OTHER $200.;
  format LPARM_UR_SPEC LPARM_UR_PH LPARM_UR_PA LPARM_UR_GL_S LPARM_UR_KA LPARM_UR_HB LPARM_UR_B LPARM_UR_URO LPARM_UR_NITR LPARM_UR_LE 
         LPARM_UR_RBC LPARM_UR_WBC LPARM_EPI_CELLS LPARM_UR_BACT LPARM_UR_USPEC_CAST LPARM_UR_UNSPEC_CRYST LPARM_UR_OTHER $200.;
 set urinlab(rename=(subjid=subjid_ LVAL_UR_PA_NUM=LVAL_UR_PA_NUM2 LVAL_UR_GL_S_NUM=LVAL_UR_GL_S_NUM2 LVAL_UR_KA_NUM=LVAL_UR_KA_NUM2 LVAL_UR_HB_NUM=LVAL_UR_HB_NUM2 LVAL_UR_B_NUM=LVAL_UR_B_NUM2
                     LVAL_UR_URO_NUM=LVAL_UR_URO_NUM2 LVAL_UR_NITR_NUM=LVAL_UR_NITR_NUM2 LVAL_UR_LE_NUM=LVAL_UR_LE_NUM2 date=date_ siteid=siteid2));
  subjid=put(subjid_,z6.);
  %usubj();
  if date_ ne . then date=put(date_,ddmmyy10.);
   else date="";
  array newvar {*} LVAL_UR_PA_NUM LVAL_UR_GL_S_NUM LVAL_UR_KA_NUM LVAL_UR_HB_NUM LVAL_UR_B_NUM LVAL_UR_URO_NUM LVAL_UR_NITR_NUM LVAL_UR_LE_NUM;
  array oldvar {*} LVAL_UR_PA_NUM2 LVAL_UR_GL_S_NUM2 LVAL_UR_KA_NUM2 LVAL_UR_HB_NUM2 LVAL_UR_B_NUM2 LVAL_UR_URO_NUM2 LVAL_UR_NITR_NUM2 LVAL_UR_LE_NUM2;
   do i=1 to dim(oldvar);
    if oldvar(i) ne "" then newvar(i)=input(oldvar(i),best.);
	 else newvar(i)=.;
	end;
  LPARM_UR_SPEC="Specific Gravity";
  LPARM_UR_PH="PH";
  LPARM_UR_PA="Albumin/Total Protein";
  LPARM_UR_GL_S="Glucose";
  LPARM_UR_KA="Ketones";
  LPARM_UR_HB="Hemoglobin";
  LPARM_UR_B="Bilirubin_Total";
  LPARM_UR_URO="Urobilinogen";
  LPARM_UR_NITR="Nitrite";
  LPARM_UR_LE="Leukocyte Esterase";
  LPARM_MICRO_EXAM="Micro Examination";
  LPARM_UR_RBC="Red Blood Cells";
  LPARM_UR_WBC="White Blood Cells";
  LPARM_EPI_CELLS="Epithelial Cells";
  LPARM_UR_BACT="Bacteria";
  LPARM_UR_USPEC_CAST="Casts";
  LPARM_UR_UNSPEC_CRYST="Crystals";
  LPARM_UR_OTHER="Other";
run;
data urinanalysis1;
 set urinanalysis;
  LBNAM=strip(lbproth);
  LBNAMOTH=strip(lbsite);
  LVAL_EPI_CELLS_NUM=.;
  LVAL_UR_BACT_NUM=.;
  LVAL_UR_USPEC_CAST_NUM=.;
  LVAL_UR_UNSPEC_CRYST_NUM=.;
  LVAL_UR_OTHER_NUM=.;
  LVAL_MICRO_EXAM_NUM=.;

  array resultsc {*} LVAL_UR_SPEC LVAL_UR_PH LVAL_UR_PA LVAL_UR_GL_S LVAL_UR_KA LVAL_UR_HB LVAL_UR_B LVAL_UR_URO LVAL_UR_NITR LVAL_UR_LE
                     LVAL_MICRO_EXAM LVAL_UR_RBC LVAL_UR_WBC LVAL_EPI_CELLS LVAL_UR_BACT LVAL_UR_USPEC_CAST LVAL_UR_UNSPEC_CRYST LVAL_UR_OTHER;
  array resultsn {*} LVAL_UR_SPEC_NUM LVAL_UR_PH_NUM LVAL_UR_PA_NUM LVAL_UR_GL_S_NUM LVAL_UR_KA_NUM LVAL_UR_HB_NUM LVAL_UR_B_NUM LVAL_UR_URO_NUM LVAL_UR_NITR_NUM LVAL_UR_LE_NUM
                     LVAL_MICRO_EXAM_NUM LVAL_UR_RBC_NUM LVAL_UR_WBC_NUM LVAL_EPI_CELLS_NUM LVAL_UR_BACT_NUM LVAL_UR_USPEC_CAST_NUM LVAL_UR_UNSPEC_CRYST_NUM LVAL_UR_OTHER_NUM;
  array tests    {*} LPARM_UR_SPEC LPARM_UR_PH LPARM_UR_PA LPARM_UR_GL_S LPARM_UR_KA LPARM_UR_HB LPARM_UR_B LPARM_UR_URO LPARM_UR_NITR LPARM_UR_LE
                     LPARM_MICRO_EXAM LPARM_UR_RBC LPARM_UR_WBC LPARM_EPI_CELLS LPARM_UR_BACT LPARM_UR_USPEC_CAST LPARM_UR_UNSPEC_CRYST LPARM_UR_OTHER;
  array commx    {*} COMMX_UR_SPEC COMMX_UR_PH COMMX_UR_PA COMMX_UR_GL_S COMMX_UR_KA COMMX_UR_HB COMMX_UR_B COMMX_UR_URO COMMX_UR_NITR COMMX_UR_LE
                     COMMX_MICRO_EXAM COMMX_UR_RBC COMMX_UR_WBC COMMX_EPI_CELLS COMMX_UR_BACT COMMX_UR_USPEC_CAST COMMX_UR_UNSPEC_CRYST COMMX_UR_OTHER;	  

	do i=1 to dim(resultsc);
      LBSTRESN=.;
	 if resultsc(i) ne "" then do;
	    LBORRES=strip(resultsc(i));
		LBSTRESC=LBORRES;
		LBSTRESN=resultsn(i);
		LBCOMM=strip(commx(i));
		LBTEST=strip(tests(i));

	  if strip(upcase(lborres)) = "ND" then LBSTAT="NOT DONE";
	   else LBSTAT="";
	  
	  output;
     end;
	end;
run;
/*concat all the lab data*/
data Lab1;
 length COMMX_B $200.; 
 set Bloodchem(in=a) Hematology(in=b) urinpregnancy(in=c) urinanalysis1(in=d);
 if a then LBCAT="BLOODCHEMISTRY";
  else if b then LBCAT="HEMATOLOGY";
   else if c then LBCAT="URINALYSIS";
    else if d then LBCAT="URINALYSIS";
 DOMAIN="LB";
 STUDYID="&studyid";
  if length(date)=10 then LBDTC=put(input(date,ddmmyy10.),is8601da.);
   else if not missing(date1) then LBDTC=put(date1,is8601da.);	 
 run;

/*creation of baseline flag*/
 proc sort data=lab1;
  by usubjid visit lbcat lbtest;
 run;

data base;
  merge lab1(in=a) sdtm.dm(keep=usubjid rfstdtc sex age in=b);
  by usubjid;
  if a;
run;
data base1 nonbase;
 set base;
 if strip(visit)="SCREENING" and strip(lborres) not in ("" "ND") then output base1;
  else output nonbase;
run;
data base2;
 set base1;
  by usubjid visit lbcat lbtest ;
   if not (first.lbtest and last.lbtest) then put "AL""ERT : Subject has multiple screening tests";
   LBBLFL="Y";
run;
proc format;
 value $testcode 
   "Albumin"="ALB"
    "Alkaline Phosphatase"="ALP"
    "Basophils"="BASO"
    "Bilirubin_Total"="BILI"
    "Blood Urea Nitrogen"="BUN"
    "Chloride"="CL"
    "Creatinine"="CREAT"
    "Eosinophils"="EOS"
    "Gamma Glutamyl Transferase"="GGT"
    "Glucose"="GLUC"
    "Haematocrit"="HCT"
    "Haemoglobin"="HGB"
    "LDH"="LDH"
    "Lymphocytes"="LYM"
    "Monocytes"="MONO"
    "Neutrophils"="NEUTLE"
    "Platelets"="PLAT"
    "Potassium"="K"
    "Protein_Total"="PROT"
    "SGOT_AST"="AST"
    "SGPT_ALT"="ALT"
    "Sodium"="SODIUM"
    "Spermatozoa"="SPERM"
    "Urea"="UREA"
    "UR_FUNGI"="FUNGI"
    "WBC"="WBC"
    "Specific Gravity"="SPGRAV"
    "PH"="PH"
    "Albumin/Total Protein"="ALB"
    "Ketones"="KETONES"
    "Bilirubin"="BILI"
    "Urobilinogen"="UROBIL"
    "Nitrite"="NITRITE"
    "Leukocyte Esterase"="LEUKASE"
	"Micro Examination"="ME"
    "Red Blood Cells"="RBC"
    "White Blood Cells"="WBC"
    "Epithelial Cells"="EPIC"
    "Bacteria"="BACT"
    "Casts"="CASTS"
    "Crystals"="CRYSTALS"
    "Choriogonadotropin Beta"="HCG"
    "Other"="OTHER";
run;
data lb2;
length LBTESTCD $20.;
 set base2 nonbase;
  if length(LBDTC)=10 and length(RFSTDTC)=10 then do;
    if input(LBDTC,is8601da.) >= input(RFSTDTC,is8601da.) then LBDY=(input(LBDTC,is8601da.) - input(RFSTDTC,is8601da.))+1;
	  else if input(LBDTC,is8601da.) < input(RFSTDTC,is8601da.) then LBDY=input(LBDTC,is8601da.) - input(RFSTDTC,is8601da.);
  end;
  LBTESTCD=put(strip(LBTEST),$testcode.);
run;

data lb3;
 set lb2(rename=(visit=visit_));
   if substr(strip(visit_),1,3)="DAY" then VISIT=compress(substr(strip(visit_),1,1)||substr(strip(visit_),5));
    else if substr(strip(visit_),1,3)="MON" then VISIT=compress(substr(strip(visit_),7)||substr(strip(visit_),1,1));
    else if index(visit_,"UNSCHEDULED") and anydigit(visit_)=0 then VISIT=propcase(scan(visit_,1,""));
	else if index(visit_,"UNSCHEDULED") and anydigit(visit_)>0 then VISIT=compbl(Propcase(Scan(visit_,1,""))||""||put(input(scan(visit_,-1,""),best.) -1,best.));
	else if visit_="SCREENING" then VISIT=propcase(visit_);
run;
proc sort data=sdtm.sv out=visits(keep=visit visitnum) nodupkey;
 by visit;
run;
proc sort data=lb3;
 by visit;
run;
data lb4;
 merge lb3(in=a) visits(in=b);
  by visit;
  if a;
  if strip(visit)="Unscheduled" then visitnum=99;
run;

proc sort data=lbcodes.lbranges out=ranges;
 by centreid centre;
 where not (centre="Ghana" and parameter in ("Lymphocytes" "Monocytes" "Neutrophils" "Eosinophils" "Basophils") and paramu = "%")                    ;
run;
data ranges1;
 set ranges(rename=(parameter=parameter_));
 PARAMETER=propcase(Parameter_);
 if parameter ="Wbc" then parameter="WBC";
run;
data biochemcode;
 set lbcodes.biochem(rename=(parameter=parameter1));
  parameter=propcase(parameter1);
   if parameter="Alat" then parameter="SGPT_ALT";
    else if parameter="Asat" then parameter="SGOT_AST";
	 else if parameter="Protein Total" then parameter="Protein_Total";
	  else if parameter="Ldh" then parameter="LDH";
	   else if parameter="Ggt" then parameter="Gamma Glutamyl Transferase";
	    else if parameter="Bilirubin Total" then parameter="Bilirubin_Total";
run;

proc sql noprint;
 create table lbranges as
  select a.*,b.* from lb4 a left join ranges1 b 
                 on a.siteid2=b.centreid and strip(upcase(a.lbtest))=strip(upcase(b.parameter))
				                     and strip(a.lbcat)="HEMATOLOGY";
 create table lbbiochem as
  select a.*,b.* from lbranges a left join biochemcode(rename=(parameter=parameter2 centre=centre2)) b 
                 on a.siteid2=b.centre2 and strip(upcase(a.lbtest))=strip(upcase(b.parameter2))
				                   and strip(a.lbcat)="BLOODCHEMISTRY";
quit;

data wbc(keep=usubjid wbc visit visitnum);
 set lbbiochem;
 where lbcat="HEMATOLOGY";
run;

proc sort data=wbc out=wbc1 nodup;
 by usubjid visitnum visit;
run;
proc sort data=lbbiochem;
 by usubjid visitnum visit;
run;

data wbc_;
 merge lbbiochem(in=a) wbc1(in=b);
  by usubjid visitnum visit;
run;

data work2.wbc2;
length LBORNRLO LBORNRHI LBORRESU LBSTRESU $20.;
 set wbc_;
 LBORRESU=PARAMU;
  if strip(lbcat)="HEMATOLOGY" then do;
    if strip(sex)="M" then do;
      LBORNRLO_=LBORNRLOM;
      LBORNRHI_=LBORNRHIM;
	end;
    else if strip(sex)="F" then do;
	  LBORNRLO_=LBORNRLOF;
	  LBORNRHI_=LBORNRHIF;
	end;
  end;
  if strip(lbcat) ="BLOODCHEMISTRY" and strip(lbtest) ne "Alkaline Phosphatase" then do;
    if strip(sex)="M" then do;
	  LBORNRLO_=LBORNRLOMALE;
	  LBORNRHI_=LBORNRHIMALE;
	end;
	if strip(sex)="F" then do;
	  LBORNRLO_=LBORNRLOFEMALE;
	  LBORNRHI_=LBORNRHIFEMALE;
	end;
  end;
  if strip(lbcat)="BLOODCHEMISTRY" and strip(lbtest) = "Alkaline Phosphatase" then do;
    if age < 14 then do;
	 if strip(sex)="M" then do;
	  LBORNRLO_=LBORNRLOMALEAGE14;
	  LBORNRHI_=LBORNRHIMALEAGE14;
	 end;
	 if strip(sex)="F" then do;
	  LBORNRLO_=LBORNRLOFEMALEAGE14;
	  LBORNRHI_=LBORNRHIFEMALEAGE14;
	 end;
	end;
	if 16 > age >= 14 then do;
	 if strip(sex)="M" then do;
	  LBORNRLO_=LBORNRLOMALEAGE_14AND16;
	  LBORNRHI_=LBORNRHIMALEAGE_14AND16;
	 end;
	 if strip(sex)="F" then do;
	  LBORNRLO_=LBORNRLOFEMALEAGE_14AND16;
	  LBORNRHI_=LBORNRHIFEMALEAGE_14AND16;
	 end;
	end;
	if 20 > age >= 16 then do;
	 if strip(sex)="M" then do;
	  LBORNRLO_=LBORNRLOMALEAGE_16AND20;
	  LBORNRHI_=LBORNRHIMALEAGE_16AND20;
	 end;
	 if strip(sex)="F" then do;
	  LBORNRLO_=LBORNRLOFEMALEAGE_16AND20;
	  LBORNRHI_=LBORNRHIFEMALEAGE_16AND20;
	 end;
	end;
	if age >= 20 then do;
	 if strip(sex)="M" then do;
	  LBORNRLO_=LBORNRLOMALEAGE_20;
	  LBORNRHI_=LBORNRHIMALEAGE_20;
	 end;
	 if strip(sex)="F" then do;
	  LBORNRLO_=LBORNRLOFEMALEAGE_20;
	  LBORNRHI_=LBORNRHIFEMALEAGE_20;
	 end;
	end;
  end;
  if strip(lbtest) in ("Neutrophils" "Lymphocytes" "Monocytes" "Eosinophils" "Basophils")
    then do;
    LBSTRESU="x10E9/L";
	 if strip(paramu) = "%" and not missing(wbc) then do;
	   LBSTNRLO=lbornrlo_*wbc*0.01;
	   LBSTNRHI=lbornrhi_*wbc*0.01;
	 end;
  end;
  if lbstresu eq "" and lborresu ne "" then lbstresu=lborresu;
  if strip(lbstresu)=strip(lborresu) then do;
      LBSTNRLO=LBORNRLO_;
	  LBSTNRHI=LBORNRHI_;
  end;
     LBORNRLO=put(lbornrlo_,best.);
	 LBORNRHI=put(lbornrhi_,best.);
run;
proc sort data=work2.wbc2;
 by usubjid lbcat lbtest visitnum lbdtc;
run;

data LB_f;
 set work2.wbc2;
  by usubjid lbcat lbtest visitnum lbdtc;
  if first.usubjid then LBSEQ=0;
  LBSEQ+1;
  if lborresu = "" and PARAMETERUNIT ne "" then lborresu=PARAMETERUNIT;
  if lborresu ne "" and lbstresu= "" then lbstresu=lborresu;
  LBRIND="";
  VISITDY=LBDY;
run;

/*Supp Domain for the lab*/
data suplb;
 set LB_f;
  where LBCOMM ne "" ;
  RDOMAIN=DOMAIN;
  IDVAR="LBSEQ";
  IDVARVAL=put(lbseq,best.);
  QORIG="CRF";
  QEVAL="";
  if LBCOMM ne " " then do;
  QNAM="LBCOMM";
  QVAL=strip(lbcomm);
  QLABEL="Clinical significance and other comments";
  output;
  end;
run;

%spec(domain=LB,sdomain=YES);

  


	  
 


 










