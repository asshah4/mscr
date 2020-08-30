*****************************************************
*TITLE: Lab 8                                      	*
*Estimation of hazard ratios using spline regression*
*													*
*DATE: April 1, 2020 Lab exercise					*  
*													*
*DATASETS available on Canvas: hivtb				*
*****************************************************                                    

Lab 8 contains four parts: 
Part 1. Estimating the hazard ratios using standard linear 
and category-specific regression

Part 2. Testing non-linear in a dose-response relationship 

Part 3. Estimating the hazard ratios using restricted quadratic
spline regression

Part 4. Plotting of the spline regression results
;

**Suppose your study goal is to assess the relationship 
between glucose level (exposure) and 
hazard rate of death (outcome);

**Potential confounders are age, sex and body mass index (BMI);

*****PART 1 Estimating the hazard ratios using standard linear 
and category-specific regression;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";
RUN;

PROC CONTENTS DATA = H.cohort;
RUN;

* Label variables;
DATA cohort;
	SET H.cohort;
	LABEL code = "Patient ID";
	LABEL baserbg2 = "Random BG Level";
	LABEL agecat = "Age Group";
	LABEL bmicat = "BMI";
	LABEL outc2 = "Death Event";
	LABEL timetooc = "Time to Event";
RUN;


**First estimate the relationship between blood glucose level 
and risk of death;

**Model 1. Assumption- log-linear association between baseline 
RBG and hazard of death;
*Start with descriptive statistics;
PROC UNIVARIATE DATA = cohort;
	VAR baserbg2;
	HISTOGRAM;
RUN;

PROC FREQ DATA = cohort;
	TABLE outc2 agecat gender bmicat;
RUN;

**Run a crude Cox regression model;
PROC PHREG DATA = cohort;
	MODEL timetooc*outc2(0) = baserbg2 / TIES = efron RL;
RUN;

*What is the unadjusted association between continuous 
glucose level and hazard of death? Interpret the results.
HR = 1.002

******************************************************************************************************************

**Second, estimate the relationship between blood glucose 
level and hazard of death using category-specific regression;
***Creating new indicator variables for RBS using 
1) cut-off point at 144, 
2) four equal cut-off points and 
3) ten cut-off points;
DATA cohort;
	SET cohort;
	* create dichotomous var;
	highrbg = 0;
	IF baserbg2 >= 144 THEN highrbg = 1;
	*Create four levels;
	rbg0 = 0; rbg1=0; rbg2=0; rbg3=0;
	IF baserbg2 < 75 						THEN rbg0=1;
	IF baserbg2 >= 75 AND baserbg2 <88.2 	THEN rbg1 = 1;
	IF baserbg2 >= 88.2 AND baserbg2 <106.2 THEN rbg2 = 1;
	IF baserbg2 >= 106.2 					THEN rbg3 = 1;
	* create 10 indicator variables;
	rbgl1=0; rbgl2=0; rbgl3=0; rbgl4=0; rbgl5=0; 
	rbgl6=0; rbgl7=0; rbgl8=0; rbgl9=0; rbgl10=0;
	IF baserbg2<60.1 						THEN rbgl1=1;	
	IF baserbg2>=60.1 and baserbg2<80.1 	THEN rbgl2=1;
	IF baserbg2>=80.1 and baserbg2<100.1 	THEN rbgl3=1;
	IF baserbg2>=100.1 and baserbg2<120.1 	THEN rbgl4=1;
	IF baserbg2>=120.1 and baserbg2<140.1 	THEN rbgl5=1;
	IF baserbg2>=140.1 and baserbg2<160.1 	THEN rbgl6=1;
	IF baserbg2>=160.1 and baserbg2<180.1 	THEN rbgl7=1;
	IF baserbg2>=180.1 and baserbg2<200.1 	THEN rbgl8=1;
	IF baserbg2>=200.1 and baserbg2<220.1 	THEN rbgl9=1;
	IF baserbg2>=220.1  					THEN rbgl10=1;
