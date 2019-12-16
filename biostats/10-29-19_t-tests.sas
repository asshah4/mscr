/* 
T-test lecture on how to run on SAS
Also interpretation of data
In class practice
*/

* Named library;
LIBNAME H "H:\My Documents\Github\tl1-grant\mscr\biostats\";

* T-test;
PROC TTEST DATA=h.stroke2007;
	CLASS hxsmoking;
	VAR liptotal;
RUN;
