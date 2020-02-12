
*--------------------------------------------------------------------------*
|TITLE: In Class Exercise 2                                                |
|Survival Curves     							                           |
|                                                                          |
|                                                                          |
|DATE: February 5th, 2020 in class exercise (WITH ANSWERS)                 |
|                                                                          |
|DATASETS available on Canvas                                              |                                             
|  1. SAS dataset named 'Vets'                                             |
|                                             							   |
|                                                                          |
|USER: Kieran Maroney                                                      |
*--------------------------------------------------------------------------*;

*Lab 2 contains 3 parts:

-Part 1 Kaplan-Meier Survival Curves
	-1.1 Creating Curves
	-1.2 Log-Rank Test
	-1.3 Calculating Survival Time for Specific time
	-1.4 Three way survival Curves
-Part 2 Cumulative Incidence Curve
	-Creating Curve
-Part 3 Adjusted Survival Curve
	-1.1 Obtain Mean values
	-1.2 Create new dataset
	-1.3 Create New Adjusted Survival Curve;


*First Load in the data;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling\";
RUN;

PROC CONTENTS DATA = H.vets;
RUN;

*Examine the Data layout for survival analysis layout 
Print Survival Time, Censoring and Exposure;
PROC PRINT DATA = H.vets;
	VAR survt status dd tx;
RUN;

*What variables would you need to conduct survival analysis?

*PART 1 Kaplan-Meier Survival Curves;

*Part 1.1 Creating the Survival Curve;

*Plot a survival curve examining death by treatment group;
PROC LIFETEST DATA = H.vets METHOD = km PLOTS = survival (TEST ATRISK);
	TIME survt*status(0);
	STRATA tx;
RUN;


*Which Group appears to have higher survival?
- THe test gropu seems to have survived... but hard to tell

*What is the median survival of each group? (estimate using graph)
Test - 50 days
Standard Treatment  - 120 days
;

*PART 1.2 Log-Rank Test
What is the null hypothesis of the Log-Rank Test?
H0: no difference between survival rates between groups

What is the chi-square value of the Log-Rank Test?
- 0.0082

What is the p-value of the Log-Rank Test?
- 0.9277

What is the is the interpretation?
- cannot reject null hypothesis

;
*-1.3 Calculating Survival Time for Specific time;

*Using the new timelist option, Examine the survival probability at 1 year (365 days);
proc lifetest data=h.vets timelist=??? plots=survival( test atrisk);
time survt * ???(0);
strata tx;
run;

*what is the survival probability for each group at one year (365 days)?
Test- 0.18
Standard - 0.14 


-Part 1.4 Three way survival Curve

*Create a 3-way survival curve by race;

*Plot 3-Way Survival Curves using Same Proc Lifetest;
PROC LIFETEST DATA = H.vets PLOTS = survival (TEST ATRISK);
	TIME survt*status(0);
	STRATA race;
RUN;

*-Part 2 Cumulative Incidence Curve;

*Plot the failures by treatment group (opposite of survival);
ODS GRAPHICS ON;
PROC LIFETEST DATA = H.vets METHOD = km PLOTS = survival(failure);
	TIME survt * status(0);
	STRATA tx;
RUN;
ODS GRAPHICS OFF;



*Did the Log-Rank test change when we examine failures instead of survival?
- No it did not

;

*-Part 3 Plotting Adjusted Survival Curves

What do we do if we believe that there are confounders in this relationship?
Ex. priortx age
- Can "adjust" for age
- Can also separate into strata


Part 3.1 Obtaining Mean Values;

*Calculate the Mean Values for Age and Priortx;
PROC MEANS DATA = H.vets;
	VAR age priortx;
RUN;

*Mean age? - 58.3
 Mean for priortx? 0.292
;

*Part 3.2 Create a New Dataset with Input datalines
for baseline characteristics;
DATA adjusted;
	INPUT age priortx;
	DATALINES; 
58.3 0.292
;
RUN;

* Check to see if it works;
PROC CONTENTS DATA = WORK.adjusted;
RUN;

*Part 3.3 Create Adjusted Survival Curves with last created dataset;
ODS GRAPHICS ON;
PROC PHREG DATA = H.vets PLOTS (OVERLAY = row) = survival;
	MODEL survt * status(0) = age priortx;
	STRATA tx;
	BASELINE COVARIATES = WORK.adjusted;
RUN;
ODS GRAPHICS OFF;


*What is the chi-squared value for the adjusted survival curve?
- There is no chai-square available for KM curves that are adjusted

*What is the p-value for the adjusted survival curve?
- Similarly no p-values can be interpreted for survival curve

Did the interpretation change after adjusting for prior treatment and age?
- cannot tell?

;
