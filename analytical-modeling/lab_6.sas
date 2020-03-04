*--------------------------------------------------------------------------*
|TITLE: Lab 6                                                              |
|Estimation of risk ratios with regression                                 |
|                                                                          |
|                                                                          |
|DATE: February 26, 2020 Lab exercise (WITH NO ANSWERS)                    |
|                                                                          |
|DATASETS available on Canvas                                              |                                             
|  1. SAS dataset named 'TBSurv2'                                          |
|                                                                          |
|                                                                          |
|USER: Matthew Magee                                                       |
*--------------------------------------------------------------------------*

*Lab 6 contains three parts: 

Part 1. Estimating risk ratios with log binomial models
Part 2. Estimating risk ratios with robust Poisson models
Part 3. Comparing measures of association;



*Suppose your study goal is to assess the relationship 
between alcohol use
(the exposure) and risk of death (outcome);

*Another potential confounder is birthplace (covariate '_foreign') 
status ;




*****PART 1 ESTIMATING RISK RATIOS WITH LOG BINOMIAL REGRESSION;

*Bring in the TBsurv2 SAS dataset and perform a proc contents;
*TBsurv2 is the same as TBsurv from previous labs but includes an 
individual ID variable named 'idcode';

LIBNAME H 
	"C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";

PROC CONTENTS DATA = H.tbsurv2;
RUN;

*First estimate the relationship between 
alcohol use and risk of death;
*Start with proc freq;

PROC FREQ DATA = H.tbsurv2 ORDER = freq;
	TABLES death*alcohol / CMH;
RUN;

*What are the risks in the exposed, unexposed, 
and the crude risk ratio?
Risk of death among exposed (alcohol=1): 10.87%
Risk of death among unexposed (alcohol=0): 4.23%
Risk ratio: 2.57

*Can proc genmod reproduce these 2x2 table results?;

*First try to match the risk ratio from the 2x2 table using
proc genmod;

*Model 1.1;
PROC GENMOD DATA = H.tbsurv2;
	MODEL DEATH(event='1') = alcohol/DIST=binomial LINK=log;
	ESTIMATE 'RR for Death by ETOH' alcohol 1 / exp;
RUN;

*next determine the risk of death in the exposed, unexposed,
and the risk ratio for those with no alcohol use compared to those
who did use alcohol;

*Model 1.2;
PROC GENMOD DATA = H.tbsurv2;
	MODEL death(event='1') = alcohol / DIST = binomial LINK = log;
	ESTIMATE 'Risk for +ETOH' intercept 1 alcohol 1 / exp;
	ESTIMATE 'Risk for -ETOH' intercept 1 alcohol 0 / exp;
	ESTIMATE 'RR for Death +ETOH' alcohol 1 / exp;
	ESTIMATE 'RR for Death -ETOH' alcohol 0 / exp;
RUN;

*The overall risk of death in the cohort was relatively 'rare';


*Does the risk approximate the odds? - Yes by RARE DISEASE ASSUMPTION
Risk of death in entire cohort 0.054
Odds of death in entire cohort is 0.0571
;

*Does the odds ratio approximate the risk ratio? YES

*Calculate the crude odds ratio between alcohol and death two ways:
1. Using Proc logistic 
2. Using Proc genmod;

*Model 1.3;
PROC LOGISTIC DATA = H.tbsurv2;
	MODEL death(event='1') = alcohol; *logistic will auto make OR;
RUN;


*Model 1.4;
PROC GENMOD DATA = H.tbsurv2;
	* Link must be logit instead of log to get OR;
	MODEL death(event='1') = alcohol / DIST=binomial LINK=log;
	* Need to exp for OR;
	ESTIMATE 'OR for Death +ETOH' alcohol 1 / exp; 
RUN;

*Odds ratio from both models?:
- PROC LOGISTIC = 2.764
- PROC GENMOD = 2.573;



*Now obtain an adjusted risk ratio two ways
*Adjust for the potential confounder '_foreign'
1) Using MH procedures
2) Using proc genmod for log-binomial model
*Do the estimated adjusted RRs match?

*1) Using MH procedures (old school approach);

* For foreign = 1, OR = 2.244;
PROC FREQ DATA = H.tbsurv2;
	TABLE alcohol*death / CMH;
	WHERE _foreign = 1;
RUN;

* For foreign = 0, OR = 2.0483;
PROC FREQ DATA = H.tbsurv2;
	TABLE alcohol*death / CMH;
	WHERE _foreign = 0;
RUN;


*What is the risk ratio for death, 
comparing those with alcohol use to no alcohol use,
after adjusting for place of birth using MH methods?

[(1*308/336) + (14*331/441))] / [(5*28/336) + (22*110/441)]

