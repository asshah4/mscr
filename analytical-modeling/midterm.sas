/* 
Midterm in SAS 
Anish Shah
March 4th, 2020
*/

* Library;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";

* Check data;
PROC CONTENTS DATA = H.midterm;
RUN;

*** #1;

* Crude prevalence;
PROC FREQ DATA = H.midterm;
	TABLE PWID * HCVpre / RELRISK;
RUN;

* Adjusted prevalence ratio;
PROC GENMOD DATA = H.midterm;
	MODEL HCVpre(event='1') = PWID agecat gender / 
		DIST = binomial LINK = log;
	ESTIMATE 'Prevalence Ratio' PWID 1 / exp;
RUN;

*** #2;

* Exclue those that have prevalent HCV;
DATA deleted;
	SET H.midterm;
	IF HCVpre ~= 1;
RUN;

* Cumulative incidence;
*Plot the failures by treatment group (opposite of survival);
ODS GRAPHICS ON;
PROC LIFETEST DATA = deleted METHOD = km 
		PLOTS = survival(failure TEST ATRISK);
	TIME survt * HCVinc(0);
	STRATA PWID;
RUN;
ODS GRAPHICS OFF;

* Unadjusted HR;
PROC PHREG DATA = deleted;
	CLASS PWID(REF = '0');
	MODEL survt*HCVinc(0) = PWID / RL;
RUN;

* Adjusted HR;
PROC PHREG DATA = deleted;
	CLASS PWID(REF = '0');
	MODEL survt*HCVinc(0) = PWID agecat gender / RL;
RUN;

*** #3;

* KM survival curve;
PROC LIFETEST DATA = H.midterm METHOD = km 
		PLOTS = survival (TEST ATRISK);
	TIME survt * HCVinc(0);
	STRATA PWID;
RUN;

* Censored?;

PROC LIFETEST DATA = H.midterm METHOD = km 
		PLOTS = survival (TEST ATRISK);
	TIME survt * HCVinc(0);
RUN;

*** #4;

* Log log;
PROC LIFETEST DATA = H.midterm METHOD = km PLOT = (lls, ls);
	TIME survt * HCVinc(0);
	STRATA PWID;
RUN;

* Interaction;

PROC PHREG DATA = H.midterm;
	MODEL survt * HCVinc(0) = PWID ptime / RL;
	ptime = PWID * survt;
RUN;

* Adjusted interaction;
PROC PHREG DATA = H.midterm;
	MODEL survt * HCVinc(0) = PWID ptime agecat atime gender gtime / RL;
	ptime = PWID * survt;
	atime = agecat * survt;
	gtime = gender * survt;
RUN;
