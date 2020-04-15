*--------------------------------------------------------------------------*
|TITLE: Lab 10                                                             |
|Mediation analysis                                                        |
|                                                                          |
|                                                                          |
|DATE: April 15, 2020 Lab exercise (WITHout ANSWERS)                       |
|                                                                          |
|DATASETS available on Canvas                                              |                                             
|  1. SAS dataset named 'Mediation'                                        |
|                                                                          |
|                                                                          |
|USER: Matthew Magee                                                       |
*--------------------------------------------------------------------------*

****PART 1. Estimating direct and indirect effects 
using a difference approach;

****PART 2. Estimating direct and indirect effects 
using a product approach;

****PART 3. Estimating direct and indirect effects 
using Proc causalmed;


****PART 1. Estimating direct and indirect effects using a difference approach;

*First create a libname statement and download the dataset from Canvas;

LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";
RUN;

PROC CONTENTS DATA = H.mediation;
RUN;


*Assess distribution of key variables:

*Exposure (a) variable;
PROC FREQ DATA = H.mediation;
	TABLE smoke;
RUN;
*What proportion are smokers?  
23.7% are smokers;

*Mediator (m) variable;
PROC UNIVARIATE DATA = H.mediation;
	VAR bmi;
RUN;

*What is the median BMI? 
Median BMI is 27.7 kg/m^2;

*Outcome (Y) variable;
PROC UNIVARIATE DATA = H.mediation;
	VAR fbg;
RUN;

*What is the median FBG?
Median FBG = 102;


*Estimate the total effect of smoking on FBG, adjusting for age;
*Model 1.1;

PROC REG DATA = H.mediation;
	MODEL fbg = smoke age;
RUN;

*Is there a significant total effect? 
Yes, the F value is 37.35, with a P < .0001 for the whole model

*Parameter estimate: 
Smoking = 16.2 (P < .0001)
Age = 0.234 (p = 0.0007)

*Estimate the effct of smoking on BMI;
*Model 1.2;
PROC REG DATA = H.mediation;
	MODEL bmi = smoke;
RUN;

*Is there a significant effect of smoke on BMI? Yes (F 13.5, p = 0.0002)

*Parameter estimate:
Smoke = 1.80 (p = 0.0002)


*Another valid way to assess that there is an
association is to run a logistic model;
*This is less consistent with the temporal 
assumption that smoking impacts BMI;

*Model 1.3;
PROC LOGISTIC DATA = H.mediation;
	MODEL smoke(event='1') = bmi;
RUN;

*Next estimate the effect of BMI on FBG, without adjusting for smoke;
*Model 1.4;
PROC REG DATA = H.mediation;
	MODEL fbg = bmi;
RUN;

*This model confirms BMI is associated with FBG. 
Parameter estimate for BMI = 1.11 (p < 0.0001)

*This step is not technically necessary, why?
- When we run fbg ~ smoke + age + bmi, then BMI will be
adjusted for, thus not needed to do separately;

*Last estimate the effect of BMI on FBG, adjusting for smoke and age;
*Model 1.4;
PROC REG DATA = H.mediation;
	MODEL fbg = bmi smoke age;
RUN;

*Is BMI still significantly associted with FBG?
- Yes, it remains significant
- BMI = 0.99;

*Model 1.4 is also estimating the direct effect of SMOKE on FBG.
*Is SMOKE still significantly associated with FBG?
- Smoking is also associated with FBG
- Smoke = 14.3;

*Summarize the assessment of BMI as an indirect effect on the SMOKE-FBG relationship:

--Total effect= 16.2
--Direct effect= 14.3
--Indirect effect= 1.9
--Proportion explained= IE / TE = 11.7%

****PART 2. Estimating direct and indirect effects using a product approach;

*As indicated by VanderWeele the indirect effect 
can be calculated by using the 
product of parameter estimates from:

1) the mediator parameter estimate from the 'direct effect model'
(identical to Model 1.4) and 
2) the exposure parameter estimate from a model of the 
mediator as the outcome with the exposure 
and covariates as independent variables;

*Obtain the mediator parameter estimate from the 'direct effect model'
*Model 2.1;
PROC REG DATA = H.mediation; *note this is the same as 1.4;
	MODEL fbg = smoke bmi age;*but interest is now in the estimate for BMI;
RUN;

*Estimated parameter for mediator (BMI): 0.990;


*Obtain the exposure parameter estimate from a model of 
the mediator as the outcome with the exposure 
and covariates as independent variables;
*Model 2.2;
PROC REG DATA = H.mediation;
	MODEL bmi = smoke age;
RUN;

*Estimated parameter for exposure (SMOKE): 1.97

*last, calculate the product of the parameter estimates
- 1.97(smoking) X 0.990 (bmi) = 1.95;

*How do the estimated indirect effects compare 
between the difference and product approaches?
- THey are hte same, differences and product both = 1.9;

****PART 3. Estimating direct and indirect effects using Proc causalmed;

*Use proc causal med to estimate the indirect effects of BMI;
*Model 3.1;
PROC CAUSALMED DATA = H.mediation;
	MODEL fbg = smoke bmi;
	MEDIATOR bmi = smoke;
	COVAR age;
RUN;

*Do the results of proc causalmed match the difference/product methods?
- TE = 16.2
- DE = 14.3
- IE = 1.9
- Percent Mediation = 12%
- These values are very similar to the difference and product methods;

*Last, try estimating the indirect effect when the outcome is binary;
*Transform FBG into a dichotomous variable named FBGcat;
*make FBG dichtomous at >=140mg/dl;
DATA two;
	SET H.mediation;
	IF fbg >= 140 THEN fbgcat = 1;
	IF fbg <140 THEN fbgcat = 0;
RUN;

*Determine the proportion had fbg >=140?;
PROC FREQ DATA = two;
	TABLE fbgcat;
RUN;
*What proportion had fbg >=140?
- 10.2% had high sugars
- if the proportion is > 10%, may need different distribution 
(like Poisson or binomial, instead of logit)
- cannot use Product approach if it >10% proportion;

*Use the product method to obtain the indirect effect estimate 
with the binary FBG outcome;

*Product method;
*Obtain the mediator parameter estimate from the 'direct effect model'
*this now needs to be a logistic model;

*Model 3.2;
PROC LOGISTIC DATA = two;
	MODEL fbgcat(event='1') = smoke bmi age;
RUN;


*Mediator is BMI;
*BMI parameter estimate= 0.068 (not exponentiated);

*Obtain the exposure parameter estimate from a model of the mediator as the outcome 
with the exposure and covariates as independent variables (same as Model 2.2);
*Model 3.3;
PROC REG DATA = two;
	MODEL bmi = smoke age;
RUN;
*SMOKE parameter= 1.97;

*Product Approach calculation:
- 1.97(smoking) X 0.068 (bmi) = 0.134
- ID requires exponentiation... ID = 1.14;


**Finally, use proc causal med to obtain the same information as the product 
approach;

PROC CAUSALMED DATA = two DESCENDING; *indicate outcome as '1';
	MODEL fbgcat = smoke bmi / DIST = bin; *outcome is binary;
	MEDIATOR bmi = smoke;
	COVAR age;
RUN;

*Summarize the product and proc causalmed findings

Product approach IE = 1.14

With Causalmed procedure...
DE = 3.40
IE = 1.14
Percent mediate = 16.9%
;
