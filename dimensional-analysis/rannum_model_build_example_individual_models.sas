
*libname in 	'S:\bios\Amita Manatunga\BIOS509M_2014\sas';;

libname in '.';

proc freq data=in.rannum1; tables x10;run;
proc means data=in.rannum1 min max;run;

data rannum0;
 set in.rannum1;
run;


ods listing;

***0 intercept only. -2LOG L = 302.538;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=/;
run;


***1. -2LOG L = 302.538;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x1 /;
run;
**************** improvement =0.00001 P value=0.99 ~1.00;
data pvalue; 
chisq= 302.538- 302.538;*** improvemnt;
*P= 1- cdf('chisq',302.538 - 302.538,1);
P= 1- cdf('chisq',chisq,1);
run;

proc print data=pvalue;  run;


/*---------------------------*/
***2. -2LOG L = 301.453;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x2 /;
run;

**************** improvement =1.085 P value=0.2976;
data pvalue;
chisq= 302.538 - 301.453;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;


/*---------------------------*/
***3. -2LOG L = 259.755;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x3 /;
run;

**************** improvement =42.783 P value=6.1161E-11;
data pvalue;
chisq= 302.538 - 259.755;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;


/*---------------------------*/
***4. -2LOG L = 301.676;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x4 /;
run;

**************** improvement =0.862 P value=0.35318;
data pvalue;
chisq= 302.538 - 301.676;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;


/*---------------------------*/
***5. -2LOG L = 300.311;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x5 /;
run;

**************** improvement =2.227 P value=0.13562;
data pvalue;
chisq= 302.538 - 300.311;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;



/*---------------------------*/
***6. -2LOG L = 302.516;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x6 /;
run;

**************** improvement =0.022 P value=0.88209;
data pvalue;
chisq= 302.538 - 302.516;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;





/*---------------------------*/
***7. -2LOG L = 301.158;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x7 /;
run;

**************** improvement =1.38 P value=0.24010;
data pvalue;
chisq= 302.538 - 301.158;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;



/*---------------------------*/
***8. -2LOG L = 280.639;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x8 /;
run;

**************** improvement =21.899 P value=.000002874;
data pvalue;
chisq= 302.538 - 280.639;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;



/*---------------------------*/
***9. -2LOG L = 301.611;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x9 /;
run;

**************** improvement =0.927 P value=0.33564;
data pvalue;
chisq= 302.538 - 301.611;*** improvemnt;
P= 1- cdf('chisq',chisq,1);

run;

proc print data=pvalue;  run;


/*---------------------------*/
***10. -2LOG L = 272.367;
proc logistic data=rannum0;
 class x10(ref='1')/param=ref;
 model y(event='1')=x10 /;
run;

**************** improvement =30.171 P value=3.9558E-8 df=2 for 2 betas;
data pvalue;
chisq= 302.538 - 272.367;*** improvemnt;
P= 1- cdf('chisq',chisq,2);

run;

proc print data=pvalue;  run;


