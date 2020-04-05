
*libname c  'S:\bios\Amita Manatunga\BIOS509M_2013\';

libname c ".";

*** read data;
data work.csf;
infile 'csfdata.txt' lrecl=9999;
  input group$ x1-x140;
run;
ods listing;
*** logical record length LRECL=n | nK | nM | nG | nT | hexX | MIN | MAX 
 to use for reading and writing external files;
**** hexX example :2dx sets the logical record length to 45 characters;
** n example: 1–32767;

*** Lrecl sets the maximum length of a record or observation of a SAS dataset. 
It is equal to the cumulative length of all the variables of the dataset.;

/***--------------------------***/
/***--------- Method 1 -------***/
/***--------------------------***/

* Do 140 t-tests;
ods select none;
proc ttest data=work.csf;
  var x1 -- x140;
  class group;
  ods output ttests=work.csftests;
run;
ods select all;
* Do only the pooled t-tests results;
data work.csftests;
  set work.csftests;
  if variances="Equal";
run;

* Sort in ascending order of p-values;
proc sort data=work.csftests;
  by probt;
run;
* Print results;
**** 33 proteins with P<0.05;
proc print data=work.csftests;
run;


*Calculate FDR adjusted p-values;

data work.csftests;
  set work.csftests;
  fdr = min(140/(140-_n_+1)*probt, lag(fdr));
run;

proc print data=work.csftests;
run;
*****************************;
***** Method 2 Using fdr option ****;
***************************;
proc multtest data=work.csf fdr bon;
  test mean (x1 -- x140);
  class group;
  ods output pvalues=work.csfmulttest_fdr;
run;

proc sort data=work.csfmulttest_fdr;
  by raw;
run;
**** 12 proteins with P<0.05;
proc print data=work.csfmulttest_fdr;
run;
