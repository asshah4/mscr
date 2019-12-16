%* 
How to do linear regressions
Basic models for best fit lines
*%;

DATA;
	INPUT woman age mass @@;
	DATALINES;
1 71 82
2 64 91
3 43 100
4 67 68
5 56 87
6 73 73
7 68 78
8 56 80
9 76 65
10 65 84
11 45 116
12 58 76
13 45 97
14 53 100
15 49 105
16 78 77
;
RUN;

* Regression model;
PROC REG CORR;
	MODEL mass = age;
RUN;

* Regression model with confidence intervals;
* Default is 95%, but can modify it as below;
PROC REG CORR;
	MODEL mass = age / CLM alpha = 0.01;
RUN;

	* Can do confidence interval for single individual observation as well;
PROC REG CORR;
	MODEL mass = age / CLM CLI; 
RUN;