MH = 1.935 (with adjustment for foreign birth);

*2) Using log binomial;
*Model 1.5;
PROC GENMOD DATA = H.tbsurv2;
	MODEL death(event='1') = alcohol _foreign / 
		DIST=binomial LINK=log;
	ESTIMATE 'RR for Death +ETOH' alcohol 1 / exp;
RUN;

*What is the risk ratio for death, 
comparing those with alcohol use to no alcohol use,
after adjusting for place of birth 
using log binomial regression?
- RR = 1.936;

*For extra fun, you can calculate the 95%CI using 
MH methods to see if they match the 
log binomial model;

*Last adjust the same death-alcohol model for
additional other covariates;
*Include covariates: age, sex, _foreign;
*Model 1.6;
PROC GENMOD DATA = H.tbsurv2;
	MODEL death(event='1') = alcohol age sex _foreign /
		DIST=binomial LINK=log;
	ESTIMATE 'RR for Death +ETOH' alcohol 1 / exp;
RUN;

*What is the risk ratio for death, comparing 
alcohol to no alcohol, adjusted for the 
covariates in Model 1.6?
- 0.3307... exponentiated = 1.39
- However, this model did not converge...

*****PART 2 ESTIMATING RISK RATIOS WITH ROBUST POISSON REGRESSION;

*First, use robust Poisson to obtain the crude risk 
ratio and 95%CI as done above in Model 1.1;

*Model 2.1;
PROC GENMOD DATA = H.tbsurv2;
	CLASS idcode; *need to have individual ID for robust poisson;
	MODEL death(event='1') = alcohol / DIST=poisson LINK=log;
	REPEATED SUBJECT = idcode; *Also needed to modify Poisson;
	ESTIMATE 'RR for Death +ETOH' alcohol 1 / EXP;
RUN;

*Crude Risk ratio and 95%CI in Model 1.1: 2.573
*Crude Risk ratio and 95%CI in Model 2.1: 2.573;

*Next, use robust Poisson to adjust for the covariate _foreign;
*Model 2.2;
PROC GENMOD DATA = H.tbsurv2;
	CLASS idcode; *Need individual ID for Poisson;
	MODEL death(event='1') = alcohol _foreign / DIST=poisson LINK=log;
	REPEATED SUBJECT=idcode; *also for mod poisson;
	ESTIMATE 'RR for Death +ETOH' alcohol 1 / exp;
RUN;

*Compare adjusted RR and 95% CI findings from Models 1.5 and 2.2:

*Model 1.5 results: 1.936
*Model 2.2 results: 1.938;

*Last, rerun the failed log binomial model (Model 1.6) 
using robust Poisson;
PROC GENMOD DATA = H.tbsurv2;
	CLASS idcode;
	MODEL death(event='1') = alcohol age sex _foreign /
		DIST=poisson LINK=log;
	REPEATED SUBJECT = idcode;
	ESTIMATE 'RR for Death +ETOH' alcohol 1 / EXP;
RUN;

*Does Model 2.3 converge? Yes
*What is the estimated adjusted risk ratio
for the effect of alcohol on death?
Adjusted risk ratio: 2.179;

*****PART 3. COMPARING MEASURES OF ASSOCIATION;

*Now compare the prevalence of cavitary disease (outcome) 
by sex (exposure);

*This is a relationship assessed at the baseline visit, 
so the measure of association of 
interest is the prevalence ratio;

PROC FREQ DATA = H.tbsurv2;
	TABLE cavitary*sex / RELRISK;
RUN;

*Overall prevalence is 0.241
*Prevalence ratio depends on the referent group. 
Choose men (sex=1) to be referent since the prevalence is lower;

*Base on proc freq, prevalence ratio should be 1.191;

*Estimate this measure of association using proc logistic (Model 3.1), 
log binomial (Model 3.2), and robust Poisson (Model 3.3);

*Model 3.1;
PROC LOGISTIC DATA = H.tbsurv2;
	MODEL cavitary(event='1') = sex;
RUN;

*Model 3.2;
PROC GENMOD DATA = H.tbsurv2;
	MODEL cavitary(event='1') = sex / DIST=binomial LINK=log;
	ESTIMATE 'RR for Cavitary' sex -1 / EXP;
RUN;

*Model 3.3;
PROC GENMOD DATA = H.tbsurv2;
	CLASS idcode;
	MODEL cavitary(event='1') = sex / DIST=poisson LINK=log;
	REPEATED SUBJECT = idcode;
	ESTIMATE 'RR for Cavitary' sex -1 / EXP;
RUN;

*Model 3.1: prevalence odds ratio 0.755 (reverse coded)
*Model 3.2: prevalence ratio 1.191
*Model 3.3: prevalence ratio 1.191
;
