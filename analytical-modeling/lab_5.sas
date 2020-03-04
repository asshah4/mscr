*--------------------------------------------------------------------------*
|TITLE: Lab 5                                                              |
|Assessing Proportional Hazards Assumptions                                |
|                                                                          |
|                                                                          |
|DATE: February 19, 2020 Lab exercise (WITHOUT ANSWERS)                    |
|                                                                          |
|DATASETS available on Canvas                                              |                                             
|  1. SAS dataset named 'TBSurvival.sas7bdat                               |
|  2. Data dictionary in Excel 'TBSurvival.xlsx'                           |
|                                                                          |
|                                                                          |
|USER: Matthew Magee                                                       |
*--------------------------------------------------------------------------*

*Lab 5 contains four parts: 

Part 1. Assessing proportional hazards assumption with 
log-log survival curves
Part 2. Assessing proportional hazards assumption with 
goodness of fit tests
Part 3. Assessing proportional hazards assumption with 
time dependent covariates
Part 4. Conclusions and stratified procedures
;


*Suppose your study goal is to assess the relationship between place of birth 
(foreign born vs. US born, the exposure) and hazard rate of death (outcome);

*Another potential confounder is diabetes (covariate) status ;

*Assess the PH assumption for these two variables 3 ways;


*****PART 1 ASSESSING PH ASSUMPTION WITH LOG-LOG SURVIVAL CURVES;

*Bring in the TBsurv SAS dataset and perform a proc contents;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";

PROC CONTENTS DATA = H.tbsurv;
RUN;

ODS GRAPHICS ON;
*First estimate the relationship between foreign born a
nd risk of death and compare median 
survival in the two groups;

PROC FREQ DATA = H.tbsurv ORDER=freq;
	TABLE foreign*death / RELRISK RISKDIFF;
RUN;

*What is the crude risk ratio and risk difference?
Risk ratio: 3.46
Risk difference: 0.058 = 5.8%

*Interpretation:
- Having foreign=0 increases risk of death by 3.46, which is similar
risk diference of ~ 6%


*Over what time period was this risk assessed?
- over several years;

*Report medican survival time for the two groups: 
- 440 versus 143 (months);

*Median survival foreign born: 
- 238 days in foreigners;
PROC UNIVARIATE DATA = H.tbsurv;
	VAR survtime;
	WHERE foreign = 1;
RUN;


*Median survival US born: 
- 258 DAYS if US born;

PROC UNIVARIATE DATA = H.tbsurv;
	VAR survtime;
	WHERE foreign = 0;
RUN;


*Now  assess the relationship between place of birth and hazard of death
using KM curves and crude Cox HRs; 
PROC LIFETEST DATA = H.tbsurv METHOD=km PLOTS=(s);
	TIME survtime*death(0);
	STRATA foreign;
RUN;


*Model 1.1;
*Run a crude model to determine the HR ratio of 
death by foreign born status;
PROC PHREG DATA = H.tbsurv;
	MODEL survtime*death(0) = foreign / RL;
RUN;


*What is the interpretation of the crude HR ratio:
HR = 0.239 meaning foreigners have 1/4 event rate than that of USA births;

*use a class statement to make foreign born the referent;
*Model 1.2;
PROC PHREG DATA = H.tbsurv;
	CLASS foreign(ref='1');
	MODEL survtime*death(0) = foreign / RL;
RUN;

Proc phreg data=matt.tbsurv;
class ???????;
model survtime*death(0)=foreign/rl;
run;
*Now is the crude HR ratio comparable to the crude risk ratio?
- Crude Risk was ~ 3.4, and the HR is 4.2
- This is same direction, but relatively large difference;

*Next assess whether foreign born satisfies the proportional hazards model using 
log-log survival curves;
PROC LIFETEST DATA = H.tbsurv METHOD=km PLOTS=(lls, ls);
*LLS provides log-log with log(time) on x axis;
*LS provides log-log with time on x axis;
	TIME survtime*death(0);
	STRATA foreign;
RUN;

*Are log-log curves parallel? 
- Yes, for the most part. Hard to assess since there are so few
data points for foreign born;

*Next, assess the proportional hazards assumption 
separately for diabetes status using the curves;
PROC LIFETEST DATA = H.tbsurv METHOD=km PLOTS=(s, lls, ls);
	TIME survtime*death(0);
	STRATA dm;
