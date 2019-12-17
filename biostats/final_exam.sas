/*
MSCR 500 and 533
Final Exam SAS Code
Anish Shah
*/

*Named Library;
LIBNAME H "H:\My Documents\Github\mscr\biostats\";

/* Question 5 */

*Data set up;
DATA q5;
  INPUT mouse normal mutant;
  LABEL x = ‘Sodium Intake’ y = ‘SBP’;
  DATALINES;
1			180								100
2			160								97
3			140								80
4			62									6
5			82									31
6			73									110
7			43									7
8			36									55
9			110								100
;
RUN;

* Paired t-test;
PROC TTEST DATA = WORK.q5;
	PAIRED normal*mutant;
RUN;

/* Question 6 */

* Data set up;
DATA q6;
	INPUT defect$ well$ count;
	DATALINES;
Yes Old 16
No Old 398
Yes New 5
No New 223
;
RUN;

* Chi square test;
PROC FREQ DATA = q6;
	TABLES defect*well / chisq;
	WEIGHT count;
RUN;

/* Question 7 */

PROC IMPORT OUT = WORK.zinc
	DATAFILE = "H:\My Documents\Github\mscr\biostats\zinc.xls"
	DBMS = EXCEL REPLACE;
	GETNAMES = YES;
	MIXED = YES;
	SCANTEXT = YES;
	USEDATE = YES;
	SCANTIME = YES;
RUN;

* Check uot the data;
PROC PRINT DATA = WORK.zinc (OBS=10);
RUN;

PROC CONTENTS;
RUN;

*Create permanent dataset;
DATA H.zinc_Anish;
  SET WORK.zinc;

  *Add variable named "Diff", for each pair of rats;
  *Difference b/w treated and utreated rats;
  DIFF = Calcium - No_Calcium;

  * PAIR variable;
  PAIR = _N_;

  *"Sex" variable;
  *Pairs 1 to 10 are male;
  *Pairs 11-20 are female;
  IF PAIR <= 10 THEN SEX = 0;
  	ELSE IF PAIR >= 11 THEN SEX = 1;

RUN;

* Check to see if it worked;
PROC CONTENTS DATA = H.zinc_Anish;
RUN;
PROC PRINT DATA = H.zinc_Anish (OBS = 20);
RUN;

* Descriptive analysis;
PROC UNIVARIATE DATA = H.zinc_Anish;
	VAR DIFF;
	HISTOGRAM DIFF;
	PROBPLOT DIFF;
RUN;


* Inferential analysis;

* 90% CI for true average DIFF;
PROC TTEST DATA = H.zinc_Anish ALPHA = 0.1;
	PAIRED Calcium*No_Calcium;
RUN;

* 90% CI for true average DIFF for female rats;
PROC TTEST DATA = H.zinc_Anish ALPHA = 0.1;
	BY SEX;
	VAR DIFF;
RUN;


/* Question 9 */

* Make this a report;
ODS RTF FILE="H:\My Documents\Github\mscr\biostats\final_exam.rtf";
	ODS STARTPAGE = YES;

* Import data;
PROC IMPORT OUT = WORK.fit
	DATAFILE = "H:\My Documents\Github\mscr\biostats\fitness2019.xlsx"
	DBMS = XLSX REPLACE;
	GETNAMES = YES;
RUN;

* Check contents;
PROC CONTENTS DATA = WORK.fit;
PROC PRINT DATA = WORK.fit (OBS = 10);
RUN;


*** Descriptive analysis;

* Continuous data;
PROC UNIVARIATE DATA = WORK.fit;
	VAR Age Maximum_Pulse Oxygen_Consumption 
Performance RunTime Weight;
	HISTOGRAM Oxygen_Consumption / normal;
	PROBPLOT Oxygen_Consumption;
	HISTOGRAM Maximum_Pulse Performance RunTime;
RUN;

* Categorical data;
PROC FREQ DATA = WORK.fit;
	TABLE Sex;
RUN;

* Scatter of the data;
PROC SGPLOT DATA = WORK.fit;
	SCATTER y = Oxygen_Consumption x = Age;
PROC SGPLOT DATA = WORK.fit;
	SCATTER y = Oxygen_Consumption x = Maximum_Pulse;
PROC SGPLOT DATA = WORK.fit;
	SCATTER y = Oxygen_Consumption x = Performance;
PROC SGPLOT DATA = WORK.fit;
	SCATTER y = Oxygen_Consumption x = RunTime;
RUN;

* Correlation;
PROC CORR DATA = WORK.fit;
	VAR Oxygen_Consumption;
	WITH Age Maximum_Pulse Performance RunTime;
RUN;

/* Correlation patterns based on plot and corr data
Age not super strong
Max pulse not super strong
Performance and Runtime are very tight (rho ~ 0.8, although runtime is negative)
*/

* Inference about sex.
Appears signficant by group
Likely good to include as covariate;
PROC SORT DATA = WORK.fit;
	BY Sex;
PROC BOXPLOT DATA = WORK.fit;
	PLOT Oxygen_Consumption*Sex / CBOXES = black;
PROC TTEST;
	CLASS Sex;
	VAR Oxygen_Consumption;
RUN;

* Recode gender to 0 and 1s;
DATA WORK.fit;
	SET WORK.fit;
	IF Sex = 'F' THEN NumSex = 0;
	ELSE IF Sex = 'M' THEN NumSex = 1;
RUN;

* Simple Regression models;
PROC REG CORR DATA = WORK.fit;
	MODEL Oxygen_Consumption = Age; 
	MODEL Oxygen_Consumption = Maximum_Pulse;
	MODEL Oxygen_Consumption = Performance;
	MODEL Oxygen_Consumption = RunTime;
	MODEL Oxygen_Consumption = NumSex;
RUN;

/*
Which variables to include?
Age not good fit
Max Pulse not a good fit
Performance is correlated! However is subjective, prone to bias
RunTime is correlated!
Sex is t-test significant, but cannot assess linearity
*/

* Multiple linear regressions;
PROC REG CORR DATA = WORK.fit;
	MODEL Oxygen_Consumption = NumSex Age RunTime / clb;
RUN;

ODS RTF CLOSE;
