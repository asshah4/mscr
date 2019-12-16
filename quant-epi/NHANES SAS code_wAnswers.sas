<<<<<<< HEAD
*--------------------------------------------------------------------------*
|TITLE: Introduction to NHANES in SAS                   				   |	
| WITH ANSWERS                                                             |
|                                                                          |
|Updated: Nov 4, 2019                                                      |
|                                                                          |
|DATASETS: NH3 Selected from NHANES	2011-2012					           |
|                                                                          |
|USER: Matthew Magee                                                       |
*--------------------------------------------------------------------------*

*This is an example program to explore the prevalence of latent TB infection and diabetes
in the US adult population and 2) determine if there is an association 
between diabetes melllitus and latent TB infection using NHANES data.;

*The code provides some examples of using proc survey procedures which are needed
to account for the stratified probability sample of NHANES; 

*We have not covered some of the SAS procedures below, but we will soon;




***Download the NHANES SAS dataset "nh3.sas7bdat" from Canvas;

*Note: The NH3 database was customly built by me from NHANES 2011-2012 to assess the LTBI-diabetes quesion,
when using NHANES for your own projects, you must build your databases based
on the study questions, datasets, and variables of interest. More on building databases
below in Section 5;

*****************SECTION 1 Assessing prevalence and associations without proc survey procedures;

libname matt "C:\Users\mjmagee\Desktop";
**examine the variables; 
proc contents data=matt.nh3;
run;
*How many variables are there in nh3? 182
*How many observations? 9756
*How many participants are in the NHANES 2011-2012 public release cycle? 
(Hint see: https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DEMO_G.htm )

*The DEMO_G.xpt NHANES file is usually the place to begin with NHANES. This
file contains basic information about who was surveyed, demographic information,
and details on weight variables.

*Use proc freq to determine how many people in NHANES 2011-2012 were interviewed and examined
and how many were only interviewed? The variable you will need is named 'RIDSTATR';

proc freq data=matt.nh3;
table RIDSTATR;
run;
		**418 were interviewed only, 9338 were interviewed and examined. The key to determining 
the values of the code are found on the NHANES website listed above;

**Find the variable from the NHANES website and determine how many participants were adults.
Verify this information from the website matches your dataset;

proc freq data=matt.nh3;
table RIDAGEYR;
run;
*There are 5560 participants in NHANES 2011-2012 age >= 20 years. For many NHANES elements, adults 
are defined as age >= 20 years.

*Create a new dataset name 'one' using a set statement, and in the new dataset create 3 new variables: 

1. create a new dichotomous variable called "adult" from RIDAGEYR based on the >= 20 years cut point

2. create a new 3-level variable called "DM_cat2" from the existing variable LBXGH (Hemoglobin A1c);

*Use the American diabetes association recommended cut points for diabetes:
	HbA1c <5.7% = no diabetes
	5.7-6.4% = pre diabetes
	>=6.5% = diabetes

	**See: https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/GHB_G.htm

3. create a new dichotomous variable called LTBI (for latent TB infection) from existing variable LBXTBIN which
was a quantiferon gold tube latent TB test;

	*Make intermediate values missing
	Make "negative" response=0 (this is much easier for proc logistic)
	Make "positive" response=1;

	**See: https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/TB_G.htm ;

*I've started for you;

Data one;
set matt.nh3;
*first create adults;
if  RIDAGEYR < 20 then adult=0;
else if RIDAGEYR >= 20 then adult=1;

*create diabetes based on glycated hemoglobin;
if LBXGH = . then DM_cat2=.; 
else if LBXGH >=2.0 and LBXGH <5.7 then DM_cat2=0;
else if LBXGH >=5.7 and LBXGH <6.5 then DM_cat2=1;
else if LBXGH >=6.5 then DM_cat2=2;

*create latent TB based on QFT;
if LBXTBIN=. then LTBI=.;
else if LBXTBIN=3 then LTBI=.;
else if LBXTBIN=1 then LTBI=1;
else if LBXTBIN=2 then LTBI=0;

run;
proc contents data=one;
run;

