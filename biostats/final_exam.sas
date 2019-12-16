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
	DBMS = xlsx REPLACE;
	GETNAMES = YES;
RUN;

* Check contents;
PROC CONTENTS DATA = WORK.fit;
RUN;

*** Descriptive analysis;

* Frequency data;
PROC UNIVARIATE DATA = WORK.fit;
	VAR Age Maximum_Pulse Oxygen_Consumption 
Performance RunTime Weight;
	HISTOGRAM Oxygen_Consumption / normal;
	PROBPLOT Oxygen_Consumption;
	HISTOGRAM Maximum_Pulse Performance RunTime;
RUN;

* Means and skew of data;
PROC MEANS DATA = H.senic2;
	VAR facility prob_inf;
RUN;

*** B. Scatter plots;
PROC SGSCATTER DATA = H.senic2;
	PLOT prob_inf * facility;
RUN;

*** C.  Correlation;
PROC CORR DATA = H.senic2;
	VAR prob_inf;
	WITH facility;
RUN;

*** D. Regression model;
PROC REG CORR DATA = H.senic2;
	MODEL prob_inf = facility; 
RUN;
	
ODS RTF CLOSE;
