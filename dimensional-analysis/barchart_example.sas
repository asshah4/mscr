/*-- Barchart example  barplot of improvement (week8_result=1) by gender--*/

libname save "S:\bios\amita manatunga\MSCR_509M_2020\lecture2";

 proc format ;
value sex 1="Male" 2="Female";
value improv 1="Negative (Improved)" 0="Positive (Not improved)";
  run;

***1  Find percent improved by gender;
  proc freq data=save.diseaseX;
tables week8_result*gender  ;
 format gender sex.  week8_result improv.;
run;
*** NOTE 89/105= 84.76% males improved, 59/64=92.19 females improved;

**2 Now create a dataset that has above numbers by gender;

data taskc;
  input nImproved percent gender $8-25;
  *format percent percent5.1;
  datalines;        
89 .85 Male 
59 .92 Female        
;
run;


**3 ;
/*--VBar 1 Simple code--*/
proc sgplot data=taskc ;
  title 'Percentage of subjects with Improvement at week 8 by Gender';
  vbar Gender/ response=percent ;

  xaxis  display=(nolabel)  ;
  yaxis   label= "Number of Subjects with Improvement (%)" ;

  run;

**4;
/*--VBar 1 Enhanced code--*/
proc sgplot data=taskc ;
  title 'Percentage of subjects with Improvement at week 8 by Gender';
  vbar Gender/ response=percent nostatlabel  datalabel  datalabelattrs=(size=10  color=blue) barwidth=0.3 fillattrs=(color=red);

  xaxis  display=(nolabel) valueattrs=(size=10) ;
  yaxis   label= "Number of Subjects with Improvement (%)" values=(0 to 1 by .1) valueattrs=(size=10) grid;
  format percent percent5.1;
  run;



  

 
