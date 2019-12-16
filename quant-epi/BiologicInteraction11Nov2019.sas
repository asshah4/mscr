libname matt "C:\Users\mjmagee\Box Sync\MSCR\530 Fall 2019\Participation\In class exercise\Interaction analysis";

proc contents data=matt.interaction;
run;
proc freq data=two;
table gen;
run;



data work.two;
set matt.interaction;

**remove all missing for simplicity of example;
if death=. then death2=0;
else death2= death;

if hiv=. then hiv2=1;
else hiv2=hiv;

if alcoholabuse=. then alc2=1;
else alc2=alcoholabuse;

**Create Dummy Variables for Exposure profiles AB, A, B (background is not coded and therefore referent);
if hiv2=0 and alc2=1 then ind01=1;
else ind01=0;

if hiv2=1 and alc2=0 then ind10=1;
else ind10=0;

if hiv2=1 and alc2=1 then ind11=1;
else ind11=0;

run;
**************************************************STATISTICAL INTERACTION (multiplicative);
*No interaction;
proc logistic data=two;
model death2 (event='1') = hiv2 alc2;
run;
*What is the odds ratio for the effect of HIV adjusted for alc2? aOR=2.87;

*Interaction between hiv and alcohol;
*First get the separate odds ratios by using a where statement:;
proc logistic data=two;
model death2 (event='1') = hiv2 ;
where alc2=0;
run;
proc logistic data=two;
model death2 (event='1') = hiv2 ;
where alc2=1;
run;
*Is the interaction statistically significant? 
There is no beta estimate for interaction when using the 'where' statement;
*How else can you determine if the effects are significantly different?



*Now, fit a simple logistic model with an interaction (product) term;
Proc logistic data=two;
model  death2 (event='1') = hiv2 alc2 hiv2*alc2;
run;
*Write out the expression for the interaction terms and calculate with a calculator;
*Is the beta estimate for the interaction term significant? What decision would you make based on this test?;

*Below logistic procedure provides options to generate odds ratios for the desired comparisons of interaction;
proc logistic data=two;
class alc2 (param=ref ref='0') hiv2 (param=ref ref='0');
model death2 (event='1') = hiv2 alc2 hiv2*alc2 ;
oddsratio hiv2 /at(alc2="1");
run;
**what is the OR comparing those with HIV to those without HIV where ALC2=1? 2.66 (0.99-7.19)
**what is the OR those with HIV to those without HIV where ALC2=0? 3.25 (95%CI 0.26-12.26)
*how are these estimates different than the estimates from the where statement? They are the same.


*Now repeat the interaction assessment using the where statement and the product term with gender in the model;
proc logistic data=two;
model death2 (event='1') = hiv2 gen ;
where alc2=0;
run;
proc logistic data=two;
model death2 (event='1') = hiv2 gen ;
where alc2=1;
run;
proc logistic data=two;
class alc2 (param=ref ref='0') hiv2 (param=ref ref='0');
model death2 (event='1') = hiv2 alc2 hiv2*alc2 gen ;
oddsratio hiv2 /at(alc2="0");
run;
proc logistic data=two;
class alc2 (param=ref ref='0') hiv2 (param=ref ref='0');
model death2 (event='1') = hiv2 alc2 hiv2*alc2 gen ;
oddsratio hiv2 /at(alc2="1");
run;
*compare the estimates (for HIV on odds of death) now that gender is added in the model:
Where statement: 	alc2=0 odds ratio 2.81
					alc2=1 odds ratio 2.78

Product term:		alc2=0 odds ratio 2.57
					alc2=1 odds ratio 2.74


**************************************************BIOLOGIC INTERACTION;
****************************risks of death for calculation using Biologic Interaction Risk formula;
*risk for alcohol and hiv;
proc freq data=two;
table death2*ind11;
run;
*risk for alcohol and no hiv;
proc freq data=two;
table death2*ind01;
run;
*risk for no alcohol and hiv;
proc freq data=two;
table death2*ind10;
run;
*risk for neither;
proc freq data=two;
table death2;
where ind10=0 and ind01=0 and ind11=0;
run;


proc logistic data=two;
model death2 (event='1') = ind01 ind10 ind11;
run;

