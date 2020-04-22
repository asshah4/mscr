*****************************************************************************
*****************************************************************************
Lab 7:  Poisson regression

Date: March 25, 2020  
Datasets: NHSS2018, behavsurv
Programmer: Johanna Chapin Bardales          

Notes: 
1. NHSS2018 is modified dataset of NHSS data from 2018. It is 
limited to White, Hispanic/Latino, Black/African American persons
and states that had sufficient data for analysis of rates. States
excluded due to missing or small case/rate data were:
New Hampshire, American Samoa, Guam, N. Mariana Islands, 
US Virgin Islands, and Puerto Rico. HIV data for the year 2018 were
preliminary and based on 6 months reporting delay. Available at NCHHSTP
AtlasPlus: https://www.cdc.gov/nchhstp/atlas/index.htm.
2. behavsurv is a dummy dataset of typical behavioral surveillance data 
among MSM for a given data collection cycle. Data were generated and 
not collected from real persons. 
*****************************************************************************
*****************************************************************************

*Lab 7 contains two parts: 

Part 1. Estimating rates and rate ratios with Poisson models
Part 2. Estimating prevalence ratios with robust Poisson (e.g., Poisson GEE) 
        models and comparison to other methods


*****************************************************************************
	PART 1: ESTIMATING RATES AND RATE RATIOS WITH POISSON REGRESSION
*****************************************************************************;

*** Research question ***
What were the regional disparities in HIV rates in the US in 2018?
 
*** Other covariates of interest ***
Race/ethnicity (race) and age (age)


*1. Call in the NHSS2018 SAS dataset and perform a proc contents;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";
RUN;

PROC CONTENTS DATA = H.nhss2018;
RUN;

*2. Create working data to create additional variables;
DATA two;
	SET H.nhss2018;

	* Create offset variable for Poisson;
	ln_popsize = log(popsize);

	* Create indicator variable for South region;
	IF region = "South" THEN south = 1;
	ELSE IF region in ("Northeast", "West", "Midwest") THEN south = 0;
	ELSE south = .;
RUN;

PROC CONTENTS DATA = two;
RUN;


*3. Examine research question;

*Let's examine the rates by region;
*Model 1.1;
PROC GENMOD DATA = two;
	CLASS region(ref = "Northeast") / PARAM = ref;
	*note offset=ln_popsize;
	MODEL cases = region / LINK = log DIST = poisson OFFSET = ln_popsize;
	*note that adding intercept in estimate statement gets you rates;
	ESTIMATE 'Rate for Northeast' intercept 1 / EXP;
	*note output: design variables give info on how to construct 
	estimate statements;
	ESTIMATE "Rate for Midwest" intercept 1 region 1 / EXP;
	ESTIMATE "Rate for South" 	intercept 1 region 0 1 / EXP;
	ESTIMATE "Rate for West" 	intercept 1 region 0 0 1 / EXP;
RUN;

*Try to match the rate ratio from the 2x2 table comparing South to Northeast;
*Model 1.2;
PROC GENMOD DATA = two;
	CLASS region(ref = "Northeast") / PARAM = ref;
	MODEL cases = region / LINK = log DIST = poisson OFFSET = ln_popsize;
	ESTIMATE "Rate Ratio Comparsing South v Northeast" region 0 1 / EXP;
RUN;
* RR of 1.6;

*Try comparing South to all non-South regions;
*Model 1.3;
PROC GENMOD DATA = two;
	CLASS south(ref = "0") / PARAM = ref;
	MODEL cases = south / LINK=log DIST=poisson OFFSET=ln_popsize;
	ESTIMATE "Rate Ratio for South vs. All Other Regions" south 1 / EXP;
RUN;
* RR of 1.8;

*Examine racial-ethnic disparities and age disparities in HIV rates;
*Model 1.4;
PROC GENMOD DATA = two;
	CLASS race(ref = "White") / PARAM = ref;
	MODEL cases = race / LINK=log DIST=poisson OFFSET=ln_popsize;
	ESTIMATE "Rate Ratio for Black v. White" race 1 / EXP;
	ESTIMATE "Rate Ratio for Hispanic v. White" race 0 1 / EXP;