*Using your new variables, calculate the prevalence of diabetes, prediabetes among NHANES adults? ;
proc freq data=one;
table dm_cat2;
where adult=1;
run;
		*Among NHANES adults 12.0% had diabetes and 28.8% had prediabetes among 5020 adults who had a HbA1c test;

*Using your new variable, calculate the prevalence of LTBI among NHANES adults;
Proc freq data=one;
table ltbi;
where adult=1;
run;
		*10.4% adult LTBI prevalence (note 602 had missing results);

*Note the above prevalence estimates are the proportion of NHANES participants with diabetes and 
latent TB infection, but do not account for sampling methods and therefore ARE NOT estimates of these
conditions in the US adult population;

*Last, how many adults had both HbA1c results and QFT results (no missing on either),
and what is the prevalence difference of LTBI among those with diabetes compared to those without;

proc freq data=one;
table ltbi*dm_cat2;
where adult=1;
run;

	*4945 adults has both laboratory measures (QFT and Hba1c) performed;
	*Prevalence of LTBI was 16.3% among those with diabetes compared to
	8.2% among those without diabetes (PD = 8.1%). 

	Again, this prevalence difference CANNOT be generalized to the US population
	and reporting this result is incorrect; 


******************SECTION 2 Proc SurveyFreq;

*now use proc surveyfreq to account for the NHANES sampling design and 
estimate the following among US adults:

1. prevalence of diabetes, 
2. prevalence of LTBI, and 
3. the prevalence difference of LTBI by diabetes ;

*****1. Prevalence of diabetes;
proc surveyfreq data=one;
*The strata, cluster, and weight indications typically do not change if you are 
using one NHANES cycle from the continuous years (after 1999)

Note: The strata, cluster, and weight variables are part of the NHANES deomgraphic data file;

strata sdmvstra; *NHANES defined strata for continuous NHANES is "sdmvstra";
cluster SDMVPSU; *This specifies the primary sampling unit to account for design effects of clustering;
weight WTMEC2YR; *The sample weight is a measure of the number of individuals in the target population 
that the sampled individual represents. Sample weights are needed to obtain unbiased estimates 
of population parameters when the sample participants are chosen with unequal probabilities;

*According to NHANES tutorial you should not use a where statement to subset the data;
*Instead, use the "adult" variable in the table statement;
table adult*dm_cat2/ cl col row;  *cl col row options provide estimates for 95% confidence intervals;

run; 
*Reading the proc surveyfreq table can be confusing, typically the interest is
in the row percent;

	*What is the estimated prevalence of diabetes in the US in 2011-2012?
	8.2% (7.0-9.4), NOTE: this only is only based on HbA1c and does not include
	patients with diabetes who have HbA1c <6.5%.;

*what is the difference if you do subset the data to get adults only?; 
	*Very little and a table much easier to read!;
proc surveyfreq data=one;

strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR; 


table dm_cat2/cl col row ; 

where adult=1; 
run; 

*****2. Prevalence of latent TB infection;
*Now you try:    ;

proc surveyfreq data=one;
strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR; 
table adult*ltbi/cl col row ; 
run; 
*prevalence estimate for LTBI in adult US population by QFT is 5.9%;

*****3. Prevalence difference of latent TB infection by diabetes status;
proc surveyfreq data=one;
strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR; 
table adult*dm_cat2*ltbi/cl col row ; 
run; 
	*Accounting for NHANES design, prevalence difference is 6.2% 
	(10.9 prevalenc of LTBI in diabetes compared to 4.7% among no diabetes);


**In summary,how do the estimated prevalences for adults in the US compare to the "raw" NHANES data?
	Diabetes: 8.2% vs. 12.0%
	LTBI: 5.9% vs. 10.4%
	Prevalence difference: vs. 8.1%

*Accounting for strata, cluster, weight feastures makes an important difference!


******************SECTION 3 Proc Surveymeans;

*Similar to proc survey freq, proc survey means is used to calculate 
means for continuous variables; 

*What is the mean HbA1c among US adults?;

proc surveymeans data=one;

strata sdmvstra; *fortunately these do not change;
cluster SDMVPSU;
weight WTMEC2YR;

domain adult; *Instead of a where statement, use the 'domain' statement to keep from
subsetting the data;

