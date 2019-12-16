/*
Simple and Multiple Linear Regressions
Anish Shah
Class notes (SAS lab)
*/

LIBNAME H "H:\My Documents\Github\tl1\mscr\biostats\";


* Data is sandwiches;
* DV = calories, IV = weight;
PROC CONTENTS DATA = H.sandwich;
RUN;

* Univarate analysis;
PROC UNIVARIATE DATA = H.sandwich;
  VAR weight calories;
  HISTOGRAM weight / normal;
  HISTOGRAM calories / normal;
  PROBPLOT calories;
RUN;

* Plot hte scatter plot for these variables;
* calories ~ weight;
PROC PLOT DATA = H.sandwich;
	PLOT calories * weight;
RUN;

* Correlation analysis;
PROC CORR DATA = H.sandwich;
  VAR calories;
  WITH weight;
RUN;

* Do linear regression;
PROC REG CORR DATA = H.sandwich;
  MODEL calories = weight;
RUN;

* Multiple linear regressions can also be done;
* calories ~ weight + tfat;

* Describe this data;
PROC UNIVARIATE DATA = H.sandwich;
	VAR calories weight tfat;
	HISTOGRAM calories weight tfat;
	PROBPLOT calories weight tfat;
RUN;

* Simple scatters;
PROC SGPLOT DATA = H.sandwich;
	SCATTER y=calories x=tfat;
	SCATTER y=calories x=weight;
RUN;

* 3D plot (JMP is better, but this is fair;
PROC G3D DATA = H.sandwich;
	SCATTER weight * tfat = calories;
RUN;

* Correlation;
PROC CORR DATA = H.sandwich;
	VAR calories;
	WITH weight tfat;
RUN;

* Regression;
PROC REG CORR DATA = H.sandwich;
	MODEL calories = weight tfat;
RUN;