RUN;


**Cross tabulation of newly created categorical/indicator 
variables and events;
*All indicator variables should be checked. 
Checking fews here as examples;
PROC FREQ DATA = cohort;
	TABLE highrbg * outc2 / NOCOL NOCUM NOPERCENT;
RUN;

PROC FREQ DATA = cohort;
	TABLE rbg1 * outc2 / NOCOL NOCUM NOPERCENT;
RUN;

PROC FREQ DATA = cohort;
	TABLE rbgl1 * outc2 / NOCOL NOCUM NOPERCENT;
RUN;

PROC FREQ DATA = cohort;
	TABLE rbgl10 * outc2 / NOCOL NOCUM NOPERCENT;
RUN;


**Model 2. Using the two cut-off points to model
association between hyperglycemia and hazard of death (<144,>=144);
PROC PHREG DATA = cohort;
	CLASS highrbg(ref='0');
	MODEL timetooc * outc2(0) = highrbg / TIES = efron RL;
RUN;

** According to model 2, what is the unadjusted 
association between glucose level and death? Interpret the results.
HR = 1.1;

**Model 3. Using the four cut-off points to model 
association between baseline RBG and hazard of death 
(<75, 75-88.2, 88.3-106, >106);
PROC PHREG DATA = cohort;
	MODEL timetooc * outc2(0) = rbg1 rbg2 rbg3 / TIES = efron RL;
RUN;
**According to model 3, what is the association between 
glucose level and death? Interpret the results.
rbg1 = 0.97
rbg2 = 1.03
rbg3 = 1.23
;

*********************************************************************
***PART 2. Testing non-linear dose-response relationship: 
Using the ten cut-off points to model association 
between baseline RBG and hazard of death;

**"test" statement: To test nonlinear hypothesis after estimation 
of HRs [Ho: b1= b2 = b3...]. It produces Wald-type tests of 
smooth nonlinear (or linear) hypotheses about the estimated 
parameters from the fitted model.  The p-values are 
based on the delta method, an approximation appropriate in 
large samples;

PROC PHREG DATA = cohort;
	MODEL timetooc*outc2(0) = rbgl2 rbgl3 rbgl4 rbgl5 
		rbgl6 rbgl7 rbgl8 rbgl9 rbgl10 / TIES = efron RL;
	TEST_NONLINEAR: test rbgl2, rbgl3, rbgl4, rbgl5, 
		rbgl6, rbgl7, rbgl8, rbgl9, rbgl10;
	OUTPUT out = work.xbeta (keep=xbeta xbetase baserbg2 rbgl1 rbgl2 
		rbgl3 rbgl4 rbgl5 rbgl6 rbgl7 
		rbgl8 rbgl9 rbgl10) xbeta=xbeta STDXBETA=xbetase;		
		/*Save the beta estimates for plotting the graph*/
RUN;
*Comment on the dose-response relationship between blood 
glucose and risk of death according to model.
It appears to be nonlinear;

**Plotting relative hazard of death as a function of 
baseline RBG for better visualization of the dose-response relationship;
*Calculate and save hazard ratios (rh) of each indicator 
from beta estimates that we saved from above model(xbeta);

/*Sort exposure variable for graphing*/
PROC SORT DATA = xbeta; BY baserbg2;
DATA work.rbgrhplot;
	SET xbeta;
	rh = exp(xbeta);
RUN; /*Calculate relative hazard using beta estimates for graphing*/

/*Setting and saving format options for the graph*/
options nogstyle FONTRENDERING=HOST_PIXELS;
goptions reset=all;
filename grafout "C:\Users\asshah4\Downloads\figure2b.png";
goptions device=zpng target=png gsfname=grafout gsfmode=replace xmax=6 ymax=6 xpixels=3600 ypixels=3600;
axis1 color=black interval=even 
label=(angle=90 font=swiss h=2 "Relative hazard of death") w=2
major=(h=1 w=2) minor=none value=(font=swiss h=2) offset=(0,0);
axis2 color=black
label=(font=swiss h=2 justify=center "Baseline RBG mg/dl") w=2
major=(h=1 w=2) minor=none value=(font=swiss h=2) offset=(0,0);
symbol1 c=black l=1 w=3 h=.4 v=none i=stepjs;
symbol2 c=black l=2 w=2 h=.4 v=none i=stepjs;
symbol3 c=black l=2 w=2 h=.4 v=none i=stepjs;
footnote move=(60,42) font=swiss color=black h=2;