var LBXGH; *continuous variable for HbA1c;

run;
*Mean HbA1c for US adults is 5.6%;

*compare above mean to non survey procedures (proc univariate);
proc univariate data=one;
var LBXGH;
where adult=1;
run;
*According to proc univariate the mean is 5.8%;


**Next compare mean HbA1c by diabetes status;
proc surveymeans data=one;
strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR;
domain adult*dm_cat2; *just add the diabetes variable to the domain statement to get the breakdown;
var LBXGH;
run;

******************SECTION 4 Proc SurveyLogistic;

**Note, if you have not worked with logistic regression before, the below example may 
not make any sense. Don't worry, this is just an example and may be a useful
reference to you in the future;

*Proc logistic now also has a procedure to account for sampling;
*What is the odds of LTBI comparing those with diabetes to those without?;

proc surveylogistic data=one;
stratum SDMVSTRA; *Again, the 3 design variables do not change (YEA!);
cluster SDMVPSU;
weight WTMEC2YR;
domain adult; *select just adults with domain statment without subsetting data;

class dm_cat2 (param=ref ref='0'); *When using a categorical variable in regression, it is easiest to include a class statement
for the independent variables;

model LTBI (event="1")=dm_cat2;
run;
*In an unadjusted analysis the odds of prevalent LTBI among adults with diabetes is 2.5 (95% CI 1.7-3.7) 
times the odds of prevalent LTBI among those without diabetes.

******************SECTION 5 Building, importing, and merging NHANES databases;

*One of the hardest parts of NHANES is to figure out the initial data and
variables needed;

*To determine what datasets you will need, you must first spend some time
researching the available files on NHANES websites;

*Below is code to build a dataset to look at the relationship between 
diabetes and hepatitis C using NHANES 2015-2016 data;

*KEY STEPS:
1. Download the SAS Xport data files
2. Extract to a SAS library as a SAS dataset
3. Merge datasets by SEQN

For this example the datasets to bring in are:
DEMO_I.XPT
GHB_I.XPT
HEPC_I.XPT


First, download the 3 Xport files and save in a folder (I named my folder 'Step5' on the Desktop);
**See: https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2015 ;

*Create a library where the SAS datafiles will be stored;

libname NHANES "C:\Users\mjmagee\Desktop";

*Create another library and use the xport statement to convert each file to SAS datafiles:;
libname XP xport "C:\Users\mjmagee\Desktop\Step5\DEMO_I.xpt";
proc copy in=XP out=NHANES; *The proc copy procedure move the files from xp to NHANES libraries;
run;

*Now do the same for the other two xport files:;

libname XP xport "C:\Users\mjmagee\Desktop\Step5\HEPC_I.xpt";
proc copy in=XP out=NHANES; 
run;
libname XP xport "C:\Users\mjmagee\Desktop\Step5\GHB_I.xpt";
proc copy in=XP out=NHANES; 
run;


*Make sure each of the datasets was successfully created; 
proc contents data=nhanes.demo_i;
run;
proc contents data=nhanes.hepc_i;
run;
proc contents data=nhanes.ghb_i;
run;
proc freq data=nhanes.demo_i;
table ridstatr;
run;

*Last merge the files by the unique identifier: "SEQN";

*We have not covered merging with SAS yet, but this will be coming soon and 
give you a taste of merging;

*First sort each dataset by the common variable to be used for the merge:;
proc sort data=nhanes.demo_i;
by seqn;
run;
proc sort data=nhanes.ghb_i;
by seqn;
run;
proc sort data=nhanes.hepc_i;
by seqn;
run;

*Create a new dataset in the nhanes library called nh4 which merges
the three datasets by seqn;

data nhanes.nh4;
merge
nhanes.hepc_i
nhanes.ghb_i
nhanes.demo_i;
by seqn;
run;

*Check that the merge worked correctly:;
proc contents data=nhanes.nh4;
run;

*Does the merged dataset have the expected number of variables?

