


data example;
input x y;
cards;
2.5 2.4
0.5 0.7
2.2 2.9
1.9 2.2
3.1 3.0
2.3 2.7
2  1.6
1  1.1
1.5 1.6
1.1 0.9
;
run;
title;
proc print;
run;
ods listing;
proc means;
run;

proc corr  cov;
var x y;
run;

options nocenter ;
*** with cov option;
proc princomp out=prins data=example cov 
                    outstat=prinstat;
var x y;
run;

proc print data=prins;
run;

proc print data=prinstat;
run;

proc corr data=prins;
var prin1 prin2 x y;
run;
*** without cov option  correlation matrix;
proc princomp  data=example /*cov*/ out=prins2;run;

proc corr data=prins2;
var prin1 prin2 x y;
run;
proc corr cov;
var y x;
run;