*Plot the graph;
proc gplot data=work.rbgrhplot;
plot (rh)*baserbg2/overlay vaxis=axis1 haxis=axis2 noframe nolegend; run; quit; run;
footnote " "; run;
*Comment on the dose-response relationship from the graph.


******************************************************************************************************
PART 3. Estimating hazard ratios using restricted quadratic 
spline with 4 equal knots at the p20 p40 p60 p80
based on the case distribution to model the association between
baseline RBG and hazard of death";

**First run restricted quadratic spline (rqs) macro
[macro can be downloaded from here doi:10.1097/EDE.0b013e31823029dd];
%macro rqspline(data=_last_,x=,event=,k=,equal=,cases=);
options nonotes;
%local _p_ _z_;
data &data;
set &data;
_z_=1;
%if &equal=0 %then %do;
%if &cases=0 %then %do;
proc univariate data=&data noprint;
var &x; output out=_p_ pctlpts=3 5 18 23 28 34 35 41 50 59 65 66 73 77 82 95 98 pctlpre=p;
%end;
%if &cases=1 %then %do;
proc univariate data=&data noprint;
where &event=1; var &x; output out=_p_ pctlpts=3 5 18 23 28 34 35 41 50 59 65 66 73 77 82 95 98 pctlpre=p;
%end; %end;
%if &equal=1 %then %do;
%if &cases=0 %then %do;
proc univariate data=&data noprint;
var &x; output out=_p_ pctlpts=12 15 16 20 24 25 29 33 37 40 43 50 57 60 63 67 71 75 76 80 84 85 88 pctlpre=p;
%end;
%if &cases=1 %then %do;
proc univariate data=&data noprint;
where &event=1; var &x; output out=_p_ pctlpts=12 15 16 20 24 25 29 33 37 40 43 50 57 60 63 67 71 75 76 80 84 85
88 pctlpre=p;
%end; %end;
data _p_;
set _p_;
_z_=1;
if &k=3 and &equal=0 then put "Knots for &x =" p5 p50 p95;
else if &k=3 and &equal=1 then put "Knots for &x =" p25 p50 p75;
if &k=4 and &equal=0 then put "Knots for &x =" p5 p35 p65 p95;
else if &k=4 and &equal=1 then put "Knots for &x =" p20 p40 p60 p80;
if &k=5 and &equal=0 then put "Knots for &x =" p5 p28 p50 p73 p95;
else if &k=5 and &equal=1 then put "Knots for &x =" p16 p33 p50 p67 p84;
if &k=6 and &equal=0 then put "Knots for &x =" p5 p23 p41 p59 p77 p95;
else if &k=6 and &equal=1 then put "Knots for &x =" p15 p29 p43 p57 p71 p85;
if &k=7 and &equal=0 then put "Knots for &x =" p3 p18 p34 p50 p66 p82 p98;
else if &k=7 and &equal=1 then put "Knots for &x =" p12 p24 p37 p50 p63 p76 p88;
data &data;
merge &data _p_;
by _z_;
drop _z_;
data &data;
set &data;
%if &equal=0 %then %do;
%if &k=3 %then %do;
_&x=(max(0,&x-p5)**2-max(0,&x-p95)**2)/(p95-p5);
__&x=(max(0,&x-p50)**2-max(0,&x-p95)**2)/(p95-p5);
%end;
%else %if &k=4 %then %do;
_&x=(max(0,&x-p5)**2-max(0,&x-p95)**2)/(p95-p5);
__&x=(max(0,&x-p35)**2-max(0,&x-p95)**2)/(p95-p5);
___&x=(max(0,&x-p65)**2-max(0,&x-p95)**2)/(p95-p5);
%end;
%else %if &k=5 %then %do;
_&x=(max(0,&x-p5)**2-max(0,&x-p95)**2)/(p95-p5);
__&x=(max(0,&x-p28)**2-max(0,&x-p95)**2)/(p95-p5);
___&x=(max(0,&x-p50)**2-max(0,&x-p95)**2)/(p95-p5);
____&x=(max(0,&x-p73)**2-max(0,&x-p95)**2)/(p95-p5);
%end;
%else %if &k=6 %then %do;
_&x=(max(0,&x-p5)**2-max(0,&x-p95)**2)/(p95-p5);
__&x=(max(0,&x-p23)**2-max(0,&x-p95)**2)/(p95-p5);
___&x=(max(0,&x-p41)**2-max(0,&x-p95)**2)/(p95-p5);
____&x=(max(0,&x-p59)**2-max(0,&x-p95)**2)/(p95-p5);
_____&x=(max(0,&x-p77)**2-max(0,&x-p95)**2)/(p95-p5);
%end;
%else %if &k=7 %then %do;
_&x=(max(0,&x-p3)**2-max(0,&x-p98)**2)/(p98-p3);
__&x=(max(0,&x-p18)**2-max(0,&x-p98)**2)/(p98-p3);
___&x=(max(0,&x-p34)**2-max(0,&x-p98)**2)/(p98-p3);
____&x=(max(0,&x-p50)**2-max(0,&x-p98)**2)/(p98-p3);
_____&x=(max(0,&x-p66)**2-max(0,&x-p98)**2)/(p98-p3);
______&x=(max(0,&x-p82)**2-max(0,&x-p98)**2)/(p98-p3);
%end; %end;
%if &equal=1 %then %do;
%if &k=3 %then %do;
_&x=(max(0,&x-p25)**2-max(0,&x-p75)**2)/(p75-p25);
__&x=(max(0,&x-p50)**2-max(0,&x-p75)**2)/(p75-p25);
%end;
%else %if &k=4 %then %do;
_&x=(max(0,&x-p20)**2-max(0,&x-p80)**2)/(p80-p20);
__&x=(max(0,&x-p40)**2-max(0,&x-p80)**2)/(p80-p20);
___&x=(max(0,&x-p60)**2-max(0,&x-p80)**2)/(p80-p20);
%end;
%else %if &k=5 %then %do;
_&x=(max(0,&x-p16)**2-max(0,&x-p84)**2)/(p84-p16);
__&x=(max(0,&x-p33)**2-max(0,&x-p84)**2)/(p84-p16);
___&x=(max(0,&x-p50)**2-max(0,&x-p84)**2)/(p84-p16);
____&x=(max(0,&x-p67)**2-max(0,&x-p84)**2)/(p84-p16);
%end;
%else %if &k=6 %then %do;
_&x=(max(0,&x-p15)**2-max(0,&x-p85)**2)/(p85-p15);
__&x=(max(0,&x-p29)**2-max(0,&x-p85)**2)/(p85-p15);
___&x=(max(0,&x-p43)**2-max(0,&x-p85)**2)/(p85-p15);
____&x=(max(0,&x-p57)**2-max(0,&x-p85)**2)/(p85-p15);
_____&x=(max(0,&x-p71)**2-max(0,&x-p85)**2)/(p85-p15);
%end;
%else %if &k=7 %then %do;
_&x=(max(0,&x-p12)**2-max(0,&x-p88)**2)/(p88-p12);
__&x=(max(0,&x-p24)**2-max(0,&x-p88)**2)/(p88-p12);
___&x=(max(0,&x-p37)**2-max(0,&x-p88)**2)/(p88-p12);
____&x=(max(0,&x-p50)**2-max(0,&x-p88)**2)/(p88-p12);
_____&x=(max(0,&x-p63)**2-max(0,&x-p88)**2)/(p88-p12);
______&x=(max(0,&x-p76)**2-max(0,&x-p88)**2)/(p88-p12);
%end; %end;
drop p3 p5 p12 p15 p16 p18 p20 p23 p24 p25 p28 p29 p33 p34 p35 
p37 p40 p41 p43 p50 p57 p59 p60 p63 p65 p66
p67 p71 p73 p75 p76 p77 p80 p82 p84 p85 p88 p95 p98;
run; quit; run;
options notes;
%mend;

