/* 
Linear Regressino Class Example
*/
* Named library;
LIBNAME H "H:\My Documents\Github\tl1\mscr\biostats\";

* Make this a report;
ODS RTF FILE="H:\My Documents\Github\tl1\mscr\biostats\slr.rtf";
	ODS STARTPAGE = YES;

* File contents of the variables;
PROC CONTENTS DATA = H.senic2;
RUN;

*** A. Descriptive analysis;

* Frequency data;
PROC UNIVARIATE DATA = H.senic2;
	VAR facility prob_inf;
	HISTOGRAM prob_inf / normal;
	PROBPLOT prob_inf;
	HISTOGRAM facility;
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