RUN;

*Does DM variable satisfy the PH assumption graphically? 
- Not at all, crosses curves twice;

*How to test the PH assumption for 
both foreign born and dm status simultaneously?
*One option is to create a four-level categorical variable;

*Create a new variable for each of the four levels;
PROC FREQ DATA = H.tbsurv;
	TABLE dm*foreign;
RUN;

DATA fourlevel;
	SET H.tbsurv;
	IF dm = . THEN fdm = .; *Ignore missing;
	ELSE IF foreign=0 and dm=0 THEN fdm = 1; * US no sugs;
	ELSE IF foreign=0 and dm=1 THEN fdm = 2; * US sugs;
	ELSE IF foreign=1 and dm=0 THEN fdm = 3; * Foreign no sugs;
	ELSE IF foreign=1 and dm=1 THEN fdm = 4; * Foreign sugs;
RUN;


*did coding work?;
PROC FREQ DATA = fourlevel;
	TABLE fdm;
RUN;

*now examine the log-log survival curves with the four level variable;
PROC LIFETEST DATA = fourlevel METHOD=km PLOTS=(s, lls, ls);
	TIME survtime*death(0);
	STRATA fdm;
RUN;

*What is the interpretation
- FDM=1 (US/no DM) seems to be parallel with FDM=3 (foreign/no DM)
suggesting that not having DM seems to make folks have similar
risk category
- FDM=3 (foreign/DM) also is parallel to FDM=1 and FDM=4
- FDM=2 (US/DM) crosses both FDM=4 and FD=1
- Summary: FDM=2 (US/DM) breaks PH assumption
; 


*****PART 2 ASSESSING PH ASSUMPTION WITH GOODNESS OF FIT;

*Now test both foreign born status and diabetes variables 
using the goodness of fit approach;
*These lab 5 instructions follow closely the 
detailed explanation on pages 585 - 588 in 
Kleinbaum/Klein 3rd edition;
*Part 2 contains four steps:
	*Part 2.1 Produce residuals
	*Part 2.2 Limit data to those with the event (death)
	*Part 2.3 Rank failure times
	*Part 2.4 Determine the correlation between ranked event times and residuals;

*Part 2.1;
*First obtain Schoenfeld residuals from two crude Cox models and then from a model containing both;

*Crude with residuals for foreign;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign;
	*output dataset is named 'resid1' and 
	variable with residuals is 'rforeign';
	OUTPUT OUT=resid1 RESSCH=rforeign;
RUN;

PROC PRINT DATA = resid1;
RUN;


*Crude with residuals for diabetes;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = dm;
	OUTPUT OUT=resid2 RESSCH=rdm;
RUN;

PROC PRINT DATA = resid2;
RUN;

*Adjusted with residuals for both foreign and diabetes;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign dm;
	OUTPUT OUT = resid3 RESSCH = rforeign3 rdm3;
RUN;

PROC PRINT DATA = resid3;
RUN;

*Part 2.2;
*We are only interested in residuals for those who died;
*remove those who were censored from each dataset;

DATA events1;
*new dataset named 'events1' that contains all 
from resid1 but deletes censored observations;
	SET resid1;
	IF death = 1;
RUN;

* For resid2;
DATA events2;
	SET resid2;
	IF death = 1;
RUN;

* For resid3;
DATA events3;
	SET resid3;
	IF death = 1;
RUN;

PROC PRINT DATA = events3;
RUN;

*Part 2.3;
*Next rank the datasets (with events only created in 2.2) 
based on survival time;
PROC RANK DATA = events1 OUT = ranked1 TIES = mean;
*out=ranked1 creates a new database with survival time ranked;
	VAR survtime;
	*Name of the variable that contains the ranking is 'timerank1';
	RANKS timerank1;
RUN;

PROC PRINT DATA=ranked1;
RUN;

PROC RANK DATA = events2 OUT = ranked2 TIES = mean;
	VAR survtime;
	RANKS timerank2;
RUN;

PROC PRINT DATA = ranked2;
RUN;

PROC RANK DATA = events3 OUT = ranked3 TIES = mean;
	VAR survtime;
	RANKS timerank3;
RUN;

PROC PRINT DATA = ranked3;
RUN;


