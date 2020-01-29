*---Hypothesis test for Two Proportions ---*
************ TENNIS EXAMPLE;

Data tennis;
input trt $ response_reduce $ count;
datalines;
TRT Y 35
TRT N 8
PLA Y 21
PLA N 23
;
run;


**** chisq test;

***If you are interested in the difference in the probability of responding Yes between two treatment , the RISKDIFF option provides an estimate as well as a confidence interval.;
PROC FREQ DATA=tennis order =data;
 TABLES trt*response_reduce/ EXPECTED CHISQ riskdiff;  
 weight count;
RUN; 

***The ORDER=DATA option, while not necessary to display the table and conduct a proper analysis, 
assures that the levels defining the rows and columns appear in the same order as they are encountered in when reading the data set.;


/**-----------------------------------------------------**/
**** Alternate way  to calculate phat Confidence interval ;
**** in data step;
**** p1 is the proportion of subjects taking ibuprofen who show improvement  
= 35/43 = 0.81 ;

**** p1 is the proportion of subjects taking Placebo who show improvement  
***=21/44 = 0.48;

data propn;
input text $ p N;
datalines;
P1 0.81 43
P2 0.48  44
;
run;


*****Confidence interval for proportions ;
**** Formula phat +- 1.96*SQRT(phat(1-phat)/n);

data propn_CI; 
set propn;
LB = P - ( 1.96*SQRT( P*(1-P)/N ) ) ;

* reset lower bound to 0 if <0 ;

IF LB < 0 THEN LB = 0 ;

UB = P + ( 1.96*SQRT( P*(1-P)/N ) ) ;

* reset upper bound to 1 if >1 ;

IF UB > 1 Then UB = 1 ;

label p = "Proportion Cured"

LB = "Lower Bound"

UB = "Upper Bound" ;

run;

*Print Results;

Proc Print data=propn_CI;
format LB UB 4.2;

run;
