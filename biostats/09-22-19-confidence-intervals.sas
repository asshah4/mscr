/*
Confidence intervals in SAS
Anish Shah
09-22-19
*/

*Named library;
LIBNAME CLASS "H:\My Documents\Github\tl1-grant\mscr\biostats\";

*Need to save/add in the cholera database for the example;
* First need to assess normality;
PROC UNIVARIATE DATA = CLASS.cholera;
	VAR age;
	HISTOGRAM age;
	PROBPLOT age / normal;
RUN;

*Find hte confidence intervals of hte mean, default is alpha = 0.95;
PROC MEANS DATA = CLASS.cholera CLM;
	VAR age;
RUN;

*Change alpha to adjust CI, e.g. here it is CI = 90%;
PROC MEANS DATA = CLASS.cholera CLM ALPHA = 0.1;
	VAR age;
RUN;
