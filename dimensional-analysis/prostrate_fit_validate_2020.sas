
libname hw '.';
proc freq data =hw.prostate_data2;
tables y;
run;
**1;

*Split data into two sets :training and validation;
*** ranuni function generates a uniform number between 0 and 1;
**** Since we want 70 /30 split , we used le 0.70  condtion;

data                     prostate_training  prostate_validation; 
set hw.prostate_data2;
seed = 18737128;

if ranuni(seed) le 0.70 then output  prostate_training;
else                         output  prostate_validation;
drop seed;
run; 

/****  You can run below code to see how ranuni function;

data                     x; 
set hw.prostate_data2;
seed = 18737128;
x=ranuni(seed);
run;

proc means  data=x  plot;
var x;
run;
***/


*** Training dataset 26 events / 66 observations;
proc freq data =prostate_training;
tables y;
run;
*** Validation dataset: 10 events /26 observations;
proc freq data =prostate_validation;
tables y;
run;
**2;
**** run model on training dataset;
/***
 OUTMODEL=SAS-data-set
specifies the name of the SAS data set that contains the information about the fitted model. 
This data set contains sufficient information to score new data without having to refit the model.
It is solely used as the input to the INMODEL= option in a subsequent PROC LOGISTIC call.
**/
/** output out=  statement
All the variables in the original data set are included in the new data set, 
along with variables created in the OUTPUT statement. 
These new variables contain the values of a variety of diagnostic measures 
that are calculated for each observation in the data set. 
https://v8doc.sas.com/sashtml/stat/chap30/sect20.htm
**/

/**
ODS OUTPUT Statement: Produces a SAS data set from an output object 
http://support.sas.com/documentation/cdl/en/odsug/65308/HTML/default/viewer.htm#p0oxrbinw6fjuwn1x23qam6dntyd.htm
**/

/** roceps=0 states output unique probability.**/

ods listing;

proc logistic data=prostate_training outmodel=model1 ;

class  xray (ref='0') size (ref='0') grade (ref='0')/param=ref;
model  y(event='1') = age acid xray size grade
                     /outroc=roc_training ctable  roceps=0
                     pprob=0.1 to 0.99 by 0.01 lackfit ;
ods output  LackFitPartition = _lackfit	;



output out=trainscores p=phat Lower=lowerPred upper=upperPred;*** RHS=user defined;

run;

proc contents data=trainscores;
run;



***  Gives AUC  for training data;   
 **score data=prostate_training fitstat outroc=y out=score1;

 
*** Gives AUC  and ROC curve for validation data;
**score data=prostate_validation  fitstat outroc=x2  ;



***NOTE: Hosmer -Lemeshow test statistic= 9.7223 p=0.27;
**** so, we fail to reject the null hypothesis 
and say that the model fits the data well.;

**3;
**** print p-hat for training dataset;
proc print data=trainscores ;
run;

**4;
*** boxplot of predicted probability against the observed Y;

proc format ; value y 1="With disease" 0 ="Without disease";run;

proc sgplot data=trainscores; 
vbox phat / category=y;



Yaxis label="Predicted Probability"  values=(0 to 1 by 0.1)
       GRID  minor  labelattrs=(size=14 weight =bold)
       valueattrs=(size=10 weight =bold);

Xaxis label="Disease status" labelattrs=(size=14 weight =bold)
       valueattrs=(size=10 weight =bold) ;


format y y.;
run;

**5 lackfit dataset;
proc print data=_lackfit;
run;

/*****
proc sql;
create table trainscores as 
select * from trainscores order by phat;
quit; 
****/


****Create dataset with observed and predicted proportion for 
lackfit dataset to get calibration plot;

/**
For each group, calculate the observed number of events and non-events, 
as well as the expected number of events and non events. 
The expected number of events is just the sum of the predicted probabilities over the 
individuals in the group. And the expected number of non-events
is the group size minus the expected number of events.

**/

**** check variable names in this dataset;
**** option VARNUM shows variables by its Variables Creation Order without this option it shows Alphabetic List;
proc contents data=_lackfit order= VARNUM; run;

data calib;
set _lackfit;
obsproportion=eventsobserved/total;  **** observed proportion in the group;
predictedproportion=eventsexpected/total; **** predicted  proportion  in the group;
run;

**6;
title " Calibration plot ";
footnote;

proc sgplot data=calib noautolegend;
scatter y= predictedproportion 
       x= obsproportion / 
        markerattrs=(symbol=starfilled size=8pt color=red)
datalabel=predictedproportion;   **** datalabel option puts Y-value beside the symbol;

Lineparm x = 0 y = 0 slope = 1 /lineattrs=(color=purple pattern=dash);  ** puts 45 degree line to see how close x,y values are;

xaxis values=(0 to 1 by 0.1) label="Observed proportion" grid;
yaxis values=(0 to 1 by 0.1) grid label="Predicted proportion";
run;



**7;
***Model evaluation;
* The folowing procedure takes the model devloped in in the previous logistic regression using the training dataset. 
Remember we used an outmodel statement in 
the previous to indicate that the model should be saved. Now, we use that model to apply to the validation dataset using the command inmodel. 
We are not running logistic regression equation again. 
We need the predicted probabilities for the vaidation dataeset that we get from score statement.;
proc logistic  inmodel=model1 ;


