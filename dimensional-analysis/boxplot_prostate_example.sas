*---------------------------------------------------*

*---- SAS code to create boxplot -----*
*---------------------------------------------------*


**** Libname to SAS dataset;

libname a "C:\Users\asshah4\Box Sync\projects\mscr\dimensional-analysis" ;

*** Run the desired  logistic model;
*** Here predictor is age and grade. Save PHAT in a dataset using output statement.;
*** Here we saved PHAT in a dataset called 'pred' in work library;
proc logistic data=a.prostate_data2;
class grade (ref='0')/param=ref;

model y(event='1')= age grade ;
output out=pred  pred=phat lower=lower upper=upper; *** this syntax is explained in lecture;
 
run;

PROC PRINT DATA = a.prostate_data2;
RUN;

*** Create format for Y variable;
proc format;

value y 1 = "Present" 0 = "Absent" ;

run;
*** Use dataset with predicted values ;
*** We want phat on Y axis;
*** category variable is X-axis variable;
proc sgplot data=pred;
vbox phat /category=y;

yaxis grid values=(0 to 0.8 by 0.1) label="Estimated predicted probability" ;
xaxis Label="Nodal involvement" ;

format y y.;
run;


**** Enhanced code;
*** category variable is X-axis variable;;;
proc sgplot data=pred  noborder;
vbox phat /category=y;

yaxis grid values=(0.2 to 0.7 by 0.05) label="Estimated predicted probability" labelattrs=(size=12pt) valueattrs=(size=12pt);
xaxis Label="Nodal involvement "  labelattrs=(size=12pt) valueattrs=(size=12pt);

format y y.;
run;


