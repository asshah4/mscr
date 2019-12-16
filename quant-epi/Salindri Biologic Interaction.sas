*Example from Annals of Epidemiology manuscript PMID: 30954339; 

*Supplemental Table 2: Biological Interaction;
libname matt 'C:\Users\mjmagee\Box Sync\MSCR\530 Fall 2019\Participation\In class exercise\Interaction analysis';

DATA work.interaction;
SET matt.three;
/* Make sure that no missing gets
coded as 00 */
IF HIV1 ^=. AND tstest2 ^=. THEN DO;
/* non-HIV and TST Negative */
IF HIV1 = 0 AND tstest2 = 1
THEN bi01 = 1;
ELSE bi01 = 0;
/* HIV and TST Positive */
IF HIV1 = 1 AND TSTEST2 = 2
THEN bi10 = 1;
ELSE bi10 = 0;
/* HIV and TST negative */
IF HIV1 = 1 AND TSTEST2 = 1
THEN bi11 = 1;
ELSE bi11 = 0;
END;

IF dm2 ^=. AND tstest2 ^=. THEN DO;
/* non-DM and TST Negative */
IF dm2 = 0 AND tstest2 = 1
THEN dmbi01 = 1;
ELSE dmbi01 = 0;
/* DM and TST Positive */
IF dm2 = 1 AND TSTEST2 = 2
THEN dmbi10 = 1;
ELSE dmbi10 = 0;
/* DM and TST negative */
IF dm2 = 1 AND TSTEST2 = 1
THEN dmbi11 = 1;
ELSE dmbi11 = 0;
END;

if dm2 = 1 AND TSTEST2 = 1 THEN DM_NTST = 1;
else DM_NTST = 0;

if hiv1 = 1 AND TSTEST2 = 1 THEN HIV_NTST = 1;
else HIV_NTST = 0;

run;

proc print data=interaction;
var hiv1 tstest2 bi01 bi10 bi11;
run;

proc print data=interaction;
var dm2 tstest2 dmbi01 dmbi10 dmbi11;
run;

*FREQ TABLE;

proc format;
value tst 0='negative'
		  1='positive';
value die 0='not died'
		  1='died';
run;

*First Row: HIV;
proc freq data=matt.three;
table tstest*Tx_Outcome3;
where HIV1=0;
format tstest tst. Tx_outcome3 die.;
run;

proc freq data=matt.three;
table tstest*Tx_Outcome3;
where HIV1=1;
format tstest tst. Tx_outcome3 die.;
run;

*HIV*;
*CRUDE;
proc genmod data = interaction descending;
 model tx_outcome3= bi01 bi10 bi11/ dist =poisson link=log covb;
run;

*Multivariable model 10: Adjusted for age, gender, HIV, diabetes, ESRD, cavitary, miliary, alcohol;
proc genmod data = interaction descending;
 class age_group1 (ref="2") sex (ref="0") cavity1 (ref="0") 
       dm2 (ref="0") esrd1 (ref="0") miliary1 (ref="0") alcohol1 (ref="0") foreign1 (ref="0")/param=ref;
 model tx_outcome3=bi01 bi10 bi11 age_group1 sex cavity1 dm2 esrd1 miliary1 alcohol1 foreign1 / dist =poisson link=log covb;
run;

*Second Row: 
DM;
proc freq data=three;
table tstest*Tx_Outcome3;
where dm=0;
format tstest tst. Tx_outcome3 die.;
run;

proc freq data=three;
table tstest*Tx_Outcome3;
where dm=1;
format tstest tst. Tx_outcome3 die.;
run;

*DM*
*crude;
proc genmod data = interaction descending;
 model tx_outcome3= dmbi01 dmbi10 dmbi11/ dist =poisson link=log covb;
run;

*Multivariable model 10: adjusted for age, gender, HIV, diabetes, ESRD, cavitary, miliary, alcohol;
proc genmod data = interaction descending;
 class age_group1 (ref="2") sex (ref="0") cavity1 (ref="0") 
       hiv2 (ref="0") esrd1 (ref="0") miliary1 (ref="0") alcohol1 (ref="0")/param=ref;
 model tx_outcome3=dmbi01 dmbi10 dmbi11 age_group1 sex cavity1 hiv2 esrd1 miliary1 alcohol1 foreign1/ dist =poisson link=log covb;
run;

