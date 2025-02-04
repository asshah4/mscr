*--------------------------------------------------------------------------*
|TITLE: In Class Exercise 2                                                |
|LR tests, ordinal & nominal logistic regression                           |
|                                                                          |
|                                                                          |
|DATE: January 15, 2020 in class exercise (WITHOUT ANSWERS)                |
|                                                                          |
|DATASETS available on Canvas                                              |                                             
|  1. SAS dataset named 'TBantigen'                                        |
|  2. SAS dataset named 'EPTB'                                             |
|                                                                          |
|USER: Matthew Magee                                                       |
*--------------------------------------------------------------------------*
;
*Lab 2 contains 3 parts:

-Part 1 Likelihood ratio tests
-Part 2 Nominal logistic regression
 -2.1 Simple nominal logistic regression
 -2.2 Mini sensitivity analysis
-Part 3 Ordinal logistic regression
;

******************************************PART 1 LIKELIHOOD RATIO TESTS;
*Before starting, use a libname statement to bring in the two SAS datasets;

*For lab sessions, it is generally easiest to save 
the datasets and libname to the desktop;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling\";


*Check that the datasets were read in correctly;
PROC CONTENTS DATA = H.tbantigen;
RUN;
PROC CONTENTS DATA = H.eptb;
RUN;

*Practice performing a likelihood ratio test;
*For Part 1 of Lab 2 use the TBantigen dataset;
*First perform an unadjusted logistic model for the 
association between gender (riagendr) 
and LTBI result (lbxtbin);

*Model 1.1;
PROC LOGISTIC DATA = H.tbantigen;
	MODEL lbxtbin = riagendr;
RUN;

*What is the interpretation of the OR in model 1.1?
- OR is 0.690, which suggests that by being a male (or whatever 
is coded for 1 for gender), has a reduced OR of 0.690 for having
a positive LTBI result;

*What is the Wald chi-squre p-value for gender? 
- Chi square is 15.53, with a p value < 0.0001;

*What is the -2 ln likelihood for the full model? 3298
*What is the -2 ln likelihood for the reduced model? 3282

*What is the likelihood ratio? 15.70;

*What is the Likelihood ratio p-value? <0.0001.

*The results from model 1.1 should match the chi-square value reported 
from a 2x2 table?
- It does, its exactly the same;
PROC FREQ DATA = H.tbantigen;
	TABLE lbxtbin * riagendr/chisq;
RUN;

*Next, perform model 1.2 to estimate the adjusted association between 
diabetes status (a three level exposure)and LTBI, adjusted for age and gender; 

*Evaluate the statistical significance of the 
association between diabetes and pre-diabetes 
(overall) with the outcome of LTBI;

*Model 1.2;
PROC LOGISTIC DATA = H.tbantigen;
	CLASS dm (param=ref ref='0');
	MODEL lbxtbin (event='1') = dm riagendr ridageyr; * full model;
RUN;

*Model 1.3;
PROC LOGISTIC DATA = H.tbantigen;
	MODEL lbxtbin(event='1') = riagendr ridageyr; * This is reduced in comparison;
RUN;

*What is the null hypothesis of interest?
- is diabetes a preictor of positive LBTI, H0: beta of DM = 0;

*What is the wald chi-square p-value for the above null hypothesis?
-Wald Pvalue < 0.0001;

*What is the likelihood ratio p-value?
- Pvalue < 0.0001;

