

*****  backward selection;
**** selected variables acid xray ;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= acid xray  size grade ses age
                    /risklimits
 selection=backward slstay=0.05 ;

run;
**** force age in the model backward selection;
**** selected variables age acid xray size;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray GRADE ses size/risklimits include=1 details
 selection=backward slstay=0.05 ;

run;

**** selection=forward slentry=0.10 details;
**** selected variables age acid xray size;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray GRADE ses size/risklimits include=1 details
 selection=forward slentry=0.10 ;

run;

**** subset ;
**** selected variables age acid xray size;
proc logistic data=prostate;
class  xray(ref="0") GRADE(ref="0") size(ref="0") ses(ref="low")/param=ref;
model y(event='1')= age acid xray GRADE ses size/risklimits include=1 details
 selection=stepwise slentry=0.05 slstay=0.05  ;

run;
