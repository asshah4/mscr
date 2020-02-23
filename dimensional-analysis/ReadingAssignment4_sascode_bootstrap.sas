libname a ".";
*libname a "S:\bios\amita manatunga\MSCR_509M_2020\lecture4";

data prostate; set a.prostate_data2;
run;

proc means data=prostate;
var acid;
run;

*****univariable model 1 with age;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age /risklimits;
run;

*****univariable model 2 with acid phosphatase;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= acid /risklimits;

 unit acid=0.2  ;
run;


*****univariable model 3 with xray;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= xray /risklimits;

run;


*****univariable model 4 tumor size;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= size /risklimits;

run;

*****univariable model 5 tumor grade;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= GRADE /risklimits;

run;


*****univariable model 6 SES;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= ses /risklimits;

run;

**** MODEL SELECTION;
***** Used automated procedure to select starting model ;
***** age is forced to stay in the model because of clinical importance;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray GRADE ses size/risklimits include=1 details
 selection=backward slstay=0.05 ;

run;

*****NOTE: selected model age acid xray  size as starting model;

*** TEST for two-way interaction one at a time;
*********
*****  xray size acid  age and interaction between age and xray;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray  size 
                    age*xray
                   /risklimits
  ;

run;

**NOTE age*xray not significant P=0.1383 so this interaction is not important;
** Similarly you can fit other two-way interaction one at a time;
***  Other interactions are: age*acid   age*size  age*acid   xray*size   xray*acid   acid*size;
**** None of the above interactions were significant;



*********FINAL multivariable model: age acid xray  size;
*****  ;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray  size 
                    
                   /risklimits
  ;
unit  age=5 acid=0.2;  *** Odds ratio with specified unit;
run;



**************Boot strap bagging*********************;

**** Assign sequential id for each subject 1 to 92;
data _boot1 ; 
set prostate; 
id_new = id;
run;

**** we want 1000 samples each contaiing 92 observations;;

*** This is also called rounding up (ceiling).;
*** x = ceil(3.5)   // outputs 4;

**** randomly select subjects in 1000 boot strap;
data _boot2;
  do bootsamp=1 to 1000;  **** do loop for 1000 samples;
     do bootsamp_id=1 to 92;**** do loop for 92 subjects each;
	  
        random_seq_id=ceil(92*ranuni(1)); *** assign a random seq for each subject between 1 and 92;
        output; end; end;
run;


proc means data=_boot2 min max;
var random_seq_id;
run;



**** check how sampling was done , who got selected and who did not in each sample etc;
proc freq data=_boot2;
tables random_seq_id*bootsamp/norow nocol nopercent;
run;


proc sql;
create table xx as
select bootsamp,count(distinct random_seq_id) as x from _boot2
group by bootsamp;
quit;

data xx;
set xx;
percent=x/92*100;
run;

**** on average each boosample had 63% (53 to 74% range) of total subjects;

proc means data=xx;

var x percent;
run;

*** Link random patient IDs from bootstrap samples to the original data;
**** 92000 observations created.  1000 bootsamples with each 92 observations= 1000 x 92= 92000 observstions;

proc sql;
  create table _boot2_final as
    select distinct * from _boot1 inner join _boot2
    on _boot1.id_new=_boot2.random_seq_id
    order by bootsamp, bootsamp_id;
quit;

**** check example random id 18 how many times got selected;
data temp;
set _boot2_final;
where random_seq_id=18 ;
run;

********* Run proc logistic on 92000 observation using by option with forward selection and save betas;
************  1000 Logistic regressions are executed;
******* each model betas are saved in dataset outest=_betas;

proc logistic data=_boot2_final outest=_betas noprint;
by bootsamp; 
 class id;
 class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray  size
       /rl selection=forward slentry=.05 slstay=0.10  details;;

run;

**** view which predictors were selected at each iteration;
proc print data=_betas; run;


**** calculate reliability;

**** Reliability: Percentage of time risk factor appears in 1000 bootstrap models. Risk factors that appear in =50% of the models are reliable.;

proc means data=_betas N mean std; 
ods output summary=summary;
run;

**** age was selected 338/1000 samples = 34% reliability;

**** acid phosphatase was selected 552/1000 samples = 52% reliability;

**** x-ray was selected 984/1000 samples = 98% reliability;

**** size was selected 749/1000 samples = 75% reliability;


/***--- Bootstrap bagging
Bootstrap bagging was used to identify stable and reliable predictors of nodal involvement
(Breiman L. Bagging predictors. Machine Learning. 1996;24:123-140)  ***/

/***
A dataset was constructed of size equal to the original (92 subjects) by random sampling of cases with
replacement (bootstrap sampling). On average, approximately 40% of subjects were not sampled, whereas some
subjects were sampled more than once. The bootstrap sample was analyzed using the logistic model with an automated
forward stepwise algorithm with entry criterion of p <0.10 and a retention criterion of p <0.05. The result was
stored. This process of sampling, automated analysis and storing was repeated 1000 times. The number of times a
risk factor appeared in these 1000 analyses was taken as reflection of the reliability (signal). Following Breiman’s
median rule (devised to balance type I and type II errors), risk factors were determined to be reliably associated with
the outcome if they appeared in at least 50% of the models (Blackstone EH. Breaking down barriers: helpful breakthrough statistical methods you need to understand better.
J Thorac Cardiovasc Surg. 2001;122(3):430-439.). 
 **/
