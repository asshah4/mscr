LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";
RUN;

*** QUESTION 1 ***;

*Read in data lines
*Queston 1; 

data q1;
input deaths State age1 age2 age3 age4 age5 age6 age7 population agegp;
datalines; 
12	0	1	0	0	0	0	0	0	182756	1
14	0	0	1	0	0	0	0	0	190332	2
28	0	0	0	1	0	0	0	0	201221	3
65	0	0	0	0	1	0	0	0	876231	4
102	0	0	0	0	0	1	0	0	921923	5
100	0	0	0	0	0	0	1	0	1298922	6
133	0	0	0	0	0	0	0	1	1283281	7
120	0	0	0	0	0	0	0	0	1018728	8
25	1	1	0	0	0	0	0	0	161222	1
43	1	0	1	0	0	0	0	0	159594	2
144	1	0	0	1	0	0	0	0	604213	3
323	1	0	0	0	1	0	0	0	809765	4
367	1	0	0	0	0	1	0	0	1098191	5
298	1	0	0	0	0	0	1	0	1589381	6
301	1	0	0	0	0	0	0	1	948312	7
121	1	0	0	0	0	0	0	0	728193	8
;
run;

* Add in the log pop for poisson;
DATA q1;
	SET q1;
	ln_pop = log(population);
RUN;

* Adjusted poisson;
PROC GENMOD DATA = q1;
	CLASS State(ref = '0') / PARAM = ref;
	MODEL deaths = State agegp / LINK = log DIST = poisson OFFSET = ln_pop;
	ESTIMATE "Adj Rate Ratio of State 1 versus State 0" State 1 / EXP;
RUN;


*** QUESTION 2 ***;

PROC UNIVARIATE DATA = H.cohort NOPRINT;
	VAR baserbg2;
	OUTPUT out = tertiles PCTLPRE = glugrp PCTLPTS = 0, 33.3, 66.6, 100;
RUN;

PROC PRINT DATA = tertiles NOOBS; 
RUN;

DATA q2;
	SET H.cohort;
	* make tertiles;
	glugrp1 = 0; glugrp2 = 0; glugrp3 = 0;
	IF baserbg2 >= 99 THEN glugrp3 = 1;
	IF baserbg2 < 99 AND baserbg2 >= 79.2 THEN glugrp2 = 1;
	IF baserbg2 < 79.2 THEN glugrp1 = 1;
RUN;
	
* Conventional regression;
PROC PHREG DATA = q2;
	MODEL timetooc * outc2(0) = glugrp2 glugrp3 / TIES = efron RL;
RUN;

* Splines;
%rqspline(data=WORK.q2,x=baserbg2,event=outc2,k=3,equal=1,cases=1);

* Check spline-ness;
PROC CONTENTS DATA = q2;
RUN;

* Unadjusted;
PROC PHREG DATA =  q2;
	MODEL timetooc * outc2(0) = baserbg2 _baserbg2 __baserbg2 
		/ TIES = efron RL;
RUN;

* Adjusted;
PROC PHREG DATA =  q2;
	MODEL timetooc * outc2(0) = baserbg2 _baserbg2 __baserbg2 agecat
		/ TIES = efron RL;
RUN;




*** QUESTION 3 ***;

* Table 3A;
PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0) = sex / TIES = efron RL;
RUN;


PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0) = sex age smk / TIES = efron RL;
RUN;

* Table 3B;

* Cause specific for asp;
PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0, 2) = sex / TIES = efron RL;
RUN;


PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0, 2) = sex age smk / TIES = efron RL;
RUN;


* Cause specific for death;
PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0, 1) = sex / TIES = efron RL;
RUN;


PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0, 1) = sex age smk / TIES = efron RL;
RUN;

* Subdistribution for asp;
PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0) = sex  / EVENTCODE = 1 RL;
RUN;


PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0) = sex age smk / EVENTCODE = 1 RL;
RUN;


* Subdistribution for death;
PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0) = sex  / EVENTCODE = 2 RL;
RUN;


PROC PHREG DATA = H.analysisexercise2question3;
	CLASS sex(ref='0');
	MODEL timetoc2 * censor1(0) = sex age smk / EVENTCODE = 2 RL;
RUN;
