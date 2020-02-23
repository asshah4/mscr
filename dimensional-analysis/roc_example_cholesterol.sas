


data one;
input obs chol cardiac est;
datalines;
1    10    0    1
2    15    1    1
3    18    0    0
4    22    1    0
5    25    1    0
6    28    1    0
7    30    0    1
8    35    0    0
9    40    0    0
10   45    0    1
;
run;

/***********************************************************
******** Classfication Table by Default Probability ********
***********************************************************/
***1;
proc logistic data=one;
model cardiac(event='1')=chol /outroc=roc1 ctable;
output out=pred_out pred=pred; 
run;



proc print data=pred_out;run;

/***********************************************************
** Classfication Table by Specifying Event Probabilities ***
***********************************************************/
proc logistic data=one;
model cardiac(event='1')=chol /outroc=roc1 ctable 
pprob=(0.67555,0.59321,0.54080,0.46970,0.41701,0.36615,0.33376,0.25973,0.19726,0.14683);
output out=pred_out pred=pred; 
run;



***2;
/***********************************************************
** Classfication Table by Specifying Probabilities ***
***********************************************************/


proc logistic data=one;
model cardiac(event='1')=chol est/outroc=roc2 ctable;
output out=pred_out2 pred=pred; 
Title "Model 2";
run;


proc logistic data=one;
model cardiac(event='1') = chol/outroc=roc2 ctable
pprob=(0.67555,0.59321,0.54080,0.46970,0.41701,0.36615,0.33376,0.25973,0.19726,0.14683);
output out=pred_out pred=pred;
run;



***2;
/***********************************************************
** BOX plot from model 2 ***
**** LACKFIT option on model statement gives hosmer-lemeshow test***
***********************************************************/

proc logistic data=one;
model cardiac(event='1')=chol est/outroc=roc2 ctable  lackfit;
output out=pred_out2 pred=pred; 
Title "Model 2";
run;


proc format ; value y 1="YES"  0="No";run;
title "A box plot for Observed disease status and Estimated predicted probability for disease";
proc sgplot data=pred_out2;
vbox pred /category=cardiac;
format cardiac y.;
yaxis grid values=(0 to 0.8 by 0.1) label="Estimated predicted probability for disease";
xaxis Label="Cardiac disease ";
run;