score data=prostate_validation 
        out=validscores 
       outroc=roc_validation fitstat   
;
run;
**** ;
proc contents data=roc_validation order=varnum;run;
proc contents data=validscores order=varnum;run;

proc print data=validscores;
run;

**8;
***boxplot for validation data;
title " Boxplot for validation data";
proc sgplot data= validscores;
vbox P_1 / category=y;
Yaxis label="Predicted Probability" GRID;
Xaxis label="Response";
format y y.;
run;


/***

**/

**9;
*** ROC curve for validation;
ods graphics/reset width=6in height=4in noborder;

proc sgplot data=roc_validation noautolegend;
title 'ROC Curve for Prostate Data-validation set AUC =0.693';
step x=_1mspec_ y=_sensit_;
scatter  x=_1mspec_ y=_sensit_;
*scatter  x=_1mspec_ y=_sensit_ /DATALABEL=_PROB_;
Lineparm x = 0 y = 0 slope = 1;  
** puts 45 degree line for AUC=0.5;
yaxis values=(0 to 1 by 0.1) GRID;
Xaxis values=(0 to 1 by 0.1) GRID;
run;


**10;
*** ROC combined dataset;

data roc_training;
length sample $ 20;
set roc_training;
sample = 'training data';
run;

data roc_validation; 
length sample $ 20;
set roc_validation;
sample = 'validation data';
run;
*** merge two sets;
data roc_Combined;
set roc_training 
    roc_validation;
run;


**11;
Title1 "ROC curves for training and validation set";
title2 "AUC training: 0.85";
title3 "AUC validation: 0.693";
ods graphics /reset width=4in height=4in noborder;
proc sgplot data=roc_Combined;
scatter x=_1mspec_ y=_sensit_/group=sample;
series x=_1mspec_ y=_sensit_/group=sample;
Lineparm x = 0 y = 0 slope =1/lineattrs=(color=lightgrey);
yaxis grid;xaxis grid;
run;

**12;
*** classification rule for training data. Here using 0.6 as cutoff;
data trainscores2 ;
set trainscores;
if phat >0.6 then new_Y = 1;
else new_Y = 0;

run;

proc print data=trainscores2 ;
run;

**13 misclassification rate for training data;
proc freq data= trainscores2 order=formated ;
table new_y*y / norow nocum nopercent;
title 'Training Data set';
format new_y 
         y 
         y.;
run;
**NOTE: 10+4=14 misclassified. 14/66=21%;

**14;
*** classification rule for validation data;
**The variables p_1 and p_0 are generated by SAS in dataset validscores. 

Since we are modelling for Y=1, we will use p_1 variable.
If you are modelling Y=0 then ,use p_0 variable.
For homework birthweight dataset, outcome is yes /no, so there you will get p_yes and p_no variables.
You can do proc contents data=validscores to identify newly created variable names(and labels) in this dataset.
;
data validscores2;
set validscores;
if P_1 >0.6 then new_Y = 1;
else new_Y = 0;
run;

**15  misclassification rate for validation data;
proc freq data= validscores2 order=formated;
table new_y*y / norow nocum nopercent;
title "Validation Data set";
format new_y y y.;
run;
**NOTE: 3+5=8 misclassified. 8/26=31%;


**16;
*** Cross validation;
/**  
In the first LOGISTIC step below, the model is fit to the complete data (prostate_data2).
 The PREDPROBS=CROSSVALIDATE option in the OUTPUT statement 
creates a data set containing the cross validated predicted probabilities.
**/
/**
These probabilities are derived from the leave-one-out principle—that is, dropping the data of one subject and reestimating the parameter estimates. PROC LOGISTIC uses a less expensive one-step approximation to compute the parameter estimates. 
This option is valid only for binary response models;
**/
*** roc of original data:0.83; 

*;
 
proc logistic data=hw.prostate_data2;
class  xray (ref='0') size (ref='0') grade (ref='0')/param=ref;

model  y(event='1') = age acid xray size grade/outroc=roc_cross_valid ctable  roceps=0
pprob=0.1 to 0.99 by 0.01 lackfit ;

ods output  LackFitPartition = summarylack	;


output out=validationCross predprobs=crossvalidate  p=phat Lower=lowerPred upper=upperPred ;

run;

proc contents data=validationCross;
run;
 
**17;
*you can get Somers' D R|C here and cross validate AUC= (D+1)/2;

proc print data=validationCross;run;

**18;
**The variables xp_1 and xp_0 are generated in dataset validationCross. 
x stands for cross-validation, 
since we are modelling for Y=1, we will use xp_1 variable.
If you are modelling Y=0 then ,use xp_0 variable.
For homework birthweight dataset, outcome is yes /no, so there you will get xp_yes and xp_no variables.
You can do proc contents data=validationCross to identify newly created variable names(and labels) in this dataset.
;

***19;
*** get somer's D to calculate AUC.option measures gives Somers' D R|C;
proc freq data=validationCross;
tables xp_1*y/noprint measures;  **** AUC for cross-validated;
*tables phat*y/noprint measures;  **** AUC for original dataset;
run;
*** NOTE: AUC for crossvalidation Somers' D R|C =(0.5476 +1) /2=0.7738;
**** AUC for original dataset  Somers' D R|C=  (0.6627 +1)/2=0.831;