nh4: 	50 variables (contains all 47 variables from demo, 1 from ghb, 2 from hepc)
hepc_i: 3 variables
ghb_i: 	2 variables 
demo_i: 47 variables
=======
*--------------------------------------------------------------------------*
|TITLE: Introduction to NHANES in SAS                   				   |	
| WITH ANSWERS                                                             |
|                                                                          |
|Updated: Nov 4, 2019                                                      |
|                                                                          |
|DATASETS: NH3 Selected from NHANES	2011-2012					           |
|                                                                          |
|USER: Matthew Magee                                                       |
*--------------------------------------------------------------------------*

*This is an example program to explore the prevalence of latent TB infection and diabetes
in the US adult population and 2) determine if there is an association 
between diabetes melllitus and latent TB infection using NHANES data.;

*The code provides some examples of using proc survey procedures which are needed
to account for the stratified probability sample of NHANES; 

*We have not covered some of the SAS procedures below, but we will soon;




***Download the NHANES SAS dataset "nh3.sas7bdat" from Canvas;

*Note: The NH3 database was customly built by me from NHANES 2011-2012 to assess the LTBI-diabetes quesion,
when using NHANES for your own projects, you must build your databases based
on the study questions, datasets, and variables of interest. More on building databases
below in Section 5;

*****************SECTION 1 Assessing prevalence and associations without proc survey procedures;

libname matt "C:\Users\mjmagee\Desktop";
**examine the variables; 
proc contents data=matt.nh3;
run;
*How many variables are there in nh3? 182
*How many observations? 9756
*How many participants are in the NHANES 2011-2012 public release cycle? 
(Hint see: https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DEMO_G.htm )

*The DEMO_G.xpt NHANES file is usually the place to begin with NHANES. This
file contains basic information about who was surveyed, demographic information,
and details on weight variables.

*Use proc freq to determine how many people in NHANES 2011-2012 were interviewed and examined
and how many were only interviewed? The variable you will need is named 'RIDSTATR';

proc freq data=matt.nh3;
table RIDSTATR;
run;
		**418 were interviewed only, 9338 were interviewed and examined. The key to determining 
the values of the code are found on the NHANES website listed above;

**Find the variable from the NHANES website and determine how many participants were adults.
Verify this information from the website matches your dataset;

proc freq data=matt.nh3;
table RIDAGEYR;
run;
*There are 5560 participants in NHANES 2011-2012 age >= 20 years. For many NHANES elements, adults 
are defined as age >= 20 years.

*Create a new dataset name 'one' using a set statement, and in the new dataset create 3 new variables: 

1. create a new dichotomous variable called "adult" from RIDAGEYR based on the >= 20 years cut point

2. create a new 3-level variable called "DM_cat2" from the existing variable LBXGH (Hemoglobin A1c);

*Use the American diabetes association recommended cut points for diabetes:
	HbA1c <5.7% = no diabetes
	5.7-6.4% = pre diabetes
	>=6.5% = diabetes

	**See: https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/GHB_G.htm

3. create a new dichotomous variable called LTBI (for latent TB infection) from existing variable LBXTBIN which
was a quantiferon gold tube latent TB test;

	*Make intermediate values missing
	Make "negative" response=0 (this is much easier for proc logistic)
	Make "positive" response=1;

	**See: https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/TB_G.htm ;

*I've started for you;

Data one;
set matt.nh3;
*first create adults;
if  RIDAGEYR < 20 then adult=0;
else if RIDAGEYR >= 20 then adult=1;

*create diabetes based on glycated hemoglobin;
if LBXGH = . then DM_cat2=.; 
else if LBXGH >=2.0 and LBXGH <5.7 then DM_cat2=0;
else if LBXGH >=5.7 and LBXGH <6.5 then DM_cat2=1;
else if LBXGH >=6.5 then DM_cat2=2;

*create latent TB based on QFT;
if LBXTBIN=. then LTBI=.;
else if LBXTBIN=3 then LTBI=.;
else if LBXTBIN=1 then LTBI=1;
else if LBXTBIN=2 then LTBI=0;

run;
proc contents data=one;
run;

*Using your new variables, calculate the prevalence of diabetes, prediabetes among NHANES adults? ;
proc freq data=one;
table dm_cat2;
where adult=1;
run;
		*Among NHANES adults 12.0% had diabetes and 28.8% had prediabetes among 5020 adults who had a HbA1c test;

