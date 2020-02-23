libname a ".";


data prostate; set a.prostate_data2;
run;



*****  AIC 117.797;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= ses/risklimits
  ;

run;



*****  AIC 104.726;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= xray age/risklimits
  ;

run;


*****  AIC 100.097;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= xray ses/risklimits
  ;

run;
