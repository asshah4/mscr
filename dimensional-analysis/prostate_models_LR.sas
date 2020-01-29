*libname a "H:\MSCR509\spring2017\lecture3";

libname save ".";


data prostate; 
set save.prostate_data2;


run;



proc contents data=prostate;run;
/*--------------------------------------------------------------------*/

*** Simple frequecy for y=1: 36 out of 92 =39% were positive;
proc freq data=prostate;
tables y size;
run;

/*--------------------------------------------------------------------*/

**** verify distribution of size with Y using cross tab syntax;
proc freq data=prostate;
tables size*y  / expected chisq;
run;


*** Logistic regression model 1;

**** We are modelling probility of Y=1 (presence  of nodal involvement ) using (event='1') syntax ;
**** sie of tumor: 0 = small, 1 = large;
proc logistic data=prostate;
class  size(ref="0") /param=ref;
model y(event='1')= size/risklimits ;
run;
****INTERPRETATION of Odds ratio: The odds of presence  of nodal involvement for subjects with large tumore is exp(1.3863) =4.000
times that for subjects with small tumor.  The effect of size of tumor was  significant P=0.0032 at the .05 level.;
;


/*--------------------------------------------------------------------*/
****  Logistic regression model 2;


**** We are modelling probility of Y=1 (presence  of nodal involvement ) using (event='1') syntax ;
**** sie of tumor: 0 = small, 1 = large;
**** age of patient at diagnosis (in years)
;
proc logistic data=prostate;
class  size(ref="0") /param=ref;
model y(event='1')= size age/risklimits ;
run;
**** INTERPRETATION of Odds ratio: Controlling for age, the odds of presence  of nodal involvement for subjects with large tumore is exp(1.3944) =4.033
times that for subjects with small tumor.  The effect of size of tumor was  significant P=0.0033 at the .05 level.;
;


***** Draw a Barchart of nodal involvement by size of tumor;

***1  Find percent nodal involvement by size of tumor;

proc freq data=prostate;
tables size*y  / ;
run;

*** NOTE 27/51= 52.94% subjects with large tumor had nodal involvment, 9/41=21.95 subjects with with small tumor had nodal involvment;

**2 Now create a dataset that has above numbers by tumor size;

data taskc;
  input nNodalYes percent tumorsize $8-25;
  
  datalines;        
27 .53 Large Tumor 
9  .22 Small Tumor       
;
run;

**3;
/*--VBar 1 Simple code--*/
proc sgplot data=taskc ;
  title 'Percentage of subjects with nodal involvment  by Tumor Size';
  vbar tumorsize/ response=percent ;

  xaxis  display=(nolabel) ;
  yaxis   label= "Number of Subjects with nodal involvement" ;
  
  run;


**4;
/*--VBar 1 Enhanced code--*/
proc sgplot data=taskc ;
  title 'Percentage of subjects with nodal involvment  by Tumor Size';
  vbar tumorsize/ response=percent nostatlabel  datalabel  datalabelattrs=(size=10  color=blue) barwidth=0.3 fillattrs=(color=red);

  xaxis  display=(nolabel) valueattrs=(size=10) ;
  yaxis   label= "Number of Subjects with nodal involvement" values=(0 to .6 by .1) valueattrs=(size=10) grid;
  format percent percent5.1;
  run;



  
