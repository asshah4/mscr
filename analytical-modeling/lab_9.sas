*--------------------------------------------------------------------*
|TITLE: Lab 9, COX PROPORTIONAL HAZARD MODEL WITH COMPETING RISK           |
|        	   WITH ANSWERS                                                |
|                                                                          |
|DATE: April 8, 2020					                                   |
|                                                                          |
|DATASETS: Georgia Department of Public Health TB Surveillance Data		   |
|DATA FILE NAME: GDPH (de-identified)									   |
|																		   |
|USER: Argita Salindri                                                     |
*--------------------------------------------------------------------*;

*Bringing the Data In;
LIBNAME H "C:\Users\asshah4\Box Sync\projects\mscr\analytical-modeling";

PROC CONTENTS DATA = H.gdph;
RUN;

*How many observation are there? 1116

*How many variables are there? 10

*-----------------------------------------------------------------*
*		PART 1: Conventional Cox Proportional Hazard Analysis	  *
*-----------------------------------------------------------------*;

*Before running any model, we always start with descriptive statistics;
*Find out how many patients with INH-monoresistant TB converted 
their sputum to negative during treatment; 
PROC FREQ DATA = H.gdph;
	TABLE inh*censor/NOPERCENT NOCOL;
RUN;

*How many patients with drug susceptible TB converted? 
826;

*How many patients with INH monoresistant TB converted?
130;

*Fill these information in your worksheet;

*Cox Proportional Hazard Analysis: CRUDE MODEL;
PROC PHREG DATA = H.gdph PLOT (overlay)=survival;
	CLASS inh(ref='0');
	MODEL survt*censor(0)=inh/TIES=efron RL;
RUN;

*What is the crude hazard rate ratio (and 95%CI) for sputum 
culture conversion comparing 
patients with and without INH-monoresistant TB?
HR 1.255 (1.05-1.50);

*Now do the same for diabetes;
PROC FREQ DATA = H.gdph;
	TABLE dm*censor / NOPERCENT NOCOL;
RUN;

*How many patients with no diabetes converted? 
812;

*How many patients with diabetes TB converted?
121;

* Plot out survival;
PROC PHREG DATA = H.gdph PLOT (overlay)=survival;
	CLASS dm(ref='0');
	MODEL survt*censor(0)=dm / TIES=efron RL;
RUN;

*What is the crude hazard rate ratio (and 95%CI) for 
sputum culture conversion comparing 
patients with and without diabetes?
0.79 (0.66 - 0.95);

*Cox Proportional Hazard Analysis: ADJUSTED MODEL;
*Model is adjusted for age group, gender, 
homelessness, HIV, diabetes, TST result, and smear at baseline;
PROC PHREG DATA = H.gdph PLOT(overlay)=survival;
	CLASS age_group(ref='1') sex(ref='0') homelessness(ref='0')
	HIV(ref='0') dm(ref='0') tst(ref='0') inh(ref='0') smear(ref='0');
	MODEL survt*censor(0)=inh age_group sex homelessness hiv 
	dm tst smear / TIES=efron RL;
RUN;

*What is the adjusted hazard rate ratio (and 95%CI) for sputum culture conversion comparing 
patients INH-monoresistant TB?
HR 1.2 (1.02, 1.49);

*How would you interpret this results? 
After adjusting for all the covars, the HR for serum converting is 
1.2 higher in the drug resistant versus drug susceptible groups


*From the same model, what is the adjusted hazard rate ratio (and 95%CI) for sputum culture conversion comparing 
patients with and without diabetes?
HR 0.86 (0.71 - 1.04);



*-------------------------------------------------------------------------*
*		PART 2: Cox Proportional Hazard Analysis with Competing Risks	  *
*-------------------------------------------------------------------------*;

*PART 2A: CAUSE SPECIFIC MODEL;
/*CAUSE-SPECIFIC HAZARD MODEL FOR CULTURE CONVERSION*/;
PROC PHREG DATA = H.gdph;
	CLASS age_group(ref='1') sex(ref='0') homelessness(ref='0')
	HIV(ref='0') dm(ref='0') tst(ref='0') inh(ref='0') smear(ref='0');
	MODEL survt*censor(0,2)=inh age_group sex homelessness hiv 
	dm tst smear / TIES=efron RL;
RUN;

*What is the cause-specific adjusted hazard rate ratio (and 95%CI) for sputum culture conversion comparing 
patients INH-monoresistant TB?
HR = 1.23 (1.01, 1.49);

/*CAUSE-SPECIFIC HAZARD MODEL FOR ALL-CAUSE MORTALITY*/
PROC PHREG DATA = H.gdph;
	CLASS age_group(ref='1') sex(ref='0') homelessness(ref='0')
	HIV(ref='0') dm(ref='0') tst(ref='0') inh(ref='0') smear(ref='0');
	MODEL survt*censor(0,1)=inh age_group sex homelessness hiv 
	dm tst smear / TIES=efron RL;
RUN;


*What is the cause-specific adjusted hazard rate ratio (and 95%CI) for death comparing 
patients INH-monoresistant TB?
HR = 1.46 (0.6 - 3.38);

*PART 2B: SUB-DISTRIBUTION MODEL;
/*SUBSDISTRIBUTION HAZARD MODEL FOR CULTURE CONVERSION*/
PROC PHREG DATA = H.gdph;
	CLASS age_group(ref='1') sex(ref='0') homelessness(ref='0')
	HIV(ref='0') dm(ref='0') tst(ref='0') inh(ref='0') smear(ref='0');
	MODEL survt*censor(0)=inh age_group sex homelessness hiv 
	dm tst smear / eventcode=1 RL;
RUN;


*What is the adjusted hazard rate ratio (and 95%CI) for sputum culture conversion comparing 
patients INH-monoresistant TB from the sub-distribution model? 
HR = 1.178 (0.96 - 1.45);

/*SUBSDISTRIBUTION HAZARD MODEL FOR ALL-CAUSE MORTALITY*/
PROC PHREG DATA = H.gdph;
	CLASS age_group(ref='1') sex(ref='0') homelessness(ref='0')
	HIV(ref='0') dm(ref='0') tst(ref='0') inh(ref='0') smear(ref='0');
	MODEL survt*censor(0)=inh age_group sex homelessness hiv 
	dm tst smear / eventcode=2 RL;
RUN;


*What is the adjusted hazard rate ratio (and 95%CI) for death comparing 
patients INH-monoresistant TB from the sub-distribution model? 
HR = 1.40 (0.6 - 3.15);


*REFLECTION QUESTION: after comparing the three models (i.e., conventional, cause-specific, and sub-distribution), 
what is/are your take away message? 

It appears that the increase in risk of conversion for those with 
drug resistant types


*-------------------------------------------------------------*
*		PART 3: PLOTTING CIF (RESEARCH QUESTION SPECIFIC)	  *
*-------------------------------------------------------------*;
*A. Plot the CIF for sputum culture conversion;

%CIF (data=H.gdph, out=cif1_data, time=survt, status=censor, 
event=1, censored=0, title=Culture Conversion);

*OR;

PROC LIFETEST DATA = H.gdph PLOTS=cif(test);
	TIME survt*censor(0) / eventcode = 1;
RUN;

*Plot the CIF for sputum culture conversion comparing those 
with drug-susceptible TB and INH-monoresistant TB
accounting for the competing risks;

PROC LIFETEST DATA = H.gdph PLOTS=cif(test);
	TIME survt*censor(0) / eventcode=1;
	WHERE survt <= 365;
	STRATA inh;
RUN;


*What does the graph tell you? 
Truly, there is not really a difference between INH-resistance
and sputum conversion
;
