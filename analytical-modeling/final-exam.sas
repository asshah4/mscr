*************************************************
Final Exam
MSCR 534
Anish Shah
May 1, 2020
*************************************************;

*Library;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";
RUN;

*** Question 6;
PROC CONTENTS DATA = H.q5;
RUN;

* Mediation analysis;
PROC CAUSALMED DATA = H.q5 DESCENDING;
	MODEL hip55 = livea dep / DIST=bin;
	MEDIATOR dep = livea;
RUN;
*Output
- Percent Mediated = 2.9977%;

*** Question 7;
PROC CONTENTS DATA = H.q7;
RUN;

* Remove those who died;
DATA seven;
	SET H.q7;
	IF outcome ^= 1;
RUN;

* KM curve;
PROC LIFETEST DATA = seven ATRISK PLOTS=survival(cb);
	TIME survival_t*outcome(0);
	STRATA smoke;
RUN;

* Cox regression;
PROC PHREG DATA = seven;
	CLASS smoke(ref='0') sex(ref='0') agecat(ref='0');
	MODEL survival_t*outcome(0) = smoke sex agecat / 
		TIES = efron RL;
RUN;

* Subdistribution for lung cancer;
PROC PHREG DATA = H.q7;
	CLASS smoke(ref='0') sex(ref='0') agecat(ref='0');
	MODEL survival_t*outcome(0) = smoke sex agecat / 
		EVENTCODE=2 RL;
RUN;


* Subdistribution for death;
PROC PHREG DATA = H.q7;
	CLASS smoke(ref='0') sex(ref='0') agecat(ref='0');
	MODEL survival_t*outcome(0) = smoke sex agecat / 
		EVENTCODE=1 RL;
RUN;