*Using your new variable, calculate the prevalence of LTBI among NHANES adults;
Proc freq data=one;
table ltbi;
where adult=1;
run;
		*10.4% adult LTBI prevalence (note 602 had missing results);

*Note the above prevalence estimates are the proportion of NHANES participants with diabetes and 
latent TB infection, but do not account for sampling methods and therefore ARE NOT estimates of these
conditions in the US adult population;

*Last, how many adults had both HbA1c results and QFT results (no missing on either),
and what is the prevalence difference of LTBI among those with diabetes compared to those without;

proc freq data=one;
table ltbi*dm_cat2;
where adult=1;
run;

	*4945 adults has both laboratory measures (QFT and Hba1c) performed;
	*Prevalence of LTBI was 16.3% among those with diabetes compared to
	8.2% among those without diabetes (PD = 8.1%). 

	Again, this prevalence difference CANNOT be generalized to the US population
	and reporting this result is incorrect; 


******************SECTION 2 Proc SurveyFreq;

*now use proc surveyfreq to account for the NHANES sampling design and 
estimate the following among US adults:

1. prevalence of diabetes, 
2. prevalence of LTBI, and 
3. the prevalence difference of LTBI by diabetes ;

*****1. Prevalence of diabetes;
proc surveyfreq data=one;
*The strata, cluster, and weight indications typically do not change if you are 
using one NHANES cycle from the continuous years (after 1999)

Note: The strata, cluster, and weight variables are part of the NHANES deomgraphic data file;

strata sdmvstra; *NHANES defined strata for continuous NHANES is "sdmvstra";
cluster SDMVPSU; *This specifies the primary sampling unit to account for design effects of clustering;
weight WTMEC2YR; *The sample weight is a measure of the number of individuals in the target population 
that the sampled individual represents. Sample weights are needed to obtain unbiased estimates 
of population parameters when the sample participants are chosen with unequal probabilities;

*According to NHANES tutorial you should not use a where statement to subset the data;
*Instead, use the "adult" variable in the table statement;
table adult*dm_cat2/ cl col row;  *cl col row options provide estimates for 95% confidence intervals;

run; 
*Reading the proc surveyfreq table can be confusing, typically the interest is
in the row percent;

	*What is the estimated prevalence of diabetes in the US in 2011-2012?
	8.2% (7.0-9.4), NOTE: this only is only based on HbA1c and does not include
	patients with diabetes who have HbA1c <6.5%.;

*what is the difference if you do subset the data to get adults only?; 
	*Very little and a table much easier to read!;
proc surveyfreq data=one;

strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR; 


table dm_cat2/cl col row ; 

where adult=1; 
run; 

*****2. Prevalence of latent TB infection;
*Now you try:    ;

proc surveyfreq data=one;
strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR; 
table adult*ltbi/cl col row ; 
run; 
*prevalence estimate for LTBI in adult US population by QFT is 5.9%;

*****3. Prevalence difference of latent TB infection by diabetes status;
proc surveyfreq data=one;
strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR; 
table adult*dm_cat2*ltbi/cl col row ; 
run; 
	*Accounting for NHANES design, prevalence difference is 6.2% 
	(10.9 prevalenc of LTBI in diabetes compared to 4.7% among no diabetes);


**In summary,how do the estimated prevalences for adults in the US compare to the "raw" NHANES data?
	Diabetes: 8.2% vs. 12.0%
	LTBI: 5.9% vs. 10.4%
	Prevalence difference: vs. 8.1%

*Accounting for strata, cluster, weight feastures makes an important difference!


******************SECTION 3 Proc Surveymeans;

*Similar to proc survey freq, proc survey means is used to calculate 
means for continuous variables; 

*What is the mean HbA1c among US adults?;

proc surveymeans data=one;

strata sdmvstra; *fortunately these do not change;
cluster SDMVPSU;
weight WTMEC2YR;

domain adult; *Instead of a where statement, use the 'domain' statement to keep from
subsetting the data;

var LBXGH; *continuous variable for HbA1c;

run;
*Mean HbA1c for US adults is 5.6%;