RUN;
* Black = 8.5, Hispanic = 3.7;

*Model 1.5;
PROC GENMOD DATA = two;
	CLASS age(ref = "35-44") / PARAM = ref;
	MODEL cases = age / LINK=log DIST=poisson OFFSET=ln_popsize;
	ESTIMATE "Rate ratio comparing 13-24 v 35-44" age 1 / EXP;
	ESTIMATE "Rate ratio comparing 25-34 v 35-44" age 0 1 / EXP;
	ESTIMATE "Rate ratio comparing 45-54 v 35-44" age 0 0 1 / EXP;
	ESTIMATE "Rate ratio comparing 55+++ v 35-44" age 0 0 0 1 / EXP;
RUN;
* 
13-24 = 0.9
25-34 = 1.7
45-54 = 0.7
55+   = 0.2
;


*Try comparing South to all non-South regions adjusting for race and age;
*Model 1.6;
PROC GENMOD DATA = two;
	CLASS south(ref="0") race(ref="White") age(ref="35-44") / PARAM=ref;
	MODEL cases = south race age / LINK=log DIST=poisson OFFSET=ln_popsize;
	Estimate "Adj Rate Ratio Comparing South v Other Regions" south 1 / EXP;
RUN;
*Adj for age and race = 1.34;



****************************************************************************
PART 2:  PREVALENCE RATIO USING POISSON REGRESSION WITH GEE (ROBUST POISSON)
****************************************************************************;

*** Research question ***
What is the association between age and PrEP use among MSM in 2020?
 
*** Other potential confounders ***
Race/ethnicity (race), city (city) ;


*1. Perform a proc contents;
PROC CONTENTS DATA = H.behavsurv;
RUN;

*2. Examine research question;

*Let's examine the unadjusted association between age and PrEP
use using Poisson GEE model (PR);
*Model 2.1;
PROC GENMOD DATA = H.behavsurv;
	CLASS age(ref="30+") studyid / PARAM=ref;
	MODEL prep = age / LINK=log DIST=poisson;
	REPEATED SUBJECT = studyid / TYPE = IND;
	ESTIMATE "PR comparing 18-29 to 30+" age 1 / EXP;
RUN;
*PR = 1.20 (1.02, 1.40);

*Let's examine the association between age and PrEP use, adjusting for race/ethnicity and city, using Poisson GEE model (PR);
*Model 2.2; 
PROC GENMOD DATA = H.behavsurv;
	CLASS age(ref="30+") race(ref="White") city(ref="1") studyid / PARAM=ref;
	MODEL prep = age race city / LINK=log DIST=poisson;
	REPEATED SUBJECT = studyid / TYPE = IND;
	ESTIMATE "Adj PR comparing 18-29 to 30+" age 1 / EXP;
RUN;
*aPR = 1.05 (0.90, 1.22); 

*Compare association for age and PrEP use using log-binomial (PR);
*Model 2.3; 
PROC GENMOD data = H.behavsurv DESCENDING;
	CLASS age(ref="30+") race(ref="White") city(ref="1") / PARAM = ref;
	MODEL prep = age race city / LINK=log DIST=binomial;
	ESTIMATE "Adj PR comparing 18-29 v 30+" age 1 / EXP;
RUN;
*aPR=1.06 (0.92, 1.23); 

*Compare association for age and PrEP use using logistic model (OR);
*Model 2.4; 
PROC GENMOD data = H.behavsurv DESCENDING;
	CLASS age(ref="30+") race(ref="White") city(ref="1") / PARAM = ref;
	MODEL prep = age race city / LINK=logit DIST=binomial;
	ESTIMATE "Adj OR comparing 18-29 v 30+" age 1 / EXP;
RUN;

proc genmod data=jcb.behavsurv descending ;
  	class age (ref="30+") race(ref="White") city(ref="1") /param=ref;
	model prep = age race city /link=logit dist=binomial;
	estimate 'Adj OR comparing 18-29 vs. 30+'	age 1	/exp;
run;
*OR=1.08 (0.84, 1.38), note to look at exp(B) column and row; 