****We need to create a dataset with basis spline function using macro;
*Specify the continuous variable for which the spline basis functions 
are to be constructed (i.e., x); 
*Choose the number of knots (i.e., k), range of 3-7 was recommended;
*Specify whether the knot to be at an equal interval or 
not (1 is equal intervals);

%rqspline(data=work.cohort,x=baserbg2,event=outc2,k=3,equal=1,cases=1);

**Now dataset work.a contains spline basis functions for variable x as variables _x , 
with the number of leading underscores coincident with the number of the basis function
(i.e., if 4 knots are chosen then basis function variables _x, __x, and ___x are
returned)
*To fit any standard regression model with the restricted quadratic spline, the user must
include the original continuous variable as well as the basis function variables constructed by the
macro;

**Model 4. Fitting Cox model using restricted quadratic spline;
proc phreg data=work.cohort;
model timetooc*outc2(0)= baserbg2 _baserbg2 __baserbg2 / ties=efron rl;
output out=work.xbeta (keep=xbeta xbetase baserbg2) xbeta=xbeta STDXBETA=xbetase; run;	/*save predicted values for graphing*/
*Are the results different from above standard categorical model (Model-3)?


*PART 4. Plotting relative hazard of death as a function of baseline RBG;
proc sort data=work.xbeta; by baserbg2;
/*sort by independent variable for graphing*/
data work.rbgrhplot;
set work.xbeta;
xbetaul=xbeta+1.96*xbetase;		/*calculate upper limit of CI*/
xbetall=xbeta-1.96*xbetase;		/*calculate lower limit of CI*/
rh=exp(xbeta);
rhul=exp(xbetaul);				/*calculate upper limit of CI for relative hazard*/
rhll=exp(xbetall);				/*calculate upper limit of CI for relative hazard*/
run;