*compare above mean to non survey procedures (proc univariate);
proc univariate data=one;
var LBXGH;
where adult=1;
run;
*According to proc univariate the mean is 5.8%;


**Next compare mean HbA1c by diabetes status;
proc surveymeans data=one;
strata sdmvstra; 
cluster SDMVPSU;
weight WTMEC2YR;
domain adult*dm_cat2; *just add the diabetes variable to the domain statement to get the breakdown;
var LBXGH;
run;

******************SECTION 4 Proc SurveyLogistic;

**Note, if you have not worked with logistic regression before, the below example may 
not make any sense. Don't worry, this is just an example and may be a useful
reference to you in the future;

*Proc logistic now also has a procedure to account for sampling;
*What is the odds of LTBI comparing those with diabetes to those without?;

proc surveylogistic data=one;
stratum SDMVSTRA; *Again, the 3 design variables do not change (YEA!);
cluster SDMVPSU;
weight WTMEC2YR;
domain adult; *select just adults with domain statment without subsetting data;

class dm_cat2 (param=ref ref='0'); *When using a categorical variable in regression, it is easiest to include a class statement
for the independent variables;

model LTBI (event="1")=dm_cat2;
run;
*In an unadjusted analysis the odds of prevalent LTBI among adults with diabetes is 2.5 (95% CI 1.7-3.7) 
times the odds of prevalent LTBI among those without diabetes.

******************SECTION 5 Building, importing, and merging NHANES databases;

*One of the hardest parts of NHANES is to figure out the initial data and
variables needed;

*To determine what datasets you will need, you must first spend some time
researching the available files on NHANES websites;

*Below is code to build a dataset to look at the relationship between 
diabetes and hepatitis C using NHANES 2015-2016 data;

*KEY STEPS:
1. Download the SAS Xport data files
2. Extract to a SAS library as a SAS dataset
3. Merge datasets by SEQN

For this example the datasets to bring in are:
DEMO_I.XPT
GHB_I.XPT
HEPC_I.XPT


First, download the 3 Xport files and save in a folder (I named my folder 'Step5' on the Desktop);
**See: https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2015 ;

*Create a library where the SAS datafiles will be stored;

libname NHANES "C:\Users\mjmagee\Desktop";

*Create another library and use the xport statement to convert each file to SAS datafiles:;
libname XP xport "C:\Users\mjmagee\Desktop\Step5\DEMO_I.xpt";
proc copy in=XP out=NHANES; *The proc copy procedure move the files from xp to NHANES libraries;
run;

*Now do the same for the other two xport files:;

libname XP xport "C:\Users\mjmagee\Desktop\Step5\HEPC_I.xpt";
proc copy in=XP out=NHANES; 
run;
libname XP xport "C:\Users\mjmagee\Desktop\Step5\GHB_I.xpt";
proc copy in=XP out=NHANES; 
run;


*Make sure each of the datasets was successfully created; 
proc contents data=nhanes.demo_i;
run;
proc contents data=nhanes.hepc_i;
run;
proc contents data=nhanes.ghb_i;
run;
proc freq data=nhanes.demo_i;
table ridstatr;
run;

*Last merge the files by the unique identifier: "SEQN";

*We have not covered merging with SAS yet, but this will be coming soon and 
give you a taste of merging;

*First sort each dataset by the common variable to be used for the merge:;
proc sort data=nhanes.demo_i;
by seqn;
run;
proc sort data=nhanes.ghb_i;
by seqn;
run;
proc sort data=nhanes.hepc_i;
by seqn;
run;

*Create a new dataset in the nhanes library called nh4 which merges
the three datasets by seqn;

data nhanes.nh4;
merge
nhanes.hepc_i
nhanes.ghb_i
nhanes.demo_i;
by seqn;
run;

*Check that the merge worked correctly:;
proc contents data=nhanes.nh4;
run;

*Does the merged dataset have the expected number of variables?

nh4: 	50 variables (contains all 47 variables from demo, 1 from ghb, 2 from hepc)
hepc_i: 3 variables
ghb_i: 	2 variables 
demo_i: 47 variables
>>>>>>> 5458e64a1faf284f3a4e3e83dc8b231a68a3d951
