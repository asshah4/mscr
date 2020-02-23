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

Part 1. Assessing proportional hazards assumption with log-log survival curves
Part 2. Assessing proportional hazards assumption with goodness of fit tests
Part 3. Assessing proportional hazards assumption with time dependent covariates
Part 4. Conclusions and stratified procedures
;


*Suppose your study goal is to assess the relationship between place of birth 
(foreign born vs. US born, the exposure) and hazard rate of death (outcome);

*Another potential confounder is diabetes (covariate) status ;

*Assess the PH assumption for these two variables 3 ways;


*****PART 1 ASSESSING PH ASSUMPTION WITH LOG-LOG SURVIVAL CURVES;

*Bring in the TBsurv SAS dataset and perform a proc contents;

libname matt 'C:\Users\mjmagee\Desktop';
run;
proc contents data=matt.tbsurv;
run;
ods graphics on;

*First estimate the relationship between foreign born and risk of death and compare median 
survival in the two groups;

Proc freq data=matt.tbsurv order=freq;
table foreign*death/relrisk riskdiff;
run;
*What is the crude risk ratio and risk difference?
Risk ratio: 
Risk difference:

*Interpretation ?:


*Over what time period was this risk assessed?
*Report medican survival time for the two groups:
*Median survival foreign born: 
*Median survival US born: 


*Now  assess the relationship between place of birth and hazard of death
using KM curves and crude Cox HRs;
proc lifetest data=matt.tbsurv method=km plots=(s);
time survtime*death(0);
strata foreign;
run;

*Model 1.1;
*Run a crude model to determine the HR ratio of death by foreign born status:;
Proc phreg data=matt.tbsurv;
model ??????????????;
run;
*What is the interpretation of the crude HR ratio ?:
;

*use a class statement to make foreign born the referent;
*Model 1.2;
Proc phreg data=matt.tbsurv;
class ???????;
model survtime*death(0)=foreign/rl;
run;
*Now is the crude HR ratio comparable to the crude risk ratio?;

*Next assess whether foreign born satisfies the proportional hazards model using 
log-log survival curves;
proc lifetest data=matt.tbsurv method=km plots=(lls, ls);
                                  *LLS provides log-log with log(time) on x axis;
                                  *LS provides log-log with time on x axis;
time survtime*death(0);
strata foreign;
run;
*Are log-log curves parallel? ;

*Next, assess the proportional hazards assumption separately for diabetes status using the 
curves;
proc lifetest data=matt.tbsurv method=km plots=(?????); *Request all curves;
time survtime*death(0);
strata ??????;
run;
*Does DM variable satisfy the PH assumption graphically? ;

*How to test the PH assumption for both foreign born and dm status simultaneously?
*One option is to create a four-level categorical variable;

*Create a new variable for each of the four levels;
proc freq data=matt.tbsurv;
table dm*foreign;
run;

data two;
set matt.tbsurv;
if dm=. then fdm=.; *you can ignore missing for this example;
else if foreign=0 and dm=? then fdm=?; *US born no DM;
else if foreign=0 and dm=? then fdm=?; *US born DM;
else if foreign=1 and dm=? then fdm=?; *Foreign born no DM;
else if foreign=1 and dm=? then fdm=?; *Foreign born DM;
run;

*did coding work?;
Proc freq data=two;
table fdm;
run;

*now examine the log-log survival curves with the four level variable;
proc lifetest data=two method=km plots=(s, lls, ls); *Request all curves;
time survtime*death(0);
strata ?????;
run;
*What is the interpretation;
*; 


*****PART 2 ASSESSING PH ASSUMPTION WITH GOODNESS OF FIT;

*Now test both foreign born status and diabetes variables using the goodness of fit approach;
*These lab 5 instructions follow closely the detailed explanation on pages 585 - 588 in Kleinbaum/Klein 3rd edition;
*Part 2 contains four steps:
	*Part 2.1 Produce residuals
	*Part 2.2 Limit data to those with the event (death)
	*Part 2.3 Rank failure times
	*Part 2.4 Determine the correlation between ranked event times and residuals;

*Part 2.1;
*First obtain Schoenfeld residuals from two crude Cox models and then from a model containing both;

*Crude with residuals for foreign;
proc phreg data=two;
model survtime*death(0)=foreign;
output out=resid1 ressch=rforeign; *output dataset is named 'resid1' and varialbe with residuals is 'rforeign';
run;
proc print data=resid1;
run;
*Crude with residuals for diabetes;
proc phreg data=two;
model survtime*death(0)=dm;
output out=resid2 ressch=rdm;
run;
proc print data=resid2;
run;
*Adjusted with residuals for both foreign and diabetes;
proc phreg data=two;
model survtime*death(0)=foreign dm;
output out=resid3 ressch=rforeign3 rdm3;
run;
proc print data=resid3;
run;