*Must compare model 1.2 to model 1.3. 
-2ln likelihood Full: 3168.65
-2ln likelihood Reduced: 3177.66
likelihood ratio= ~9.0, which approximates the chi-square
DF is the difference between number of parameters between full and reduced
In this case, it is 2 (because there are 2 levels of diabetes that are tested;



 

********************************************PART 2 NOMINAL LOGISTIC REGRESSION;

*****PART 2.1 Simple nominal logistic regression;

*Practice running a nominal logistic model using the EPTB database;
*For simplicity sake, categorize site of disease 
as a three-level nominal variable;
*Use a data step and create a new outcome variable called "xpsite_nom"
*First explore the distribution of xpsite;
PROC FREQ DATA = H.eptb;
	TABLE xpsite;
RUN;

PROC PRINT DATA = H.eptb LABEL;
	VAR xpsite;
RUN;

PROC CONTENTS DATA = H.eptb;
RUN;

*Although "xpsite_nom" will be a nomial categorical variable,
use numeric values for simplicity;

*to make 3 categories with some discrete types, I chose the three levels as
0-Lymphatic
1-CNS/men
2-Others
;

DATA two;
	SET H.eptb;
	IF xpsite = . THEN xpsite_nom = .; * the dot is a missing value in SAS for #;
	ELSE IF xpsite = 5 THEN xpsite_nom = 0; *Lymph;
	ELSE IF xpsite = 2 THEN xpsite_nom = 1; * CNS;
	ELSE xpsite_nom = 2; * all others;
RUN;

*check that recoding worked;
PROC FREQ DATA = two;
	TABLE xpsite * xpsite_nom;
RUN;

**Run a simple nominal logistic model with just 'homeless' 
as the exposure variable;

*First check distribution of homeless;
PROC FREQ DATA = two;
	TABLE homeless;
RUN;

*there are 16 with missing values on homeless;

*first try the simple nominal model by ignoring the missing in homeless;
*Model 2.1;
PROC LOGISTIC DATA = two;
	CLASS homeless (param=ref ref='0');
	MODEL xpsite_nom (ref='2') = homeless /LINK=glogit;
RUN;                                             

*Check the log and review the model 2.1 details;
*How many parameters do you expect? 
- I would expect two intercepts for hte two levels
*How many observations were used? 
- I would expect it be 16 less due to missingness, used was 279
*How can you explain the difference between "read" and "used" observations? 
- missing data was deleted;

 
***What is the interpretation of the ORs from model 2.1?
- being homeless leads to 0.621 OR for lymph location
- being homeless leads to increased risk of 1.406 OR for CNS location;

*Can the model 2.1 result be recreated by hand using a frequency table?
- I'm not sure if this works or not, as this gets an OR ;
PROC FREQ DATA = two;
	TABLE xpsite_nom * homeless/CHISQ;
RUN;

*Really nominal logistic regression is multiple (separate) 
binary logistic regressions all at once;
*Create a new temporary dataset named 'three' 
and within it code a new variable 'cnsother';
*The variable 'CNSother' should be a dichotomous variable
that re-creates the CNS vs. other comparison 
from the 3 level xpsite_nom variable;
DATA three;
	SET two;
	IF xpsite_nom = 1 THEN cnsother = 1; *for CNS location;
	ELSE IF xpsite_nom = 2 THEN cnsother = 0; * for other location;
	ELSE cnsother = .; *this should remove those with 
	lymph locations;
RUN;

*Check the coding worked and compare it to the frequency table of xpsite_nom;
PROC FREQ DATA = three;
	TABLE cnsother * homeless/CMH;
RUN;
* This gets us to an OR by CMH of 1.406;

*Now run the binary logistic model that is the equivalent 
of the  cns  vs. other comparison 
from the nominal logistic model;
*Model 2.2;
PROC LOGISTIC DATA = three;
	CLASS homeless (param=ref ref='0');
	MODEL cnsother (event='1') = homeless;
RUN;

* This has an OR of 1.406, which matches the xpsite_nom regression model
This happens to just be a normal/simple logistic regression;

*****PART 2.2 Mini sensitivity analysis;

*Rerun the nominal model with three different ways 
of handling the missing in homeless;
DATA three;
	SET two;
*code a separate level for missing;
	IF homeless = . THEN homeless_level = 2;
	ELSE IF homeless = 1 THEN homeless_level = 1;
	ELSE IF homeless = 0 THEN homeless_level = 0;

*assume missing were not homeless;
	IF homeless = . THEN homeless_not = 0;
	ELSE IF homeless = 1 THEN homeless_not = 1;
	ELSE IF homeless = 0 THEN homeless_not = 0;

*assume missing were homeless;
	IF homeless = . THEN homeless_really = 1;
	ELSE IF homeless = 1 THEN homeless_really = 1;
	ELSE IF homeless = 0 THEN homeless_really = 0;

RUN;

*Check that new coding worked;
PROC PRINT DATA = three;
	VAR homeless homeless_level homeless_not homeless_really;
	WHERE homeless = .;
RUN;

PROC FREQ DATA = three;
	TABLE homeless_really;
RUN;

*Does the different treatment of missing homeless matter?
Rerun the simple nominal LR with the 3 different 
homeless variables..

- As seen, the OR for +homeless and +CNS xpsite
for how we are managing missingness
- for separating out missing, then OR = 1.406
- for missing being "not homeless", then OR = 1.493
- for missing being "really homeless", then OR = 1.005
;

*now a class statment is needed for homeless_level;
*Model 2.3;
PROC LOGISTIC DATA = three;
	CLASS homeless_level(PARAM=ref REF='0');
	MODEL xpsite_nom(REF='2')=homeless_level/LINK=glogit;
RUN; *Results not particularly significant;

PROC LOGISTIC DATA = three;
	CLASS homeless_not(PARAM=ref REF='0');
	MODEL xpsite_nom(REF='2')=homeless_not/LINK=glogit;
RUN; *Results not particularly significant;

PROC LOGISTIC DATA = three;
	CLASS homeless_really(PARAM=ref REF='0');
	MODEL xpsite_nom(REF='2')=homeless_really/LINK=glogit;
RUN; *Results not particularly significant;

*If those who had missing information on homelessness
were all infact truly homeless (model 2.5), 
the bias is substantial;

**Perform a nominal logistic model (2.6) with 
lymphatic as the referent outcome group and 
adjust for HIV status and biologic sex;

*Try the model with the different categories of
homeless missing. 

If you could only chose one, which model results 
would you chose to report?;

*Model 2.6;
PROC LOGISTIC DATA = three;
	CLASS homeless (REF='0');
	MODEL xpsite_nom(REF='0') 
		= homeless HIV gen / LINK=glogit;
RUN;

*Model 2.7;
PROC LOGISTIC DATA = three;
	CLASS homeless_not (REF='0');
	MODEL xpsite_nom(REF='0')
		= homeless_not HIV gen / LINK=glogit;
RUN;

*Model 2.8;
PROC LOGISTIC DATA = three;
	CLASS homeless_really (REF='0');
	MODEL xpsite_nom(REF='0') 
		= homeless_really HIV gen / LINK=glogit;
RUN;


*************PART 3 ORDINAL LOGISTIC REGRESSION;

*For PART 3 use the SAS dataset named 'TBantigen';

*First create a new temporary dataset to do the following: 

	*1. limit the ordinal analysis (PART 3) 
		to those with latent TB (LBXTBIN=1);

	*2. create a new categorical variable for 
		TB antigen response that is a 3-level 
		ordinal variable, call it 'antord';

*Determine the distribution of antigen response 
among those with LTBI;
PROC FREQ DATA = H.tbantigen;
	TABLE lbxtba;
	WHERE lbxtbin = 1;
RUN;

*For simplicity, choose cut points at 
the 33rd and 66th percentiles;
*recall that categorical variables can be 
numeric in SAS (don't need to be characters);

DATA four;
	SET H.tbantigen;
	*Remove non-LTBI;
	IF lbxtbin ^= 1 THEN DELETE; 
	*Make ordinal variable "antord";
	* Low <= 1.1 ~ 33%;
	* Mid <= 4.5 ~ 66%;
	* High > 4.5;
	IF lbxtba <= 1.1 THEN antord=0; 
	ELSE IF lbxtba > 1.1 AND lbxtba <= 4.5 THEN antord=1;
	ELSE IF lbxtba > 4.5 THEN antord=2;
RUN;

*Check that ordinal variable is correct;
*proc sort is useful to run before proc print 
(and necessary when merging datasets);
PROC SORT DATA = four;
	BY lbxtba;
RUN;

PROC PRINT DATA = four;
	VAR lbxtba antord;
RUN;

PROC FREQ DATA = four;
	TABLE antord;
RUN;

*Ok, TB antigen now is now categorical, ordinal, numeric, 
in 3 equal groups. 
*Equal numbers in groups is NOT necessary for 
ordinal logistic regresion;

*Next run a simple ordinal logistic regression 
with antord as the outcome and DM as the exposure;
*Model 3.1;
PROC LOGISTIC DATA = four;
	MODEL antord = dm;
RUN;

****Review Model 3.1 output;
*What type of model was used?
- Ordinal regression;

*Were the odds proportional? 
- Yes, score test couldnt provide evidence against 
proportional odds;

*What is the interpretation of the OR?
- OR = 0.889... decreased chance of high antigen c- DM??;

**Next rerun the model 3.1 with 'DM' in the class statement;
*Also use the descending option to change the order of 
the odds comparisons (odds of high vs. med/low);

*Model 3.2;
PROC LOGISTIC DATA = four DESCENDING;
	CLASS dm (REF='0');
	MODEL antord = dm;
RUN;
*Is the proportional odds assumption still met 
in model 3.2?
- Yes, Score test cannot prove odds are not proportional;

*Now what is the interpretation of the ORs after 
using the class statement for DM and the descending option?
- Low or medium antigen has OR of 1.291 if pt has preDM 
versus no DM
- Low or medium antigen has OR of 1.227 if pt has DM versus
no DM;
***There are four (or more) interpretations;



*Can these ORs from model 3.2 be generated 
by a frequency table?
- Yes they can be, by doing odds by collapsing the strata;
PROC FREQ DATA = four;
	TABLE antord * dm;
RUN;

***Odds of high antigen vs. med/low response;
*????;

***Odds of high/medium antigen vs. low response;
*?????

*Take average (or weighted strata) of two ORs: ????;



*Try rerunning the ordinal model  3.2 without 
the descending option;
*Recalculate the pre-DM OR estimate by 
hand from the frequency table;

*Model 3.3;
PROC LOGISTIC DATA = four;
	CLASS dm (REF='0');
	MODEL antord = dm;
RUN;

PROC FREQ DATA = four;
	TABLE antord * dm;
RUN;

*Last, perform a multivariable ordinal logistic 
model for higher antigen response;
*Adjust the model for age, sex, and vitamin d status;
 
*Model 3.4;
PROC LOGISTIC DATA = four DESCENDING;
	CLASS dm (REF='0') vitdcat2 (REF='0');
	MODEL antord = dm ridageyr riagendr vitdcat2;
RUN;

*Were all the observations used in model 3.4?
- Yes;

*Was the proportional odds assumption met?
- not enough evidence to reject the null = proportional;

*What is the interpretation of the DM and preDM ORs?
- PreDM OR = 1.240
- DM OR = 1.129;



****End of Lab 2;
