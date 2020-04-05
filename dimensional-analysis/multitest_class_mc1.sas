
*libname c  'S:\bios\Amita Manatunga\BIOS509M_2013\';

libname c ".";

*** read data;
data work.csf;
infile 'csfdata.txt' lrecl=9999;
  input group$ x1-x140;
run;
ods listing;

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
* Only the pooled t-tests results;
data work.csftests;
  set work.csftests;
  if variances="Equal";
run;
* Calculate Bonferroni adjusted p-values;
data work.csftests;
  set work.csftests;
  bon = probt*140;
  if bon > 1 then bon = 1;
run;
* Sort in ascending order of p-values;
proc sort data=work.csftests;
  by probt;
run;
* Print results;
proc print data=work.csftests;
run;


/***--------------------------***/
/***--------- Method 2 -------***/
/***--------------------------***/
ods listing;
* Do t-tests and calc Bonferroni;ods select none;
proc multtest data=work.csf bon;
  test mean (x1 -- x140);
  class group;
  ods output pvalues=work.csfmulttest;
run;
ods select all;

* Sort in ascending order of p-values;
proc sort data=work.csfmulttest;
  by raw;
run;
* Print results;
proc print data=work.csfmulttest;
run;