*Part 2.2;
*We are only interested in residuals for those who died;
*remove those who were censored from each dataset;

data events1; *new dataset named 'events1' that contains all from resid1 but deletes censored observations;
set resid1;
if death=1;
run;

data events2;
set resid2;
if death=1;
run;

data events3;
set resid3;
if death=1;
run;

proc print data=events3;
run;

*Part 2.3;
*Next rank the datasets (with events only created in 2.2) based on survival time;

proc rank data=events1 out=ranked1 ties=mean; *out=ranked1 creates a new database with survival time ranked;
var survtime; 
ranks timerank1; *Name of the variable that contains the ranking is 'timerank1';
run;
proc print data=ranked1;
run;

proc rank data=events2 out=ranked2 ties=mean;
var survtime;
ranks timerank2;
run;
proc print data=ranked2;
run;

proc rank data=events3 out=ranked3 ties=mean;
var survtime;
ranks timerank3;
run;
proc print data=ranked3;
run;

*Part 2.4;
*Last, use proc reg on each 'ranked' file to determine the correlation between the risiduals 
and the ranked event times;

*Foreign born;
proc reg data=ranked1;
model timerank1=rforeign;
run;
*What is the p-value for the foreign residuals? ;

*Diabetes;
proc reg data=ranked2;
model timerank2=????;
run;
*What is the p-value for the diabetes residuals? ;


*Results from model containing both foreign born and diabetes status;
proc reg data=ranked3;
model timerank3=????;
run;
proc reg data=ranked3;
model timerank3=?????;
run;
*Relavent P-values: Foreign: ?, DM: ?;

*****PART 3 ASSESSING PH ASSUMPTION WITH TIME DEPENDENT COVARIATES;

*Now test both foreign born status and diabetes variables using an interaction term with time;
*try each with a crude model and then with a model containing both interaction terms;

*Using standard approach to interaction (the wrong way);
*Model 3.1;
proc phreg data=two;
model survtime*death(0)=foreign foreign*survtime; *this assumes time-independent;
run;

*creating interaction in data step (another wrong way);
data three;
set two;
fortime2=foreign*survtime; *this also assumes time-independent;
run;
*Model 3.2;
proc phreg data=three;
model survtime*death(0)=foreign fortime2/rl;
run;

*correct way using an extended Cox model;
*Model 3.3;
proc phreg data=two;
model survtime*death(0)=foreign fortime/rl;
fortime=foreign*survtime; *this way SAS allows likelihood to be estimated with time-dependency; 
run;
*Does foreign variable meet the PH assumption with the interaction term with time?
;

*For diabetes;
*Model 3.4;
proc phreg data=two;
model survtime*death(0)=?????/rl;
??????;
run;
*Does diabetes meet the PH assumption using the interaction term approach?
-?;

*Multivariable approach;
*Now assess PH with both interaction terms simulataneously ;
*Model 3.5;
proc phreg data=two;
model survtime*death(0)=foreign fortime dm dmtime/rl;
dmtime=??????;
fortime=?????;
run;
*Do the interaction terms meet the PH assumption when both included?
?


*****PART 4 CONCLUSIONS AND STRATIFIED PROCEDURES; 

***Conclusions about PH assumption;

***Overall the variable 'foreign' satisfies the PH assumption
But two (Part 1 and Part 2) of three PH assessments suggested diabetes variable does not meet PH assumption;


*What to do if conclusion is that DM does not satify PH assumption?
*Simplest option is stratafied model. 

*A stratifed Cox model does not allow for an hazard ratio estimate of the covariate included 
in the strata statement, but does adjust for it as a confounder;

*Compare three models to report the association between Foreign and hazard of death adjusting for 
diabetes status;
*4.1. Ignoring PH assumption for DM;
*4.2. Using extended Cox model;
*4.3. Using stratified Cox model; 

*Model 4.1;
proc phreg data=two;
model survtime*death(0)=?????/rl;
run;
*What is the HR for the effect of foreign born in model 4.1? ;

*Model 4.2;
proc phreg data=two;
model survtime*death(0)= ??????/rl;
dmtime=dm*survtime;
run;
*What is the HR for the effect of foreign born in model 4.2? ;

*Model 4.3;
proc phreg data=two;
model survtime*death(0)=????/rl;
strata ?;
run;
*What is the HR for the effect of foreign born in model 4.3? ;
 