*Part 2.4;
*Last, use proc reg on each 'ranked' file to 
determine the correlation between the risiduals 
and the ranked event times;

*Foreign born;
PROC REG DATA = ranked1;
	MODEL timerank1 = rforeign;
RUN;
*What is the p-value for the foreign residuals? 
- 0.8336, PH okay ;

*Diabetes;
PROC REG DATA = ranked2;
	MODEL timerank2 = rdm;
RUN;
*What is the p-value for the diabetes residuals? 
- 0.0522, PH borderline;


*Results from model containing both foreign born and diabetes status;
PROC REG DATA = ranked3;
	MODEL timerank3 = rforeign3;
RUN;

PROC REG DATA = ranked3;
	MODEL timerank3 = rdm3;
RUN;
*Relavent P-values:
- Foreign: 0.8152, satisfies PH,
- DM: 0.0421, breaks PH;

*****PART 3 ASSESSING PH ASSUMPTION WITH TIME DEPENDENT COVARIATES;

*Now test both foreign born status and diabetes variables 
using an interaction term with time;
*try each with a crude model and then with a model 
containing both interaction terms;

*Using standard approach to interaction (the wrong way);
*Model 3.1;
PROC PHREG DATA = fourlevel;
	*this assumes time-independent;
	MODEL survtime*death(0) = foreign foreign*survtime;
RUN;

*creating interaction in data step (another wrong way);
DATA fourlevel;
	SET fourlevel;
	forsurv = foreign * survtime;
RUN;

*Model 3.2;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign forsurv / RL;
RUN;


*correct way using an extended Cox model;
*Model 3.3;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign fortime / RL;
	*this way SAS allows likelihood to be estimated 
	with time-dependency; 
	fortime = foreign * survtime;
RUN;
*Does foreign variable meet the PH 
assumption with the interaction term with time?
- foreign * survtime interaction term not significant, p = 0.3970
- foreign is not time dependent (and interaction term not needed)
;

*For diabetes;
*Model 3.4;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = dm dmtime / RL;
	dmtime = dm * survtime;
RUN;
*Does diabetes meet the PH assumption using the
interaction term approach?
-no, P val = 0.25
- PH not broken, dm * time not needed;

*Multivariable approach;
*Now assess PH with both interaction terms simulataneously ;
*Model 3.5;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign fortime dm dmtime / RL;
	dmtime = dm * survtime;
	fortime = foreign * survtime;
RUN;

*Do the interaction terms meet the PH assumption when both included?
- None of hte variables are significant
- the Interaction terms dmtime and fortime have p = 0.32 and 0.15 
- thus, time interaction is not significant
- PH is not violated;


*****PART 4 CONCLUSIONS AND STRATIFIED PROCEDURES; 

***Conclusions about PH assumption;

***Overall the variable 'foreign' satisfies the PH assumption
But two (Part 1 and Part 2) of three PH a
ssessments suggested diabetes variable does not meet PH assumption;


*What to do if conclusion is that DM does not satify PH assumption?
*Simplest option is stratafied model. 

*A stratifed Cox model does not allow for an 
hazard ratio estimate of the covariate included 
in the strata statement, but does adjust for it as a confounder;

*Compare three models to report the association 
between Foreign and hazard of death adjusting for 
diabetes status;
*4.1. Ignoring PH assumption for DM;
*4.2. Using extended Cox model;
*4.3. Using stratified Cox model; 

*Model 4.1;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign dm / RL;
RUN;

*What is the HR for the effect of foreign born in model 4.1? 
- p = 0.0016, HR 0.244;

*Model 4.2;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign dm fordm / RL;
	fordm = foreign * dm;
RUN;
*What is the HR for the effect of foreign born in model 4.2? 
- p = 0.0018, HR = 0.189;

*Model 4.3;
PROC PHREG DATA = fourlevel;
	MODEL survtime*death(0) = foreign / RL;
	STRATA dm;
RUN;

*What is the HR for the effect of foreign born in model 4.3? 
- p = 0.0017, HR = 0.247;

*All three models (4.1, 4.2, and 4.3) produce similar estimates. 
Likely OK to assume DM's violation of PH assumption
does not meaningfully impact the estimate of 
foreign on hazard of death;

*Caution: This conclusion may change with 
more covariates in the model; 
 