options nogstyle FONTRENDERING=HOST_PIXELS;
goptions reset=all;
filename grafout "C:\Users\asshah4\Downloads\figure2b.png";
goptions device=zpng target=png gsfname=grafout gsfmode=replace xmax=6 ymax=6 xpixels=3600 ypixels=3600;
axis1 color=black interval=even 
label=(angle=90 font=swiss h=2 "Relative hazard of death") w=2
major=(h=1 w=2) minor=none value=(font=swiss h=2) offset=(0,0);
axis2 color=black
label=(font=swiss h=2 justify=center "Baseline RBG mg/dl") w=2
major=(h=1 w=2) minor=none value=(font=swiss h=2) offset=(0,0);
symbol1 c=black l=1 w=3 h=.4 v=none i=stepjs;
symbol2 c=black l=2 w=2 h=.4 v=none i=stepjs;
symbol3 c=black l=2 w=2 h=.4 v=none i=stepjs;
footnote move=(30,42) font=swiss color=black h=2 "AIC=77604";
proc gplot data=work.rbgrhplot;
plot (rh rhul rhll)*baserbg2/overlay vaxis=axis1 haxis=axis2 noframe nolegend; run; quit; run;
footnote " "; run;



*Model 5. Adjusted model;
data work.cohort;
set work.cohort;
IF bmicat="9" THEN DELETE;
run;
proc phreg data=work.cohort;
class agecat;
model timetooc*outc2(0)= baserbg2 _baserbg2 __baserbg2 agecat / ties=efron rl;
run;
*According to model 5, what is the adjusted association between blood glucose level and hazard of death? 



